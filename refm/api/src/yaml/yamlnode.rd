#@since 1.9.2
require syck/basenode
#@else
require yaml/basenode
#@end

YAML のノードを表現するためのサブライブラリです。

#@since 1.9.2
= class Syck::YamlNode
include Syck::BaseNode
#@else
= class YAML::YamlNode
include YAML::BaseNode
#@end

YAML のノードを表現するためのクラスです。

== class methods

#@since 1.9.2
--- new(type, val) -> Syck::YamlNode
#@else
--- new(type, val) -> YAML::YamlNode
#@end

自身を初期化します。

@param type タグを文字列で指定します。

@param val 値を文字列で指定します。

== instance methods

--- anchor -> object

使用されていません。

--- anchor=(val)

使用されていません。

--- kind -> "map" | "seq" | "scalar"

ノードの種別を文字列で返します。

--- kind=(val)

ノードの種別を文字列で指定します。

ユーザが直接使用する事はありません。

--- transform -> object

自身が表現するオブジェクトを Ruby のオブジェクトにして返します。

[注意] 動作しません。

--- type_id -> String

自身のタグを文字列で返します。

--- type_id=(val)

自身のタグを文字列で指定します。

ユーザが直接使用する事はありません。

--- value -> String | Array | Hash

値を返します。

--- value=(val)

自身の値に val を設定します。

ユーザが直接使用する事はありません。
