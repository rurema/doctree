---
library: sdbm
include:
  - Enumerable
---
# class SDBM < Object

SDBM ファイルをアクセスするクラス。

キー、データともに文字列でなければならないという制限と、
データがファイルに保存されるという点を除いては [c:Hash] クラスと
全く同様に扱うことができます。

- **SEE** [c:Hash]

## Class Methods

### def new(dbname, mode = 0666) -> SDBM

dbname で指定したデータベースをモードを mode に設定してオープンします。

- **param** `dbname` -- データベースの名前を指定します。

- **param** `mode` -- 省略値は 0666 です。mode として nil を指定するとデータベースが
            存在しない時には新たなデータベースを作らず nil を返します。

### def open(dbname, mode = 0666) -> SDBM
### def open(dbname, mode = 0666) {|db| ... } -> object

dbname で指定したデータベースをモードを mode に設定してオープンします。

- **param** `dbname` -- データベースの名前を指定します。

- **param** `mode` -- 省略値は 0666 です。mode として nil を指定するとデータベースが
            存在しない時には新たなデータベースを作らず nil を返します。


## Instance Methods

### def [](key) -> String

key をキーとする値を返します。

- **param** `key` -- キー。

### def []=(key, value)

key をキーとして、value を格納します。

value として nil を指定すると、key に対する項目を削除します。

- **param** `key` -- キー。
- **param** `value` -- 格納する値。

### def clear -> self

DBM ファイルを空にします。

### def close -> nil

DBM ファイルをクローズします。

以後の操作は例外を発生させます。

### def closed? -> bool

DBM ファイルが既に閉じられているかどうかを返します。

既に閉じられていれば true を返します。
そうでなければ false を返します。


### def delete(key) -> String

key をキーとする項目を削除します。

- **param** `key` -- キー。

- **return** -- 削除した要素の値を返します。

`````
require 'sdbm'
  
db1 = SDBM.open('aaa.gdbm', 0666)
db1['a'] = 'aaa'
db1['b'] = 'bbb'
db1['c'] = 'ccc'
  
p db1.delete('a') #=> 'aaa'
`````


### def reject! { |key, value|  ...  }   -> self
### def delete_if { |key, value|  ...  } -> self

ブロックを評価した値が真であれば該当する項目を削除します。

`````
require 'sdbm'
  
db1 = SDBM.open('aaa.gdbm', 0666)
db1['a'] = 'aaa'
db1['b'] = 'bbb'
db1['c'] = 'ccc'
  
p db1                                    #=> #<SDBM:0xb7cc96f8>
p db1.reject!{ |key, value| key == 'a' } #=> #<SDBM:0xb7cc96f8>
`````


### def reject {|key, value| ... } -> Hash

ブロックを評価した値が真であれば該当する要素を削除します。

`````
self.to_hash.reject{|key, value| ... }
`````

と同じです。

- **SEE** [m:Hash#reject]

### def each {|key, value|  ...  } -> self
### def each_pair {|key, value|  ...  } -> self

各要素に対するイテレータ。

### def each_key {|key|  ...  } -> self

全ての key に対して繰り返すイテレータ。

### def each_value {|value|  ...  } -> self

全ての value に対して繰り返すイテレータ。

### def empty? -> bool

データベースが空の時、真を返します。

### def has_key?(key) -> bool
### def key?(key) -> bool
### def include?(key) -> bool
### def member?(key) -> bool

key がデータベース中に存在する時、真を返します。

- **param** `key` -- 検索したいキー。

### def has_value?(value) -> bool
### def value?(value) -> bool

value を値とする組がデータベース中に存在する時、真を返します。

- **param** `value` -- 検索したい値。

#@until 1.9.1
### def indexes(*keys) -> [[String]]
### def indices(*keys) -> [[String]]

各引数の値をキーとする要素を含む配列を返します。

このメソッドは obsolete です。

- **param** `keys` -- 検索したいキーです。

`````
require 'sdbm'
  
db1 = SDBM.open('aaa.gdbm', 0666)
db1['a'] = 'aaa'
db1['b'] = 'bbb'
db1['c'] = 'ccc'
  
p db1.indexes('a', 'b') #=> ["aaa", "bbb"]
`````

#@end

#@since 1.9.1
### def key(value) -> String | nil

与えられた値に対応するキーを返します。

対応する要素が存在しない時には nil を返します。
値に対応するキーが複数ある場合は最初に見つかったキーを返します。

- **param** `value` -- キーを探したい値を指定します。

#@end

### def keys -> [String]

データベース中に存在するキー全てを含む配列を返します。

`````
require 'sdbm'
  
db1 = SDBM.open('aaa.gdbm', 0666)
db1['a'] = 'aaa'
db1['b'] = 'bbb'
db1['c'] = 'ccc'
p db1.keys #=> ["a", "b","c"]
`````

### def length -> Integer
### def size   -> Integer

データベース中の要素の数を返します。

### 注意

現在の実現では要素数を数えるためにデータベースを全部検索します。

### def shift -> [String]

データベース中の要素を一つ取り出し、データベースから削除します。

`````
require 'sdbm'
  
db1 = SDBM.open('aaa.gdbm', 0666)
db1['a'] = 'aaa'
db1['b'] = 'bbb'
db1['c'] = 'ccc'
p db1.shift #=> ["a", "aaa"]
`````

### def values -> [String]

データベース中に存在する値全てを含む配列を返します。

### def replace(other) -> self

self の内容を other の内容で置き換えます。

- **param** `other` -- each_pair メソッドを持つオブジェクトでなければなりません。

`````
require 'sdbm'
  
db1 = SDBM.open('aaa.gdbm', 0666)
db1['a'] = 'aaa'
db1['b'] = 'bbb'
db1['c'] = 'ccc'
db2 = SDBM.open('bbb.gdbm', 0666)
db2['c'] = 'ccc'
db2['d'] = 'ddd'
hash = { 'x' => 'xxx', 'y' => 'yyy'}
  
p db1               #=> #<SDBM:0xb7c304d0>
p db1.to_hash       #=> {"a"=>"aaa", "b"=>"bbb", "c"=>"ccc"}
p db1.replace(db2)  #=> #<SDBM:0xb7c304d0>
p db1.to_hash       #=> {"c"=>"ccc", "d"=>"ddd"}
p db1.replace(hash) #=> #<SDBM:0xb7c304d0>
p db1.to_hash       #=> {"x"=>"xxx", "y"=>"yyy"}
`````


### def fetch(key, ifnone = nil){|key| ... } -> object

データベースから対応するキーを探してその要素の値を返します。

- **param** `key` --     探索するキー。
- **param** `ifnone` --  対応するキーが見つからなかった場合に返す値。

- **raise** `IndexError` -- ifnone が設定されていないときに、対応するキーが
                  見つからなかった場合に発生します。

`````
require 'sdbm'
  
db1 = SDBM.open('aaa.gdbm', 0666)
db1['a'] = 'aaa'
db1['b'] = 'bbb'
db1['c'] = 'ccc'
  
p db1.fetch('a')                             #=> "aaa"
p db1.fetch('z', 'zzz')                      #=> "zzz"
p db1.fetch('z'){|key| [:key, key] }         #=> [:key, "z"]
p db1.fetch('z', 'zzz'){|key| [:key, key] }  #=> "zzz"
p db1.fetch('z')                             #=> IndexError 発生
`````


### def store(key, val) -> [String]

key に対して val を格納します。

- **SEE** [m:SDBM#\[\]=]

### def select{|key, value| ... } -> [[String]]

ブロックを評価して真になった要素のみを配列に格納して返します。

`````
require 'sdbm'
  
db1 = SDBM.open('aaa.gdbm', 0666)
db1.clear
db1['a'] = 'aaa'
db1['b'] = 'bbb'
db1['c'] = 'ccc'
  
p db1.select{ |key, value| key == 'a' } #=> [["a", "aaa"]]
p db1.select{ |key, value| key != 'a' } #=> [["c", "ccc"], ["b", "bbb"]]
`````

### def values_at(*keys) -> [String]

keys に対応する値を配列に格納して返します。

- **param** `keys` -- キー。複数指定可能です。

`````
require 'sdbm'
  
db1 = SDBM.open('aaa.gdbm', 0666)
db1['a'] = 'aaa'
db1['b'] = 'bbb'
db1['c'] = 'ccc'
  
p db1.values_at('a', 'b')  #=> ["aaa", "bbb"]
`````

### def invert -> Hash

値からキーへのハッシュを返します。

`````
require 'sdbm'
  
db1 = SDBM.open('aaa.gdbm', 0666)
db1.clear
db1['a'] = 'aaa'
db1['b'] = 'bbb'
db1['c'] = 'ccc'
  
p db1.invert #=> {"aaa"=>"a", "bbb"=>"b", "ccc"=>"c"}
`````

### def update(other) -> self

self と other の内容をマージします。

重複するキーに対応する値はother の内容で上書きされます。

- **param** `other` -- each_pair メソッドを持つオブジェクトでなければなりません。

`````
require 'sdbm'
  
db1 = SDBM.open('aaa.gdbm', 0666)
db1.clear
db1['a'] = 'aaa'
db1['b'] = 'bbb'
db1['c'] = 'ccc'
db2 = SDBM.open('bbb.gdbm', 0666)
db2.clear
db2['c'] = 'ccc'
db2['d'] = 'ddd'
hash = { 'x' => 'xxx', 'y' => 'yyy'}
  
p db1               #=> #<SDBM:0xb7d19554>
p db1.to_hash       #=> {"a"=>"aaa", "b"=>"bbb", "c"=>"ccc"}
p db1.update(db2)   #=> #<SDBM:0xb7d19554>
p db1.to_hash       #=> {"a"=>"aaa", "b"=>"bbb", "c"=>"ccc", "d"=>"ddd"}
p db1.update(hash)  #=> #<SDBM:0xb7d19554>
p db1.to_hash       #=> {"a"=>"aaa", "x"=>"xxx", "b"=>"bbb", "y"=>"yyy", "c"=>"ccc", "d"=>"ddd"}
`````

### def to_a -> [[String]]

self の各要素を格納した配列を返します。

返される配列の1つの要素は [key, value] です。
つまり配列の配列を返します。

`````
require 'sdbm'
  
db1 = SDBM.open('aaa.gdbm', 0666)
db1.clear
db1['a'] = 'aaa'
db1['b'] = 'bbb'
db1['c'] = 'ccc'
  
p db1.to_a #=> [["a", "aaa"], ["b", "bbb"], ["c", "ccc"]]
`````

### def to_hash -> Hash

self の各要素を格納したハッシュを返します。

`````
require 'sdbm'
  
db1 = SDBM.open('aaa.gdbm', 0666)
db1.clear
db1['a'] = 'aaa'
db1['b'] = 'bbb'
db1['c'] = 'ccc'
  
p db1.to_hash #=> {"a"=>"aaa", "b"=>"bbb", "c"=>"ccc"}
`````

### def index(val) -> String | nil

#@since 1.9.1
このメソッドは deprecated です。[m:SDBM#key] を使用してください。
#@else
値 val に対応するキーを返します。

対応する要素が存在しない時には nil を返します。
該当するキーが複数存在する場合、どのキーを返すかは不定です。

- **SEE** [m:Hash#index]
#@end

