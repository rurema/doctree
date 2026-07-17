タグ URI とクラスを関連付けるためのサブライブラリです。

# reopen Syck

## Class Methods

### def tag_class(tag, cls) -> ()

tag で指定したタグ URI に　cls で指定したクラスを関連付けます。

- **param** `tag` -- タグ URI を文字列で指定します。

- **param** `cls` -- 関連付けるクラスオブジェクトを指定します。

- **SEE** [m:Syck.tagged_classes]

### def tagged_classes -> {String => Class}

タグ URI と、それが対応するクラスの一覧を返します。

```text title="例"
require "pp"
require "syck"
require "yaml"
pp YAML.tagged_classes
# => {"tag:ruby.yaml.org,2002:struct"=>Struct,
"tag:yaml.org,2002:set"=>YAML::Set,
"tag:ruby.yaml.org,2002:sym"=>Symbol,
"tag:yaml.org,2002:omap"=>YAML::Omap,
...}
```
