---
include:
  - Syck::BaseNode
require:
#@since 1.9.2
  - syck/basenode
#@else
  - yaml/basenode
#@end
---
YAML のノードを表現するためのサブライブラリです。

# class Syck::YamlNode

YAML のノードを表現するためのクラスです。

## class methods

#@since 1.9.2
### def new(type, val) -> Syck::YamlNode
#@else
### def new(type, val) -> YAML::YamlNode
#@end

自身を初期化します。

- **param** `type` -- タグを文字列で指定します。

- **param** `val` -- 値を文字列で指定します。

## instance methods

### def anchor -> object

使用されていません。

### def anchor=(val)

使用されていません。

### def kind -> "map" | "seq" | "scalar"

ノードの種別を文字列で返します。

### def kind=(val)

ノードの種別を文字列で指定します。

ユーザが直接使用する事はありません。

### def transform -> object

自身が表現するオブジェクトを Ruby のオブジェクトにして返します。

[注意] 動作しません。

### def type_id -> String

自身のタグを文字列で返します。

### def type_id=(val)

自身のタグを文字列で指定します。

ユーザが直接使用する事はありません。

### def value -> String | Array | Hash

値を返します。

### def value=(val)

自身の値に val を設定します。

ユーザが直接使用する事はありません。
