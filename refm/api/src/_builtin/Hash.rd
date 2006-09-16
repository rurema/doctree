= class Hash < Object
include Enumerable

ハッシュテーブル(連想配列とも呼ぶ)のクラス。ハッシュは任意の種類のオブ
ジェクトから任意の種類のオブジェクトへの関連づけを行うことができます。
ハッシュ生成は以下のようなハッシュ式で行われます。

  {a=>b, ... }

ハッシュの格納に用いられるハッシュ値の計算には、
[[m:Object#hash]] メソッドが使われ、キーの同一性判定には、
[[m:Object#eql?]] メソッドが使われます。

キーとして与えたオブジェクトの内容が変化し、メソッド hash の返す
値が変わるとハッシュから値が取り出せなくなりますから、[[c:Array]]、
[[c:Hash]] などのインスタンスはキーに向きません。文字列をキーとして与
えると、文字列をコピーし、コピーを更新不可に設定(freeze)してキーとして
使用します。キーとして使われている文字列を更新しようとすると例外
[[c:TypeError]] が発生します。

== Class Methods

--- [](key,value,...)
--- [](hash)

新しいハッシュを生成します。一番目の形式では、引数は必ず偶数個指定
しなければなりません。(奇数番目がキー、偶数番目が値)。

二番目の形式(1つのハッシュオブジェクトを引数に指定した場合)は、指
定したハッシュと同一のキーと値を持つ新たなハッシュを生成して返しま
す。(生成されたハッシュのデフォルト値は nil です。)

以下は配列からハッシュを生成する方法の例です(より直接的な方法があ
るのではと思うかも知れませんが残念ながらありません)。

(1) [キー, 値, ...] の配列からハッシュへ

  ary = [1,"a", 2,"b", 3,"c"]
  p Hash[*ary]
  
  # => {1=>"a", 2=>"b", 3=>"c"}

(2) キーと値のペアの配列からハッシュへ

  alist = [[1,"a"], [2,"b"], [3,"c"]]
  p Hash[*alist.flatten]
  
  #=> {1=>"a", 2=>"b", 3=>"c"}

(3) キーと値の配列のペアからハッシュへ(version 1.7 以降)

  keys = [1, 2, 3]
  vals = ["a", "b", "c"]
  alist = keys.zip(vals)   # あるいは alist = [keys,vals].transpose
  p Hash[*alist.flatten]
  
  #=> {1=>"a", 2=>"b", 3=>"c"}

(4) キーや値が配列だと (2) や (3) の方法は使えないので地道に代入するしかない

  h = Hash.new
  alist = [[1,["a"]], [2,["b"]], [3,["c"]]]
  alist.each {|k,v|
    h[k] = v
  }
  p h
  
  #=> {1=>["a"], 2=>["b"], 3=>["c"]}

--- new([ifnone])
--- new {|hash, key| ...}

空の新しいハッシュを生成します。ifnone はキーに対
応する値が存在しない時のデフォルト値です。
デフォルト値の扱いには注意が必要です( [[trap:Hash]] )。

#@if (version >= "1.7.0")
((<ruby 1.7 feature>)):
ブロックを指定した場合は、ブロックの評価結果がデフォルト値になりま
す。値が設定されていないハッシュ要素を参照するとその都度ブロックを
実行し、その結果を返します。ブロックにはそのハッシュとハッシュを参
照したときのキーが渡されます。

  # ブロックではない場合デフォルト値の変更により
  # 他の値も変更されたように見える
  h = Hash.new("foo")
  p h[1]                  # => "foo"
  p h[1] << "bar"         # => "foobar"
  p h[1]                  # => "foobar"
  p h[2]                  # => "foobar"
  
  
  # ブロックを使うとうまく行く
  h = Hash.new {|hash, key| hash[key] = "foo"}
  p h[1]                  # => "foo"
  p h[1] << "bar"         # => "foobar"
  p h[1]                  # => "foobar"
  p h[2]                  # => "foo"
  
  # 値が設定されていないときに(fetchのように)例外をあげるようにもできる
  h = Hash.new {|hash, key|
                  raise(IndexError, "hash[#{key}] has no value")
               }
  h[1]
  # => hash[1] has no value (IndexError)
#@end

== Instance Methods

--- [](key)

key に関連づけられた値を返します。該当するキーが登
録されていない時には、デフォルト値(設定されていない時には
nil) を返します。
値としての nil と区別する必要がある場合は [[m:Hash#fetch]]
を使ってください。

--- []=(key, value)
--- store(key,value)

key に対して value を関連づけます。value を返し
ます。

--- clear

ハッシュの中身を空にします。self を返します。

--- clone
--- dup

レシーバと同じ内容を持つ新しいハッシュを返します。フリーズしたハッ
シュの clone は同様にフリーズされたハッシュを返しますが、
dup は内容の等しいフリーズされていないハッシュを返します。

--- default
--- default([key])

ハッシュのデフォルト値を返します。

#@if (version >= "1.7.0")
((<ruby 1.7 feature>)):
2 番目の形式はハッシュがデフォルト値としてブロックを持つ場合
([[m:Hash#Hash.new]]参照)に指定できます。self と 引数
key を引数にブロックを実行してその結果を返します。
key の省略値は nil です。
#@end

--- default=(value)

ハッシュのデフォルト値を value に設定します。対応する値が存
在しないキーで検索した時にはこの値を返します。

value を返します。

--- default_proc

ハッシュのデフォルト値を返す [[c:Proc]] オブジェクトを返します。
デフォルトの [[c:Proc]] を持たない場合 nil を返します。

  h = Hash.new {|h, k| }
  p h.default_proc        # => #<Proc:0x0x401a9ff4>

  h = Hash.new(1)
  p h.default_proc        # => nil

--- delete(key)
--- delete(key) {|key| ... }

key に対する関連を取り除きます。取り除かれた値を返しますが、
key に対応する値が存在しない時には nil を返します。

ブロックが与えられた時には key にマッチするものがな
かった時に評価し、その結果を返します。

--- reject {|key, value| ... }

self を複製して、ブロックを評価した値が真になる要
素を削除したハッシュを返します。

ハッシュを返すことを除けば
[[m:Enumerable#reject]] と同じです。

--- delete_if {|key, value| ... }
--- reject! {|key, value| ... }

key と value を引数としてブロックを評価した値が真であ
る時、その要素を self から削除します。

delete_if は常に self を返します。
reject! は、要素を削除しなかった場合には nil を返し、
そうでなければ self を返します。

--- each {|key, value| ... }
--- each_pair {|key, value| ... }

key と value を引数としてブロックを評価します。
self を返します。

  {:a=>1, :b=>2}.each_pair {|k, v| p [k, v]}

  # => [:a, 1]
       [:b, 2]

#@if (version >= "1.8.0")
((<ruby 1.8 feature>)):

each と each_pair ではブロックパラメータの受渡し方が異なります。

  each:      yield([key, val])
  each_pair: yield(key, val)

このことにより、each_pair のブロックパラメータに一つの変数を指
定した場合、以下のように警告が出ます。詳細は、
[[unknown:メソッド呼び出し/yield]] を参照してください。

  {:a=>1, :b=>2}.each_pair {|a| p a }
  # => -:1: warning: multiple values for a block parameter (2 for 1)
          from -:1
       [:a, 1]
       -:1: warning: multiple values for a block parameter (2 for 1)
          from -:1
       [:b, 2]
#@end

--- each_key {|key| ... }

key を引数としてブロックを評価します。
self を返します。

--- each_value {|value| ... }

valueを引数としてブロックを評価します。
self を返します。

--- empty?

ハッシュが空の時真を返します。

--- fetch(key[, default])
--- fetch(key) {|key| ... }

key に関連づけられた値を返します。該当するキーが登録されてい
ない時には、引数 default が与えられていればその値を、ブロッ
クが与えられていればそのブロックを評価した値を返します。そのいずれ
でもなければ例外 [[c:IndexError]] が発生します。

#@if (version >= "1.9.0")
(((<ruby 1.9 feature|ruby 1.9 feature/2004-09-22>)):
[[c:IndexError]] の代わりに [[c:IndexError]] のサブクラスの
[[c:KeyError]] が発生します。)
#@end

--- has_key?(key)
--- include?(key)
--- key?(key)
--- member?(key)

ハッシュが key をキーとして持つ時真を返します。

--- has_value?(value)
--- value?(value)

ハッシュが value を値として持つ時真を返します。
値の一致判定は == で行われます。

--- index(val)
--- key(val)

val に対応するキーを返します。対応する要素が存在しない時には
nil を返します。

該当するキーが複数存在する場合、どのキーを返すかは不定です。

#@if (version >= "1.9.0")
((<ruby 1.9 feature|ruby 1.9 feature/2004-09-22>)):
Hash#index は version 1.9 では、((<obsolete>)) です。
使用すると警告メッセージが表示されます。
#@end

--- indexes(key_1, ... , key_n)         ((<obsolete>))
--- indices(key_1, ... , key_n)         ((<obsolete>))

引数で指定されたキーを持つ値の配列を返します。

#@if (version >= "1.8.0")
((<ruby 1.8 feature>)):
このメソッドは version 1.8 では、((<obsolete>)) です。
使用すると警告メッセージが表示されます。
代わりに [[m:Hash#values_at]] を使用します。
#@end

--- invert

値からキーへのハッシュを返します。
異なるキーに対して等しい値が登録されている場合の結果は不定であることに
注意してください、そのような場合にこのメソッドを利用することは意図され
ていません。

  h = { "n" => 100, "m" => 100, "y" => 300, "d" => 200, "a" => 0 }
  h.invert   #=> {200=>"d", 300=>"y", 0=>"a", 100=>"n"}

--- keys

全キーの配列を返します。

--- length
--- size

ハッシュの要素の数を返します。

#@if (version >= "1.8.0")
--- merge(other)
--- merge(other) {|key, self_val, other_val| ... }
--- merge!(other)
--- merge!(other) {|key, self_val, other_val| ... }

((<ruby 1.8 feature>))

Hash#merge は、hash.dup.[[m:Hash#update]] と同じです。
Hash#merge! は、[[m:Hash#update]] の別名です。

self と other に同じキーがあった場合はブロック付きか否かで
判定方法が違います。ブロック付きのときはブロックを呼び出して
どちらの値を使うかをユーザに選択させます。ブロック付きでない
場合は常に other の値を使います。
#@end

--- rehash

キーのハッシュ値を再計算します。キーになっているオブジェクトのハッシュ
値が変わってしまった場合、このメソッドを使ってハッシュ値を再計算しない
限り、そのキーに対応する値を取り出すことができなくなります。

--- replace(other)

ハッシュの内容を other の内容で置き換えます。
self を返します。

--- shift

ハッシュから要素をひとつ取り除き、[key,value] という配列とし
て返します。

ハッシュが空の場合、デフォルト値[[m:Hash#default]]を持たなければ
nil を、デフォルト値を持つならその値を返します(このとき、
[key,value] という形式の値を返すわけではないことに注意)。

  h = Hash.new
  p h.empty?              # => true
  p h[0]                  # => nil
  p h.shift               # => nil
  p h.default             # => nil
  h.each {|v| p v}        # =>
  p h.to_a                # => []

  h1 = Hash.new("default value")
  p h1.empty?             # => true
  p h1[0]                 # => "default value"
  p h1.shift              # => "default value"
  p h1.default            # => "default value"
  h1.each {|v| p v}       # =>
  p h1.to_a               # => []

#@if (version >= "1.7.0")
  # ruby 1.7 feature
  h2 = Hash.new {|arg| arg}
  p h2.empty?             # => true
  p h2[0]                 # => [{}, 0]
  p h2.shift              # => [{}, nil]
  p h2.default            # => [{}, nil]
  h2.each {|v| p v}       # =>
  p h2.to_a               # => []
#@end

--- to_a

[key,value] からなる 2 要素の配列の配列を生成して返します。

--- to_hash

self を返します。

--- update(other)
--- update(other) {|key, self_val, other_val| ... }

ハッシュの内容をマージします。重複するキーに対応する値は
other の内容で上書きされます。

#@if (version >= "1.7.0")
((<ruby 1.7 feature>)):
ブロックが与えられた場合は、重複するキーごとにブロックを評価してそ
の結果をそのキーに対応する値にします。ブロックには引数としてキーと
self[key] 、other[key] が渡されます。

  foo = {1 => 'a', 2 => 'b', 3 => 'c'}
  bar = {1 => 'A', 2 => 'B', 3 => 'C'}
  p foo.dup.update(bar)                   # => {1=>"A", 2=>"B", 3=>"C"}
  p foo.dup.update(bar) {|k,v| v}         # => {1=>"a", 2=>"b", 3=>"c"}
#@end

self を返します。

--- values

ハッシュの全値の配列を返します。

#@if (version >= "1.8.0")
--- values_at(key_1, ... , key_n)

((<ruby 1.8 feature>))

引数で指定されたキーに対応する値の配列を返します。キーに対応する値
がなければ [[m:Hash#default]] の戻り値が使用されます。
[[m:Hash#indexes]] と [[m:Hash#indices]] と同じです。

  h = {1=>"a", 2=>"b", 3=>"c"}
  p h.values_at(1,3,4)               # => ["a", "c", nil]
#@end