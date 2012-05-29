#@since 1.9.2
require syck/ypath
#@else
require yaml/ypath
#@end

YAML のノードを検索するためのサブライブラリです。

#@since 1.9.2
= module Syck::BaseNode
#@else
= module YAML::BaseNode
#@end

YAML のノードを検索するのためのモジュールです。

== instance methods

--- [](*key) -> object | [object] | nil

引数で指定したキーに対応する値(もしくは引数で指定したインデックスに対応
する値の配列)を返します。対応する値がない場合は nil を返します。

@param key [[c:Hash]] のキーか [[c:Array]] のインデックスを文字列で指定
           します。後者の場合は複数個指定する事ができます。

--- at(segment) -> object | nil

指定したキー(もしくはインデックス)に対応する値を返します。対応する値が
ない場合は nil を返します。

@param segment [[c:Hash]] のキーか [[c:Array]] のインデックスを文字列で
               指定します。

--- children -> [object]

自身が持つ値の配列を返します。

--- children_with_index -> [[object, Integer]]

自身が持つ値とインデックス(もしくはキー)の配列の配列を返します。

--- emit -> String

自身を YAML 形式の文字列にして返します。

--- match_path(ypath_str) -> Array

ライブラリの内部で使用します。

--- match_segment(ypath, depth) -> Array

ライブラリの内部で使用します。

--- search(ypath_str) -> [String]

引数で指定したパスのノードを検索します。見つかったパスの配列を返します。

@param ypath_str 検索するパスを文字列で指定します。

#@since 1.9.3
  require 'syck'
#@end
  require 'yaml'
  
  node = YAML.parse(DATA)
  p node.search("//name")           # => ["/dog/shiba/0/name", "/cat/0/name"]
  p node.search("//(name|height)")  # => ["/dog/shiba/0/name", "/cat/0/name"]
  
  __END__
  cat:
    - name: taro
      age: 7
  dog:
    shiba:
     - name: jiro
       age: 23

--- select(ypath_str) -> [YAML::Syck::Node]

引数で指定したパスのノードを検索します。見つかったノードの配列を返します。

@param ypath_str 検索するパスを文字列で指定します。

#@since 1.9.3
  require 'syck'
#@end
  require 'yaml'
  
  node = YAML.parse(DATA)
  # "taro" と "jiro" のノードの配列を返す。
  p node.select("//name")
  # => [#<YAML::Syck::Scalar:0xf738b77c>, #<YAML::Syck::Scalar:0xf738b9ac>]

  # [{"name"=>"taro", "age"=>7}] のノードの配列を返す。
  p node.select("/cat")
  # => [#<YAML::Syck::Seq:0xf7391910>]
  
  __END__
  cat:
    - name: taro
      age: 7
  dog:
    shiba:
     - name: jiro
       age: 23

--- select!(ypath_str) -> [object]

引数で指定したパスのノードを検索します。見つかったノードをそれぞれ
#@since 1.9.2
[[m:Syck::Node#transform]] で Ruby のオブジェクトにした配列を返し
#@else
[[m:YAML::Syck::Node#transform]] で Ruby のオブジェクトにした配列を返し
#@end
ます。

@param ypath_str 検索するパスを文字列で指定します。

#@since 1.9.3
  require 'syck'
#@end
  require 'yaml'
  
  node = YAML.parse(DATA)
  p node.select!("//name")
  # => ["taro", "jiro"]

  p node.select!("/cat")
  # => [[{"name"=>"taro", "age"=>7}]]
  
  __END__
  cat:
    - name: taro
      age: 7
  dog:
    shiba:
     - name: jiro
       age: 23

#@since 1.9.2
@see [[m:Syck::Node#transform]]
#@else
@see [[m:YAML::Syck::Node#transform]]
#@end
