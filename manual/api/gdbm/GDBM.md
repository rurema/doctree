---
library: gdbm
include:
  - Enumerable
---
# class GDBM < Object

GDBM ファイルをアクセスするクラス。

キー、データともに文字列でなければならないという制限と、
データがファイルに保存されるという点を除いては [c:Hash] クラスと
全く同様に扱うことができます。

## Class Methods

### def new(dbname, mode = 0666, flags = 0) -> GDBM

dbname で指定したデータベースをモードを mode に設定してオープンします。

- **param** `dbname` -- データベースの名前を指定します。

- **param** `mode` -- 省略値は 0666 です。mode として nil を指定するとデータベースが
            存在しない時には新たなデータベースを作らず nil を返します。

- **param** `flags` -- flags には、[m:GDBM::FAST], [m:GDBM::SYNC], [m:GDBM::NOLOCK]
             の論理和を指定します。デフォルト値は指定なし(つまり0)です。
             flags に [m:GDBM::READER], [m:GDBM::WRITER], [m:GDBM::WRCREAT], [m:GDBM::NEWDB]
             のいずれかを与えて読み書きのモードを指定できます。
             これらをどれも指定しなかった場合には、
             [m:GDBM::WRCREAT], [m:GDBM::WRITER], [m:GDBM::READER] の順で試します。

### def open(dbname, mode = 0666, flags = 0) -> GDBM
### def open(dbname, mode = 0666, flags = 0) {|db| ... } -> object

dbname で指定したデータベースをモードを mode に設定してオープンします。

ブロックを指定した場合、オープンした GDBM オブジェクトを
引数にブロックを実行します。実行後 GDBM オブジェクトをクローズ
し、open メソッドはブロックの結果を返します。

- **param** `dbname` -- データベースの名前を指定します。

- **param** `mode` -- 省略値は 0666 です。mode として nil を指定するとデータベースが
            存在しない時には新たなデータベースを作らず nil を返します。

- **param** `flags` -- flags には、[m:GDBM::FAST], [m:GDBM::SYNC], [m:GDBM::NOLOCK]
             の論理和を指定します。デフォルト値は指定なし(つまり0)です。
             flags に [m:GDBM::READER], [m:GDBM::WRITER], [m:GDBM::WRCREAT], [m:GDBM::NEWDB]
             のいずれかを与えて読み書きのモードを指定できます。
             これらをどれも指定しなかった場合には、
             [m:GDBM::WRCREAT], [m:GDBM::WRITER], [m:GDBM::READER] の順で試します。

```ruby
require 'gdbm'
GDBM.open("fruitstore.db") do |gdbm|
  gdbm.each_pair do |key, value|
    print "#{key}: #{value}\n"
  end
end
```


## Instance Methods

### def [](key) -> String

key をキーとする値を返します。

- **param** `key` -- キー。

### def []=(key, value)

key をキーとして、value を格納します。

- **param** `key` -- キー。
- **param** `value` -- 格納する値。

### def cachesize=(size)

内部のキャッシュのサイズを指定します。

詳しくは [man:gdbm(3)] の GDBM_CACHESIZE の項を参照ください。

- **param** `size` -- 新しい内部のキャッシュサイズ。

- **SEE** [man:gdbm(3)]

### def clear -> self

DBM ファイルを空にします。

### def close -> nil

DBM ファイルをクローズします。

以後の操作は例外 [c:RuntimeError] を発生させます。

### def closed? -> bool

DBM ファイルが既に閉じられている場合は、真を返します。
そうでない場合は、偽を返します。


### def delete(key) -> object | nil
### def delete(key) {|key| ... } -> object

与えられた key に対応する項目を削除します。

- **param** `key` -- キーを指定します。

- **return** -- 指定したキーが存在する場合は、キーに対応する値を返します。
        指定したキーが存在しない場合は、 nil を返します。
        また、キーが存在しない場合にブロックを与えている場合は、ブロックを評価した結果を返します。

```ruby
require 'gdbm'
GDBM.open("a.db") do |db|
  db['a'] = "aaa"
  db['d'] = "ddd"
  p db.delete("a") # => "aaa"
  p db.delete("b") # => nil
  p db.delete("c"){|k| "c is missing" } # => "c is missing"
  p db.delete("d"){|k| "d is missing" } # => "ddd"
end
```

### def delete_if { |key, value|  ...  } -> self
### def reject! { |key, value|  ...  } -> self

ブロックを評価した値が真であれば該当する項目を削除します。

このメソッドは self を破壊的に変更します。

### def each {|key, value|  ...  } -> self
### def each_pair {|key, value|  ...  } -> self

各要素に対するイテレータです。

### def each_key {|key|  ...  } -> self

全ての key に対して繰り返すイテレータです。

### def each_value {|value|  ...  } -> self

全ての value に対して繰り返すイテレータです。

### def empty? -> bool

データベースが空の時、真を返します。

### def fastmode=(bool)

オープンしている GDBM オブジェクトのモードを変更します。

このオプションはデフォルトで on です。
このオプションは obsolete です。

このオプションが on のときは、GDBM はディスクへの書き込みを待たずに
次の操作を続けます。

- **param** `bool` -- 新たにセットするモード。

- **SEE** [m:GDBM::FAST], [m:GDBM#syncmode=]

### def syncmode=(bool)

オープンしている GDBM オブジェクトのモードを変更します。

このオプションはデフォルトで off です。

このオプションが on のときは、GDBM はデータベースの変更操作ごとに
データベースの状態を同期します。

- **param** `bool` -- 新たにセットするモード。

- **SEE** [m:GDBM::SYNC], [m:GDBM#fastmode=]

### def fetch(key, ifnone = nil){|key| ... } -> object

データベースから対応するキーを探してその要素の値を返します。

- **param** `key` --     探索するキー。
- **param** `ifnone` --  対応するキーが見つからなかった場合に返す値。

- **raise** `IndexError` -- ifnone が設定されていないときに、対応するキーが
                  見つからなかった場合に発生します。

```ruby
require 'gdbm'
  
db1 = GDBM.open('aaa.gdbm', 0666, GDBM::NEWDB)
db1['a'] = 'aaa'
db1['b'] = 'bbb'
  
p db1.fetch('a')                            #=> 'aaa'
p db1.fetch('z', 'zzz')                     #=> 'zzz'
p db1.fetch('z'){|key| [:key, key] }        #=> [:key, 'z']
p db1.fetch('z', 'zzz'){|key| [:key, key] } #=> 'zzz'
p db1.fetch('z')                            #=> IndexError 発生
```

- **SEE** [m:Hash#fetch]

### def has_key?(key) -> bool
### def key?(key) -> bool
### def include?(key) -> bool
### def member?(key) -> bool

key がデータベース中に存在する時、真を返します。

### def has_value?(value) -> bool
### def value?(value) -> bool

value を値とする要素がデータベース中に存在する時、真を返します。

- **param** `value` -- 検索したい値。

### def index(val) -> String

このメソッドは deprecated です。[m:GDBM#key] を使用してください。


### def invert -> Hash

値からキーへのハッシュを返します。

```ruby
require 'gdbm'
  
db1 = GDBM.open('aaa.gdbm', 0666, GDBM::NEWDB)
db1['a'] = 'aaa'
db1['b'] = 'bbb'
p db1.invert #=> {"aaa"=>"a", "bbb"=>"b"}
```


### def key(value) -> String | nil

与えられた値に対応するキーを返します。

対応する要素が存在しない時には nil を返します。
値に対応するキーが複数ある場合は最初に見つかったキーを返します。

- **param** `value` -- キーを探したい値を指定します。


### def keys -> [String]

データベース中に存在するキー全てを含む配列を返します。

```ruby
require 'gdbm'
  
db1 = GDBM.open('aaa.gdbm', 0666, GDBM::NEWDB)
db1['a'] = 'aaa'
db1['b'] = 'bbb'
p db1.keys #=> ["a", "b"]
```


### def length -> Integer
### def size   -> Integer

データベース中の要素の数を返します。

現在の実現では要素数を数えるためにデータベースを全部検索します。

### def reject {|key, value| ... } -> Hash

ブロックを評価した値が真であれば該当する要素を削除します。

```text
self.to_hash.reject{|key, value| ... }
```

と同じです。

- **SEE** [m:Hash#reject]

### def reorganize -> self

DB ファイルの再編成を行います。

GDBM では、要素の削除を行っても DB ファイルのサイズは減少しません(削
除によって空いた領域は次の格納のために取っておかれます)。
このメソッドを呼び出すことで DBM ファイルを新規に作り直し無駄な領域をなく
すことができます。

大量の削除を行ったときに、ディスクスペースの節約のために使用します。

### def replace(other) -> self

self の内容を other の内容で置き換えます。

- **param** `other` -- each_pair メソッドを持つオブジェクトでなければなりません。

```ruby
require 'gdbm'
  
db1 = GDBM.open('aaa.gdbm', 0666, GDBM::NEWDB)
db1['a'] = 'aaa'
db1['b'] = 'bbb'
db2 = GDBM.open('bbb.gdbm', 0666, GDBM::NEWDB)
db2['c'] = 'ccc'
db2['d'] = 'ddd'
hash = { 'x' => 'xxx', 'y' => 'yyy'}
  
p db1               #=> #<GDBM:0xb7d1c8a8>
p db1.replace(db2)  #=> #<GDBM:0xb7d1c8a8>
p db1.replace(hash) #=> #<GDBM:0xb7d1c8a8>
```


### def select{|key, value| ... } -> [[String]]

ブロックを評価して真になった要素のみを配列に格納して返します。

```ruby
require 'gdbm'
  
db1 = GDBM.open('aaa.gdbm', 0666, GDBM::NEWDB)
db1['a'] = 'aaa'
db1['b'] = 'bbb'
db1['c'] = 'ccc'
  
p db1.select{ |key, value| key == 'a' } #=> [["a", "aaa"]]
p db1.select{ |key, value| key != 'a' } #=> [["c", "ccc"], ["b", "bbb"]]
```

- **SEE** [m:Hash#select]

### def shift -> [String]

データベース中の要素を一つ取り出し、データベースから削除します。

```ruby
require 'gdbm'
  
db1 = GDBM.open('aaa.gdbm', 0666, GDBM::NEWDB)
db1['a'] = 'aaa'
db1['b'] = 'bbb'
  
p db1.shift #=> ["a", "aaa"]
```

### def store(key, val) -> [String]

key に対して val を格納します。

- **SEE** [m:GDBM#\[\]=]

### def sync -> self

要素の変更をファイルに反映します。

FAST モード([m:GDBM.open] の第3引数に [m:GDBM::FAST] を指定)のときだけ意味があります。

### 注意
GNU gdbm version 1.8 以降より FAST モードがデフォルトになりました。

### def to_a -> [[String]]

self の各要素を格納した配列を返します。

返される配列の1つの要素は [key, value] です。
つまり配列の配列を返します。

### def to_hash -> Hash

self の各要素を格納したハッシュを返します。

### def update(other) -> self

self と other の内容をマージします。

重複するキーに対応する値はother の内容で上書きされます。

- **param** `other` -- each_pair メソッドを持つオブジェクトでなければなりません。

### def values -> [String]

データベース中に存在する値全てを含む配列を返します。

### def values_at(*keys) -> [String]

keys に対応する値を配列に格納して返します。

- **param** `keys` -- キー。複数指定可能です。

```ruby
require 'gdbm'
  
db1 = GDBM.open('aaa.gdbm', 0666, GDBM::NEWDB)
db1['a'] = 'aaa'
db1['b'] = 'bbb'
db1['c'] = 'ccc'
  
p db1.values_at('a', 'b') #=> ["aaa", "bbb"]
p db1.values_at('x', 'y') #=> [nil, nil]
```


## Constants

### const VERSION -> String

libgdbm のバージョン情報の文字列です。


### const FAST -> Integer

[m:GDBM.open] の第3引数に指定します。

書き込みの結果が、ディスク上のファイルにすぐに反映しなくなります。
このモードのときに結果を明示的にファイルに反映させるには [m:GDBM#sync]
メソッドを呼びます。libgdbm version 1.8.0 以降ではこのモードがデフォルト
です。

### const SYNC -> Integer

[m:GDBM.open] の第3引数に指定します。

書き込みの結果が、ディスク上のファイルにすぐに反映されます。
libgdbm version 1.8.0 以前のデフォルトモードです。

この定数は libgdbm version 1.8.0 以降より有効です。

### const NOLOCK -> Integer

[m:GDBM.open] の第3引数に指定します。

通常、他のプロセスが DB をオープンしている最中にオープンを行うと
[c:Errno::EWOULDBLOCK](または [c:Errno::EAGAIN]) 例外が発生します。
このフラグを指定していれば、他のプロセスがオープンしている最中でも同時
オープンできます。

この定数は libgdbm version 1.8.0 以降より有効です。

### const READER -> Integer

[m:GDBM.open] の第3引数に指定します。

読み込みモードでオープンします。

### const WRITER -> Integer

[m:GDBM.open] の第3引数に指定します。

書き込みモードでオープンします。

### const WRCREAT -> Integer

[m:GDBM.open] の第3引数に指定します。

書き込みモードで、すでにファイルが存在しなかったら作ります。


### const NEWDB -> Integer

[m:GDBM.open] の第3引数に指定します。

書き込みモードで、すでにファイルが存在したら削除してから作り直します。


