タグ URI とクラスを関連付けるためのサブライブラリです。

#@since 1.9.2
= reopen Syck
#@else
= reopen YAML
#@end

== Class Methods

--- tag_class(tag, cls) -> ()

tag で指定したタグ URI に　cls で指定したクラスを関連付けます。

@param tag タグ URI を文字列で指定します。

@param cls 関連付けるクラスオブジェクトを指定します。

#@since 1.9.2
@see [[m:Syck.tagged_classes]]
#@else
@see [[m:YAML.tagged_classes]]
#@end

--- tagged_classes -> {String => Class}

タグ URI と、それが対応するクラスの一覧を返します。

例:

 require "pp"
#@since 1.9.3
 require "syck"
#@end
 require "yaml"
 pp YAML.tagged_classes
 # => {"tag:ruby.yaml.org,2002:struct"=>Struct,
 "tag:yaml.org,2002:set"=>YAML::Set,
 "tag:ruby.yaml.org,2002:sym"=>Symbol,
 "tag:yaml.org,2002:omap"=>YAML::Omap,
 ...}
