= class DBM < Object

include Enumerable

NDBM ファイルをアクセスするクラス。キー、データともに文字列でなければな
らないという制限と、データがファイルに保存されるという点を除いては
Hash クラスと全く同様に扱うことができます。

== Class Methods

--- open(dbname, mode = 0666, flags = nil) -> DBM
--- open(dbname, mode = 0666, flags = nil) {|db| ... } -> ()

dbname で指定したデータベースをモードを mode に設定してオープンします。

mode の省略値は 0666 です。mode として nil を指定すると
データベースが存在しない時には新たなデータベースを作らず nil を返します。

@param dbname データベース名
@param mode   データベースのオープンモード
#@if (version >= "1.8.2")
@param flags  以下のいずれかを指定します。
: DBM::READER
  データベースの読み込みのみを行う
: DBM::WRITER
  データベースの新規作成はせず読み書きする
: DBM::WRCREAT
  データベースが存在しなければ新規作成して読み書きする
: DBM::NEWDB
  データベースを常に新規作成して既存のデータは破棄する
#@end

== Instance Methods

--- [](key) -> String

key をキーとする値を返します。

@param key キー。

--- []=(key, value)

key をキーとして、value を格納します。
value として nil を指定すると、key に対する要素を削除します。

@param key   キー。
@param value 値。

--- clear -> self

DBM ファイルを空にします。

--- close -> nil

DBM ファイルをクローズします。以後の操作は例外を発生させます。

#@since 1.8.3
--- closed? -> bool

DBM ファイルが既に閉じられているか調べます。

既に閉じられていれば true を返します。そうでなければ false を返します。

#@end

--- delete(key) -> String

key をキーとする要素を削除します。

@return 削除した要素の値を返します。

@raise DBMError 要素の削除に失敗した場合に発生します。

--- reject! { |key, value|  ...  } -> self
--- delete_if { |key, value|  ...  } -> self

ブロックを評価した値が真であれば該当する要素を削除します。

このメソッドは self を破壊的に変更します。


--- reject{ |key, value| ... } -> DBM

ブロックを評価した値が真であれば該当する要素を削除します。



--- each {|key, value|  ...  } -> self
--- each_pair {|key, value|  ...  } -> self

各要素に対するイテレータ。

--- each_key {|key|  ...  } -> self

全ての key に対して繰り返すイテレータ。

--- each_value {|value|  ...  } -> self

全ての value に対して繰り返すイテレータ。

--- empty?() -> bool

データベースが空の時、真を返します。

--- has_key?(key) -> bool
--- key?(key) -> bool
--- include?(key) -> bool
--- member?(key) -> bool

key がデータベース中に存在する時、真を返します。

@param key キー。

--- has_value?(value) -> bool
--- value?(value) -> bool

value を値とする組がデータベース中に存在する時、真を返します。

@param value 検索したい値。

#@if (version < "1.9.0")
--- indexes(*keys) -> Array
--- indices(*keys) -> Array

各引数の値をキーとする要素を含む配列を返します。

このメソッドは obsolete です。
#@end

--- keys -> [String]

データベース中に存在するキー全てを含む配列を返します。

--- length -> Integer
--- size -> Integer

データベース中の要素の数を返します。

現在の実装では要素数を数えるためにデータベースを全部検索します。

--- shift -> String

データベース中の要素を一つ取り出し、データベースから削除します。

--- values -> [String]

データベース中に存在する値全てを含む配列を返します。

--- replace(other) -> self

self の内容を other で書き換えます。

@param other もう一つの DBM オブジェクト。

  require 'dbm'
  
  db1 = DBM.open('aaa.db', 0666, DBM::NEWDB)
  db1[:a] = 'aaa'
  db1[:b] = 'bbbbbb'
  db2 = DBM.open('bbb.db', 0666, DBM::NEWDB)
  db2[:bb] = 'bbb'
  db2[:cc] = 'ccc'
  
  p db1.keys #=> ['b', 'a']
  
  db1.replace(db2)
  
  p db1.keys #=> ['bb', 'cc']
  p db2.keys #=> ['bb', 'cc']

--- fetch(key, ifnone = nil) -> String

データベースからキーを探して対応する値を返します。

@param key    キー。
@param ifnone キーが見つからなかった場合に返す値。

@raise IndexError ifnone を指定していないとき、キーが見つからなかった場合に発生します。

  require 'dbm'
  
  db1 = DBM.open('aaa.db', 0666, DBM::NEWDB)
  db1[:a] = 'aaa'
  db1[:b] = 'bbbbbb'
  p db1.fetch('a')        #=> 'aaa'
  p db1.fetch('z', 'zzz') #=> 'zzz'
  p db1.fetch('z')        #=> IndexError 発生

--- store(key, value) -> String

key に対して value を格納します。

@param key   キー。
@param value 値。

@see [[m:DBM#[]=]]

  require 'dbm'
  
  db1 = DBM.open('aaa.db', 0666, DBM::NEWDB)
  p db1.store('c', 'ccc') #=> "ccc"


--- select{|key, value| ... } -> [Array]

ブロックを評価して真になった要素のみを配列に格納して返します。

  require 'dbm'
  
  db1 = DBM.open('aaa.db', 0666, DBM::NEWDB)
  db1[:a] = 'aaa'
  db1[:b] = 'bbbbbb'
  
  p db1.select {|key, value| key == 'a' } #=> [["a", "aaa"]]


--- values_at(*keys) -> [String]

keys に対応する値を配列に格納して返します。

@params keys キー。複数指定可能です。

  require 'dbm'
  
  db1 = DBM.open('aaa.db', 0666, DBM::NEWDB)
  db1[:a] = 'aaa'
  db1[:b] = 'bbbbbb'
  
  p db1.values_at('a', 'b') #=> ["aaa", "bbbbbb"]


--- invert -> Hash

キーと値のペアを持つ Hash に変換します。

  require 'dbm'
  
  db1 = DBM.open('aaa.db', 0666, DBM::NEWDB)
  db1[:a] = 'aaa'
  db1[:b] = 'bbbbbb'
  p db1.invert  #=> {"bbbbbb" => "b", "aaa" => "a"}


--- update(other){|key, value| ... } -> DBM

self の内容を other で更新します。

@param other DBM オブジェクト。


  require 'dbm'
  
  db1 = DBM.open('aaa.db', 0666, DBM::NEWDB)
  db1[:a] = 'aaa'
  db1[:b] = 'bbbbbb'
  db2 = DBM.open('bbb.db', 0666, DBM::NEWDB)
  db2[:bb] = 'bbb'
  db2[:cc] = 'ccc'
  
  db1.update(db2)
  p db1.keys #=> ["bb", "cc", "b", "a"]

--- to_a -> [Array]

キーと値のペアを配列に変換して返します。

  require 'dbm'
  
  db1 = DBM.open('aaa.db', 0666, DBM::NEWDB)
  db1[:a] = 'aaa'
  db1[:b] = 'bbbbbb'

  p db1.to_a #=> [["b", "bbbbbb"], ["a", "aaa"]]


--- to_hash -> Hash

self をハッシュに変換して返します。

  require 'dbm'
  
  db1 = DBM.open('aaa.db', 0666, DBM::NEWDB)
  db1[:a] = 'aaa'
  db1[:b] = 'bbbbbb'
  p db1.to_hash #=> {"a"=>"aaa", "b"=>"bbbbbb"}

--- index(value) -> String | nil

value を持つ要素のキーを返します。

見つからなかった場合は nil を返します。

@param value 検索したい値。

== Constants

#@since 1.8.2
--- READER

読み込みモードでオープンします．

@see [[m:DBM#open]]

--- WRITER

書き込みモードでオープンします．

@see [[m:DBM#open]]

--- WRCREAT

書き込みモードで、すでにファイルが存在しなかったら作ります．

@see [[m:DBM#open]]

--- NEWDB

書き込みモードで、すでにファイルが存在したら削除して作り直します．

@see [[m:DBM#open]]

#@end


--- VERSION

DB のバージョンです。

#@since 1.9.0
DB のバージョンが不明な場合は "unknown" になります。
#@end
