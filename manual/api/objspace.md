---
type: library
---
このライブラリは [c:ObjectSpace] を拡張してオブジェクトやメモリ管理についての
統計情報を取得するメソッドをいくつか追加します。

MRI の実装について詳しくない一般のユーザはこのライブラリを使ってはいけません。
このライブラリは、メモリプロファイラの開発者や MRI がどのようにメモリを使用するか
知りたい MRI 開発者が使用します。

# reopen ObjectSpace

## Module Functions

### module_function def count_objects_size(result_hash = nil) -> Hash

型ごとのオブジェクトサイズをバイト単位で格納したハッシュを返します。

- **param** `result_hash` -- 戻り値のためのハッシュを指定します。省略した場合は新
                   しくハッシュを作成します。result_hash の内容は上書き
                   されます。プローブ効果を避けるために使用します。

戻り値の内容は完全ではない事に注意してください。この内容はあくまでもヒ
ントとして扱う必要があります。特に T_DATA の合計値は正しくないでしょう。

```ruby title="例"
p ObjectSpace.count_objects_size
# => {:TOTAL=>1461154, :T_CLASS=>158280, :T_MODULE=>20672, :T_STRING=>527249, ...}
```

- **raise** `TypeError` -- result_hash にハッシュ以外を指定した時に発生します。

戻り値のハッシュは処理系に依存します。これは将来変更になるかもしれません。

本メソッドは C Ruby 以外では動作しません。

### module_function def memsize_of(obj) -> Integer

obj が消費するメモリ使用量をバイト単位で返します。

- **param** `obj` -- 任意のオブジェクトを指定します。

戻り値の内容は完全ではない事に注意してください。この内容はあくまでもヒ
ントとして扱う必要があります。特に T_DATA の値は正しくないでしょう。
2.2 以降では RVALUE のサイズを含んだ結果を返します。

本メソッドは C Ruby 以外では動作しません。

```ruby title="例"
require 'objspace'

p ObjectSpace.memsize_of(10)          # => 0
#%# todo 0 になる理由
p ObjectSpace.memsize_of("12345" * 10)  # => 91
```

### module_function def memsize_of_all(klass = nil) -> Integer

すべての生存しているオブジェクトが消費しているメモリ使用量をバイト単位
で返します。

- **param** `klass` -- 指定したクラスのインスタンスのメモリ使用量を返します。省略
             した場合はすべてのクラスのインスタンスのメモリ使用量を返し
             ます。

本メソッドは以下のような Ruby のコードで定義できます。

```ruby title="例"
def memsize_of_all klass = false
  total = 0
  ObjectSpace.each_object{|e|
    total += ObjectSpace.memsize_of(e) if klass == false || e.kind_of?(klass)
  }
  total
end
```

戻り値の内容は完全ではない事に注意してください。この内容はあくまでもヒ
ントとして扱う必要があります。特に T_DATA の値は正しくないでしょう。

また、同様に戻り値の内容は malloc されたメモリの合計でもない事に注意し
てください。

本メソッドは C Ruby 以外では動作しません。

### module_function def count_nodes(result_hash = nil) -> Hash

ノードの種類ごとの数を格納したハッシュを返します。

- **param** `result_hash` -- 戻り値のためのハッシュを指定します。省略した場合は新
                   しくハッシュを作成します。result_hash の内容は上書き
                   されます。プローブ効果を避けるために使用します。

- **raise** `TypeError` -- result_hash にハッシュ以外を指定した時に発生します。

本メソッドは普通の Ruby プログラマ向けのメソッドではありません。パフォー
マンスやメモリ管理に興味のある C Ruby の開発者向けのものです。

```ruby title="例"
p ObjectSpace.count_nodes
# => {:NODE_METHOD=>2027, :NODE_FBODY=>1927, :NODE_CFUNC=>1798, ...}
```

戻り値のハッシュは処理系に依存します。これは将来変更になるかもしれません。

本メソッドは C Ruby 以外では動作しません。

### module_function def count_tdata_objects(result_hash = nil) -> Hash

T_DATA の種類ごとにオブジェクトの数を格納したハッシュを返します。

- **param** `result_hash` -- 戻り値のためのハッシュを指定します。省略した場合は新
                   しくハッシュを作成します。result_hash の内容は上書き
                   されます。プローブ効果を避けるために使用します。

- **raise** `TypeError` -- result_hash にハッシュ以外を指定した時に発生します。

本メソッドは普通の Ruby プログラマ向けのメソッドではありません。パフォー
マンスに興味のある C Ruby の開発者向けのものです。

```ruby title="例"
p ObjectSpace.count_tdata_objects
# => {RubyVM::InstructionSequence=>504, :parser=>5, :barrier=>6,
#     :mutex=>6, Proc=>60, RubyVM::Env=>57, Mutex=>1, Encoding=>99,
#     ThreadGroup=>1, Binding=>1, Thread=>1, RubyVM=>1, :iseq=>1,
#     Random=>1, ARGF.class=>1, Data=>1, :autoload=>3, Time=>2}
```

現在のバージョンでは、戻り値のキーはクラスオブジェクトかシンボルのオブ
ジェクトです。

普通の参照可能なオブジェクトの場合、キーはクラスオブジェクトです。それ
以外の内部的なオブジェクトの場合、キーはシンボルです。シンボルの値は
rb_data_type_struct に格納された名前が使用されます。

戻り値のハッシュは処理系に依存します。これは将来変更になるかもしれません。

本メソッドは C Ruby 以外では動作しません。

### module_function def reachable_objects_from(obj) -> Array | nil

obj から到達可能なすべてのオブジェクトを返します。マーク不能なオブジェ
クトを指定した場合は nil を返します。本メソッドを使う事でメモリリークの
調査が行えます。

```ruby title="例"
# 配列クラス(Array)と 'a'、'b'、'c' に到達可能。
p ObjectSpace.reachable_objects_from(['a', 'b', 'c'])
# => [Array, 'a', 'b', 'c']
```

obj が 2 つ以上の同じオブジェクト x への参照を持つ場合、戻り値に含まれ
るオブジェクト x は 1 つだけです。

```ruby title="例"
# 配列クラス(Array)と v に到達可能。
p ObjectSpace.reachable_objects_from([v = 'a', v, v])
# => [Array, 'a']

# 配列クラス(Array)と 3 つの異なる 'a' オブジェクトに到達可能。
p ObjectSpace.reachable_objects_from(['a', 'a', 'a'])
# => [Array, 'a', 'a', 'a']
```

obj にマーク不能なオブジェクト(true、false、nil、[c:Symbol]、
即値の [c:Integer]、Flonum(即値の [c:Float] オブジェクト))を指定した場合は
nil を返します。

```ruby title="例"
# 1 はマーク不能
p ObjectSpace.reachable_objects_from(1)
# => nil
```

obj が内部でオブジェクトへの参照を持つ場合、
ObjectSpace::InternalObjectWrapper オブジェクトが戻り値に含まれます。こ
のオブジェクトは obj が内部で持っているオブジェクトを持ちます。内部のオ
ブジェクトの型を確認する場合は ObjectSpace::InternalObjectWrapper#type
を参照してください。:T_CLASS のような [c:Symbol] を返します。

obj が ObjectSpace::InternalObjectWrapper オブジェクトであった場合、そ
のオブジェクトから参照される全てのオブジェクトを返します。

本メソッドは C Ruby 以外では動作しません。

- **SEE** <https://www.atdot.net/~ko1/diary/201212.html#d8>,
     <https://www.atdot.net/~ko1/diary/201212.html#d9>

### module_function def reachable_objects_from_root -> Hash

VM のルート(仮想マシンやグローバル変数テーブルなど、ガベージコレクタが
生存しているオブジェクトをマークする際に辿る起点)から直接到達可能なオブ
ジェクトを、ルートごとにグループ分けしたハッシュを返します。戻り値の
キーはルートの名前を表す文字列、値はそのルートから到達可能なオブジェク
トの配列です。

```ruby title="例"
require 'objspace'

reachable = ObjectSpace.reachable_objects_from_root
p reachable.keys
# => ["vm", "global_tbl", "machine_context"]
# (内容やキーの構成は処理系やバージョン、実行時の状態に依存します)
```

戻り値のハッシュはキーを同一性で比較するため、文字列リテラルを使ってキー
を指定して参照することはできません。[m:Hash#keys] や [m:Hash#values] な
どで取得してください。

内部オブジェクトへの参照は `ObjectSpace::InternalObjectWrapper` オブジェ
クトでラップされます。詳しくは [m:ObjectSpace?.reachable_objects_from]
を参照してください。

本メソッドはメモリリークの原因を調査するなど、オブジェクトグラフのデバッ
グに役立ちます。

本メソッドは C Ruby 以外では動作しません。

- **SEE** [m:ObjectSpace?.reachable_objects_from]

### module_function def trace_object_allocations_start -> nil

オブジェクト割り当てのトレースを開始します。

- **SEE** [m:ObjectSpace?.trace_object_allocations_stop]

### module_function def trace_object_allocations_stop -> nil

オブジェクト割り当てのトレースを終了します。

トレースを終了する為には、[m:ObjectSpace?.trace_object_allocations_start]を呼んだ回数分だけこのメソッドを呼ぶ必要があります。

- **SEE** [m:ObjectSpace?.trace_object_allocations_start]

### module_function def trace_object_allocations_clear -> nil

記録されているオブジェクト割り当てのトレース情報をクリアします。

トレースの有効/無効の状態には触れません。トレースを
有効にしたまま呼び出すと、それ以降のオブジェクト割り当てが引き続き記録
されます。

```ruby title="例"
require 'objspace'

ObjectSpace.trace_object_allocations_start
obj = Object.new
p ObjectSpace.allocation_sourceline(obj) # => 4
ObjectSpace.trace_object_allocations_clear
p ObjectSpace.allocation_sourceline(obj) # => nil

ObjectSpace.trace_object_allocations_stop
```

- **SEE** [m:ObjectSpace?.trace_object_allocations_start],
     [m:ObjectSpace?.trace_object_allocations_stop]

### module_function def allocation_sourcefile(object) -> String | nil

objectの元となったソースファイル名を返します。

- **param** `object` -- 元となるソースファイル名を取得したいobjectを指定します。
- **return** -- objectの元となるソースファイル名を返します。存在しない場合はnilを返します。

```ruby title="例:test.rbというファイルで下記のスクリプトを実行した場合"
require 'objspace'

ObjectSpace.trace_object_allocations_start
obj = Object.new
puts "file:#{ObjectSpace.allocation_sourcefile(obj)}"   # => file:test.rb
ObjectSpace.trace_object_allocations_stop
```

- **SEE** [m:ObjectSpace?.trace_object_allocations_start],
     [m:ObjectSpace?.trace_object_allocations_stop]

### module_function def allocation_sourceline(object) -> Integer | nil

objectの元となったソースファイルの行番号を返します。

- **param** `object` -- 元となるソースファイルの行番号を取得したいobjectを指定します。
- **return** -- objectの元となるソースファイルの行番号を返します。存在しない場合はnilを返します。

```ruby title="例"
require 'objspace'

ObjectSpace.trace_object_allocations_start
obj = Object.new
puts "line:#{ObjectSpace.allocation_sourceline(obj)}"  # => line:4
ObjectSpace.trace_object_allocations_stop
```

- **SEE** [m:ObjectSpace?.trace_object_allocations_start],
     [m:ObjectSpace?.trace_object_allocations_stop]

### module_function def allocation_class_path(object) -> String | nil

objectの元となったクラスのパス(クラス名)を返します。

- **param** `object` -- 元となるクラスのパスを取得したいobjectを指定します。
- **return** -- objectの元となるクラスのパスを返します。存在しない場合はnilを返します。

```ruby title="例"
require 'objspace'

class A
  def foo
    ObjectSpace.trace_object_allocations do
      obj = Object.new
      p ObjectSpace.allocation_class_path(obj)
    end
  end
end

A.new.foo
# => "Class"
```

- **SEE** [m:ObjectSpace?.trace_object_allocations_start],
     [m:ObjectSpace?.trace_object_allocations_stop]

### module_function def allocation_method_id(object) -> Symbol | nil

objectの元となったメソッド名を返します。

- **param** `object` -- 元となるメソッド名を取得したいobjectを指定します。
- **return** -- objectの元となるメソッド名を返します。存在しない場合はnilを返します。

```ruby title="例"
require 'objspace'

class A
  include ObjectSpace

  def foo
    trace_object_allocations do
      obj = Object.new
      p "#{allocation_class_path(obj)}##{allocation_method_id(obj)}"
    end
  end
end

A.new.foo
# => "Class#new"
```

- **SEE** [m:ObjectSpace?.trace_object_allocations_start],
     [m:ObjectSpace?.trace_object_allocations_stop]

### module_function def allocation_generation(object) -> Integer | nil

objectが生成されたときのガベージコレクタの実行回数([m:GC.count] が返
す値と同じもの)を返します。

- **param** `object` -- 生成時のガベージコレクタの実行回数を取得したいobjectを指定します。
- **return** -- objectが生成されたときのガベージコレクタの実行回数を返します。存在しない場合はnilを返します。

```ruby title="例"
require 'objspace'

class B
  include ObjectSpace

  def foo
    trace_object_allocations do
      obj = Object.new
      p "Generation is #{allocation_generation(obj)}"
    end
  end
end

B.new.foo
# => "Generation is 4"
```

- **SEE** [m:ObjectSpace?.trace_object_allocations_start],
     [m:ObjectSpace?.trace_object_allocations_stop]

### module_function def trace_object_allocations { ... }

与えられたブロック内でオブジェクトのトレースを行います。　

```ruby title="例"
require 'objspace'

class C
  include ObjectSpace

  def foo
    trace_object_allocations do
      obj = Object.new
      p "#{allocation_sourcefile(obj)}:#{allocation_sourceline(obj)}"
    end
  end
end

p C.new.foo #=> "objtrace.rb:8"
```

### module_function def dump(obj, output: :string) -> String | File | IO | nil

obj の内容を JSON 形式でダンプします。

- **param** `obj` -- ダンプ対象のオブジェクトを指定します。
- **param** `output` -- ダンプ結果の出力先を以下のいずれかで指定します(デフォルトは `:string`)。

- **`:string`**:
  文字列としてダンプ結果を返します。
- **`:file`**:
  一時ファイルにダンプし、その [c:File] オブジェクトを返します。
- **`:stdout`**:
  標準出力にダンプし、nil を返します。
- **IO オブジェクト**:
  指定した IO オブジェクトにダンプし、その IO オブジェクトを返します。
  (StringIO のような IO のサブクラスでないオブジェクトは指定できません)

```ruby title="例"
require 'objspace'

puts ObjectSpace.dump(5)
# => 5

puts ObjectSpace.dump("hello")
# => {"address":"0x...", "type":"STRING", "shape_id":0, "slot_size":40,
#    "class":"0x...", "embedded":true, "chilled":true, "bytesize":5,
#    "value":"hello", "encoding":"UTF-8", "coderange":"7bit",
#    "memsize":40, "flags":{"wb_protected":true}}
# (address の値は実行するたびに変わります)
```

- **raise** `ArgumentError` -- output に上記のいずれでもない値を指定した場合に発生します。

戻り値の内容は完全ではない事に注意してください。この内容はあくまでもヒ
ントとして扱う必要があります。

本メソッドは C Ruby 以外では動作しない、実験的なメソッドです。出力の
フォーマットは将来のバージョンで変更される可能性があります。

- **SEE** [m:ObjectSpace?.dump_all]

#%since 3.2
### module_function def dump_all(output: :file, full: false, since: nil, shapes: true) -> String | File | IO | nil
#%else
### module_function def dump_all(output: :file, full: false, since: nil) -> String | File | IO | nil
#%end

Ruby のヒープの内容を JSON 形式でダンプします。1行につき1オブジェクト
(または1ルート、1シェイプ)分の JSON が出力されます。

- **param** `output` -- ダンプ結果の出力先を指定します。指定できる値は
  [m:ObjectSpace?.dump] の output と同じです(デフォルトは `:file`)。
- **param** `full` -- 真を指定すると、空きスロット(`T_NONE`)も含めたすべ
  てのヒープスロットをダンプします。偽の場合(デフォルト)は使用中のスロッ
  トのみダンプします。
- **param** `since` -- 0 以上の整数または nil を指定します。正の整数を指
  定した場合、その世代以降に割り当てられたオブジェクトのみをダンプしま
  す。現在の世代は [m:GC.count] で取得できます。[m:ObjectSpace?.trace_object_allocations_start]
  などでオブジェクト割り当てのトレースを有効にしていないオブジェクトは
  割り当て世代が記録されないため無視されます。nil を指定した場合(デフォ
  ルト)はすべてのオブジェクトをダンプします。
#%since 3.2
- **param** `shapes` -- 真偽値または 0 以上の整数を指定します。正の整数
  を指定した場合、指定した shape_id 以降のシェイプのみをダンプします。
  現在の shape_id は `RubyVM.stat(:next_shape_id)` で取得できます。false
  を指定するとシェイプをダンプしません。デフォルトは true です。
#%end

```ruby title="例"
require 'objspace'

str = ObjectSpace.dump_all(output: :string)
puts str.lines.size
# => 18369 (ヒープの状態に依存するため実行するたびに変わります)
```

```ruby title="例:sinceで割り当て世代を絞り込む"
require 'objspace'

ObjectSpace.trace_object_allocations_start
GC.start
gen = GC.count
obj = "new string"
str = ObjectSpace.dump_all(output: :string, since: gen)
puts str.lines.size
ObjectSpace.trace_object_allocations_stop
# => 234 (実行するたびに変わります)
```

#%since 3.2

```ruby title="例:shapesを無効にする"
require 'objspace'

str = ObjectSpace.dump_all(output: :string, shapes: false)
p str.lines.grep(/"type":"SHAPE"/).size
# => 0
```

#%end

- **raise** `ArgumentError` -- output に [m:ObjectSpace?.dump] で指定できる値以外を指定した場合に発生します。

戻り値の内容は完全ではない事に注意してください。この内容はあくまでもヒ
ントとして扱う必要があります。

本メソッドは C Ruby 以外では動作しない、実験的なメソッドです。出力の
フォーマットは将来のバージョンで変更される可能性があります。

- **SEE** [m:ObjectSpace?.dump], [m:ObjectSpace?.trace_object_allocations_start]
