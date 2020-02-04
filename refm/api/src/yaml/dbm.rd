
require yaml
require dbm

[[c:DBM]] の値に文字列以外も格納できるように拡張するためのサブライブラ
リです。

[[c:DBM]] はキー、値のどちらも文字列である必要がありますが、
[[c:YAML::DBM]] は YAML 形式に変換できるオブジェクトであれば値として格
納する事ができます。ただし、キーは文字列である必要があります。

使い方は [[c:DBM]] と同じです。[[c:DBM]] と [[c:YAML]] も併せて参照して
ください。

= class YAML::DBM < DBM

[[c:DBM]] の値に文字列以外も格納できるように拡張したクラスです。

== Constants

--- VERSION -> "0.1"

[[lib:yaml/dbm]] のバージョンを文字列で返します。

== Instance Methods

--- [](key) -> object | nil

データベースからキーを探して対応する要素の値を返します。

対応する値が見つからなかった場合は nil を返します。[[m:DBM#[] ]] とは異
なり、[[c:IndexError]] は発生しません。

@param key キーを文字列で指定します。

@see [[m:YAML::DBM#fetch]]

--- []=(key, value) -> object
--- store(key, value) -> object

key に対して value を格納します。

val で指定したオブジェクトを返します。

@param key キーを文字列で指定します。

@param value 値を指定します。YAML 形式に変換できるオブジェクトが指定で
             きます。

@raise DBMError 要素の格納に失敗した場合に発生します。

--- delete(key) -> object | nil

key をキーとする要素を削除します。

削除した要素を返します。key に対応する値が見つからなかった場合は nil を
返します。

@param key キーを文字列で指定します。

@raise DBMError 要素の削除に失敗した場合に発生します。

--- delete_if {|key, val| ... } -> YAML::DBM

ブロックを評価した値が真であれば該当する要素を削除します。

自身を返します。このメソッドは self を破壊的に変更します。

@raise DBMError 要素の削除に失敗した場合に発生します。

--- each                        -> YAML::DBM
--- each_pair {|key, val| ... } -> YAML::DBM

自身のキーと値を引数としてブロックを評価します。

自身を返します。

--- each_value {|val| ... } -> YAML::DBM

値を引数としてブロックを評価します。

自身を返します。

--- fetch(key, ifnone = nil) -> object

データベースからキーを探して対応する要素の値を返します。

対応する値が見つからなかった場合は ifnone で指定した値を返します。

@param key キーを文字列で指定します。

@see [[m:YAML::DBM#[] ]]

--- has_value?(value) -> bool

value を値とする組がデータベース中に存在する時、真を返します。

@param value 検索したい値を指定します。YAML 形式に変換できるオブジェク
             トが指定できます。

--- shift -> [String, object]

データベース中のキー、値を一つ取り出し、データベースから削除します。

[キー, 値]を返します。取得される要素の順番は保証されません。

--- index(value) -> String | nil

value を持つ要素のキーを返します。

対応するキーが見つからなかった場合は nil を返します。

@param value 検索したい値を指定します。YAML 形式に変換できるオブジェク
             トが指定できます。

#@since 1.9.1
[注意] 非推奨のメソッドです。代わりに #key を使用してください。
#@end

#@since 2.0.0
@see [[m:YAML::DBM#key]]

--- key(value) -> String | nil

value を持つ要素のキーを返します。

対応するキーが見つからなかった場合は nil を返します。

@param value 検索したい値を指定します。YAML 形式に変換できるオブジェク
             トが指定できます。
#@end

--- invert -> {object => String}

値からキーへのハッシュを返します。

異なるキーに対して等しい値が登録されている場合の結果は不定であることに
注意してください、そのような場合にこのメソッドを利用することは意図され
ていません。

--- reject {|key, val| ... } -> {String => object}

ブロックを評価した値が真であれば該当する要素を削除します。

新しく [[c:Hash]] オブジェクトを作成して返します。

--- replace(other) -> YAML::DBM

self の内容を other の内容で置き換えます。

@param other [[c:Hash]]、[[c:DBM]] オブジェクトを指定します。

@raise DBMError 更新に失敗した場合に発生します。

自身を返します。

--- select(*keys) -> [object]
--- select { ... } -> [[String, object]]

ブロックを評価して真になった要素のみを [キー, 値] から構成される配列に
格納して返します。ブロックが与えられなかった場合は、keys に対応する値を
配列に格納して返します。

@param keys キーを文字列で指定します。複数指定することができます。

ブロックを与えるかどうかで戻り値が異なる事に注意してください。

@see [[m:YAML::DBM#values_at]]

--- update(other) -> self

自身と other の内容をマージ(統合)します。

重複するキーに対応する値は other の内容で上書きされます。

@param other [[c:Hash]]、[[c:DBM]] オブジェクトを指定します。

@raise DBMError 更新に失敗した場合に発生します。

--- to_a -> [[String, object]]

キーと値のペアを配列に変換して返します。

--- to_hash -> Hash

自身のキー、値をハッシュにしたものを返します。

--- values -> object

データベース中に存在する値全てを含む配列を返します。

--- values_at(*keys) -> [object]

keys に対応する値を配列に格納して返します。

対応するキーが見つからなかった要素には nil が格納されます。

@param keys キーを文字列で指定します。複数指定することができます。

