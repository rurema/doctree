category Database

DBM を Ruby スクリプトから扱えるようにするライブラリです。

扱えるキーや値のサイズはリンクしているライブラリに依存します。

作成されるデータベースはアーキテクチャに依存するため、作成した環境と異
なる環境ではデータベースが読み込めない可能性があります。

@see [[lib:gdbm]], [[lib:sdbm]], [[man:dbm(3)]]

= class DBM < Object

include Enumerable

NDBM ファイルをアクセスするクラス。

キー、データともに文字列でなければならないという制限と、データがファイルに
保存されるという点を除いては [[c:Hash]] クラスと全く同様に扱うことができます。

== Class Methods

--- new(dbname, mode = 0666, flags = nil) -> DBM

dbname で指定したデータベースをモードを mode に設定してオープンします。

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


--- reject{ |key, value| ... } -> Hash

ブロックを評価した値が真であれば該当する要素を削除します。

  self.to_hash.reject{|key, value| ... }

と同じです。

@see [[m:Hash#reject]]

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

#@until 1.9.1
--- indexes(*keys) -> [String]
--- indices(*keys) -> [String]

各引数の値をキーとする要素の値を含む配列を返します。

このメソッドは obsolete です。

@param keys 検索したいキー。複数指定可能。

  require 'dbm'
  
  db1 = DBM.open('aaa.db', 0666, DBM::NEWDB)
  db1[:a] = 'aaa'
  db1[:b] = 'bbbbbb'
  p db1.indexes('a', 'b') #=> ["aaa", "bbbbbb"]

#@end

#@since 1.9.1
--- key(value) -> String

与えられた値に対応するキーを返します。

値に対応するキーが複数ある場合は最初に見つかったキーを返します。

@param value キーを探したい値を指定します。

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

self の内容を other の内容で置き換えます。

@param other each_pair メソッドを持つオブジェクトでなければなりません。

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
  
  hash = {'x' => 'xxx', 'y' => 'yyy' }
  p db1               #=> #<DBM:0xb7c7eb08>
  p db1.replace(hash) #=> #<DBM:0xb7c7eb08>

--- fetch(key, ifnone = nil) -> String

データベースからキーを探して対応する要素の値を返します。

@param key    キー。
@param ifnone キーが見つからなかった場合に返す値。

@raise IndexError ifnone を指定していないとき、キーが見つからなかった場合に発生します。

  require 'dbm'
  
  db1 = DBM.open('aaa.db', 0666, DBM::NEWDB)
  db1[:a] = 'aaa'
  db1[:b] = 'bbbbbb'
  p db1.fetch('a')                     #=> 'aaa'
  p db1.fetch('z', 'zzz')              #=> 'zzz'
  p db1.fetch('z'){|key| [:key, key] } #=> [:key, 'z']
  p db1.fetch('z')                     #=> IndexError 発生

@see [[m:Hash#fetch]]

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

@param keys キー。複数指定可能です。

  require 'dbm'
  
  db1 = DBM.open('aaa.db', 0666, DBM::NEWDB)
  db1[:a] = 'aaa'
  db1[:b] = 'bbbbbb'
  
  p db1.values_at('a', 'b') #=> ["aaa", "bbbbbb"]


--- invert -> Hash

値からキーへのハッシュを返します。

  require 'dbm'
  
  db1 = DBM.open('aaa.db', 0666, DBM::NEWDB)
  db1[:a] = 'aaa'
  db1[:b] = 'bbbbbb'
  p db1.invert  #=> {"bbbbbb" => "b", "aaa" => "a"}


--- update(other){|key, value| ... } -> self

self と other の内容をマージします。

重複するキーに対応する値はother の内容で上書きされます。

@param other each_pair メソッドを持つオブジェクトでなければなりません。


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

#@since 1.9.1
このメソッドは deprecated です。[[m:DBM#key]] を使用してください。
#@else
value を持つ要素のキーを返します。

見つからなかった場合は nil を返します。

@param value 検索したい値。
#@end

== Constants

#@since 1.8.2
--- READER -> Fixnum

読み込みモードでオープンします．

@see [[m:DBM.open]]

--- WRITER -> Fixnum

書き込みモードでオープンします．

@see [[m:DBM.open]]

--- WRCREAT -> Fixnum

書き込みモードで、すでにファイルが存在しなかったら作ります．

@see [[m:DBM.open]]

--- NEWDB -> Fixnum

書き込みモードで、すでにファイルが存在したら削除して作り直します．

@see [[m:DBM.open]]

#@end

--- VERSION -> String

libdbm のバージョンを表す文字列です。

#@if (version < "1.8.7")
DB_VERSION_STRING という定数が C 言語レベルで定義されていない場合は
トップレベルの VERSION が参照されるため警告が表示されます。
#@end
#@since 1.9.1
DB_VERSION_STRING という定数が C 言語レベルで定義されていない場合は
"unknown" になります。
#@end


= class DBMError < StandardError

DBM 内部で使用する例外クラスです。


