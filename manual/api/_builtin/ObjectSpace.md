---
library: _builtin
---
# module ObjectSpace

全てのオブジェクトを操作するためのモジュールです。

## Module Functions

#%until 4.1
### module_function def _id2ref(id)    -> object

オブジェクト ID([m:BasicObject#__id__])からオブジェクトを得ます。

#%since 4.0
このメソッドは Ruby 4.0 から deprecated です。Warning[:deprecated] が真のとき「ObjectSpace._id2ref is deprecated」という警告を出力します。
将来のバージョンでは削除される予定です。

オブジェクト ID からオブジェクトを引く必要がある場合は、[m:Object#object_id]
をキーとして [c:ObjectSpace::WeakMap] にオブジェクトを保持しておく方法があります。

```ruby
map = ObjectSpace::WeakMap.new
a = "hoge"
map[a.object_id] = a
p map[a.object_id] # => "hoge"
```

#%end

- **param** `id` -- 取得したいオブジェクトの ID を整数で指定します。

- **raise** `RangeError` -- 対応するオブジェクトが存在しなければ発生します。

```ruby title="例"
a = "hoge"
p ObjectSpace._id2ref(a.__id__) # => "hoge"
```

#%end

### module_function def define_finalizer(obj, proc)         -> Array
### module_function def define_finalizer(obj) {|id| ...}    -> Array

obj が解放されるときに実行されるファイナライザ proc を登録します。同じオブジェクトについて複数回呼ばれたときは置き換えではなく追加登録されます。固定値 0 と proc を配列にして返します。

ブロックを指定した場合は、そのブロックがファイナライザになります。
obj の回収時にブロックは obj の ID ([m:BasicObject#__id__])を引数として実行されます。
しかし、後述の問題があるのでブロックでファイナライザを登録するのは難しいでしょう。

- **param** `obj` -- ファイナライザを登録したいオブジェクトを指定します。

- **param** `proc` -- ファイナライザとして [c:Proc] オブジェクトを指定します。proc は obj の回収時に obj の ID を引数として実行されます。

#%since 4.1
- **raise** `Ractor::IsolationError` -- 他の [c:Ractor] が作成したオブジェクトを `obj` に指定した場合に発生します。Ruby 4.1 から、ファイナライザを登録できるのはそのオブジェクトを作成した Ractor だけです。

```ruby title="例: 他の Ractor のオブジェクト"
class Foo; end
r = Ractor.new do
  begin
    ObjectSpace.define_finalizer(Foo, proc {})
  rescue Ractor::IsolationError => e
    e.message
  end
end
p r.value
# => "can not define a finalizer for an object of another Ractor"
```

#%end

### 使い方の注意

以下は、define_finalizer の使い方の悪い例です。

```ruby title="悪い例"
class Foo
  def initialize
    ObjectSpace.define_finalizer(self) {
      puts "foo"
    }
  end
end
Foo.new
GC.start
```

これは、渡された proc の self が obj を参照しつづけるため。そのオブジェクトが GC の対象になりません。

[lib:tempfile] は、ファイナライザの使い方の良い例になっています。これは、クラスのコンテキストで [c:Proc] を生成することで上記の問題を回避しています。

```ruby title="例"
class Bar
  def Bar.callback
    proc {
      puts "bar"
    }
  end
  def initialize
    ObjectSpace.define_finalizer(self, Bar.callback)
  end
end
Bar.new
GC.start
```

proc の呼び出しで発生した大域脱出(exitや例外)は無視されます。
これは、スクリプトのメイン処理が GC の発生によって非同期に中断されるのを防ぐためです。不安なうちは -d オプションで事前に例外の発生の有無を確認しておいた方が良いでしょう。

```ruby title="例"
class Baz
  def initialize
    ObjectSpace.define_finalizer self, eval(%q{
      proc {
        raise "baz" rescue puts $!
        raise "baz2"
        puts "baz3"
      }
    }, TOPLEVEL_BINDING)
  end
end
Baz.new
GC.start

# => baz
```

- **SEE** [d:spec/rubycmd]

### module_function def each_object        {|object| ...}    -> Integer
### module_function def each_object(klass) {|object| ...}    -> Integer
### module_function def each_object                          -> Enumerator
### module_function def each_object(klass)                   -> Enumerator

指定された klass と [m:Object#kind_of?] の関係にある全てのオブジェクトに対して繰り返します。引数が省略された時には全てのオブジェクトに対して繰り返します。
繰り返した数を返します。

ブロックが与えられなかった場合は、
[c:Enumerator] オブジェクトを返します。

次のオブジェクトについては繰り返しません

- 即値の [c:Integer] オブジェクト(ヒープ上に確保される大きな整数は繰り返します)
- Flonum(即値の [c:Float] オブジェクト)
- 静的な [c:Symbol] オブジェクト(動的に生成されたシンボルは繰り返します)
- [c:TrueClass]
- [c:FalseClass]
- [c:NilClass]

なお、[c:Symbol] をすべて列挙するには、かわりに [m:Symbol.all_symbols] が使用できます。

#%since 4.1
Ruby 4.1 からオブジェクト空間は [c:Ractor] ごとに分かれています。呼び出した Ractor が作成したオブジェクトと、他の Ractor の shareable なオブジェクト(クラスやモジュール、freeze された文字列など)だけを繰り返します。他の Ractor が作成した shareable でないオブジェクトは繰り返しません。

Ruby 4.0 までは、main 以外の Ractor を作成したあとは、どの Ractor から呼び出しても shareable なオブジェクトだけを繰り返していました。

すべての Ractor のオブジェクトを調べたい場合は、[lib:objspace] の `ObjectSpace.dump_all` が使えます。
#%end
#%version 3.0...4.1
main 以外の [c:Ractor] を作成したあとは、どの Ractor から呼び出しても shareable なオブジェクト(クラスやモジュール、freeze された文字列など)だけを繰り返します。
#%end

- **param** `klass` -- クラスかモジュールを指定します。

```ruby title="例: ブロックなし"
p ObjectSpace.each_object
# => #<Enumerator: ObjectSpace:each_object(false)>
```

```ruby title="例: 全てのオブジェクトを扱う"
ObjectSpace.each_object.take(5).each { |x| p x }
count = ObjectSpace.each_object { |x| x }
puts "Total count: #{count}"

# => "scope"
# => "scopes"
# => "sym"
# => "class_names"
# => "@corrections"
# => Total count: 9938
```

```ruby title="例: 任意のクラスを扱う"
Person = Struct.new(:name)
s1 = Person.new("tanaka")
s2 = Person.new("sato")

count = ObjectSpace.each_object(Person) { |x| p x }
puts "Total count: #{count}"

# => #<struct Person name="sato">
# => #<struct Person name="tanaka">
# => Total count: 2
```

#%since 4.1

```ruby title="例: 複数の Ractor がある場合"
class Foo; end
objs = 3.times.map { Foo.new }
r = Ractor.new { ObjectSpace.each_object(Foo).count }
p r.value                            # => 0
p ObjectSpace.each_object(Foo).count # => 3
p objs.size                          # => 3
```

#%end

#%since 4.1
### module_function def garbage_collect(full_mark: true, immediate_mark: true, immediate_sweep: true, global: true) -> nil
#%else
### module_function def garbage_collect(full_mark: true, immediate_mark: true, immediate_sweep: true) -> nil
#%end

どこからも参照されなくなったオブジェクトを回収します。
[m:GC.start] と同じです。

- **param** `full_mark` -- マイナー GC を動作させる場合は false を、そうでない場合は true を指定します。

- **param** `immediate_mark` -- mark を遅らせる(Lazy Mark を行う)場合は false
                       を、そうでない場合は true を指定します。

- **param** `immediate_sweep` -- sweep を遅らせる(Lazy Sweep を行う)場合は false
                       を、そうでない場合は true を指定します。

#%since 4.1
- **param** `global` -- 他の [c:Ractor] のオブジェクト空間が存在するときに、全 Ractor を対象とするグローバル GC を行う場合は true(デフォルト)を、呼び出した Ractor だけのメジャー GC を行う場合は false を指定します。Ractor が 1 つしか無いときは効果がありません。詳しくは [m:GC.start] を参照してください。
#%end

注意: これらのキーワード引数は Ruby の実装やバージョンによって異なります。将来のバージョンとの互換性も保証されません。また、Ruby の実装がサポートしていない場合はキーワード引数を指定しても無視される可能性があります。

#%#noexample 参照先の GC.start と同様の動作のため

- **SEE** [m:GC.start]

### module_function def undefine_finalizer(obj)    -> object

obj に対するファイナライザをすべて解除します。
obj を返します。

- **param** `obj` -- ファイナライザを解除したいオブジェクトを指定します。

#%since 4.1
- **raise** `Ractor::IsolationError` -- 他の [c:Ractor] が作成したオブジェクトを `obj` に指定した場合に発生します。Ruby 4.1 から、ファイナライザを解除できるのはそのオブジェクトを作成した Ractor だけです。
#%end

```ruby title="例"
class Sample
  def Sample.callback
    proc {
      puts "finalize"
    }
  end

  def initialize
    ObjectSpace.define_finalizer(self, Sample.callback)
  end

  def undef
    ObjectSpace.undefine_finalizer(self)
  end
end

Sample.new
p GC.start
# => finalize

Sample.new
sample.undef
GC.start
# ※何も出力されない
```

- **SEE** [m:ObjectSpace?.define_finalizer]

### module_function def count_objects(result_hash = {}) -> Hash

オブジェクトを種類ごとにカウントした結果を [c:Hash] として返します。

このメソッドは CRuby 以外の Ruby では動かないでしょう。

- **param** `result_hash` -- ハッシュを指定します。与えられたハッシュは上書きして返されます。
                   これを利用すると測定による影響を避けることができます。

- **raise** `TypeError` -- 引数に [c:Hash] 以外を与えた場合、発生します。

```ruby title="例"
#%since 3.4
p ObjectSpace.count_objects # => {TOTAL: 10000, FREE: 3011, T_OBJECT: 6, T_CLASS: 404, ...}
#%else
p ObjectSpace.count_objects # => {:TOTAL=>10000, :FREE=>3011, :T_OBJECT=>6, :T_CLASS=>404, ...}
#%end
```

