---
type: library
category: FileFormat
---
構造化されたデータを表現するフォーマットであるYAML (YAML Ain't Markup Language) を扱うためのライブラリです。

```ruby title="例1: 構造化された配列"
require 'yaml'

data = ["Taro san", "Jiro san", "Saburo san"]
str_r = YAML.dump(data)

str_l = <<~YAML_EOT
  ---
  - Taro san
  - Jiro san
  - Saburo san
YAML_EOT

p str_r == str_l  # => true
```

```ruby title="例2: 構造化されたハッシュ"
require 'yaml'
require 'date'

str_l = <<~YAML_EOT
  Tanaka Taro: {age: 35, birthday: 1970-01-01}
  Suzuki Suneo: {
    age: 13,
    birthday: 1992-12-21
  }
YAML_EOT

str_r = {}
str_r["Tanaka Taro"] = {
  "age" => 35,
  "birthday" => Date.new(1970, 1, 1)
}
str_r["Suzuki Suneo"] = {
  "age" => 13,
  "birthday" => Date.new(1992, 12, 21)
}

#%since 3.1
p str_r == YAML.load(str_l, permitted_classes: [Date])  # => true
#%else
p str_r == YAML.load(str_l)  # => true
#%end
```

```ruby title="例3: 構造化されたログ"
require 'yaml'
require 'stringio'

strio_r = StringIO.new(<<~YAML_EOT)
  ---
  time: 2008-02-25 17:03:12 +09:00
  target: YAML
  version: 4
  log: |
    例を加えた。
    アブストラクトを修正した。
  ---
  time: 2008-02-24 17:00:35 +09:00
  target: YAML
  version: 3
  log: |
    アブストラクトを書いた。

YAML_EOT

YAML.load_stream(strio_r).sort_by{ |a| a["version"] }.each do |obj|
  puts "version %d\ntime %s\ntarget:%s\n%s\n" % obj.values_at("version", "time", "target", "log")
end

# =>
#  version 3
#  time 2008-02-24 17:00:35 +0900
#  target:YAML
#  アブストラクトを書いた。
#
#  version 4
#  time 2008-02-25 17:03:12 +0900
#  target:YAML
#  例を加えた。
#  アブストラクトを修正した。
#
```

### バックエンドの選択

[lib:yaml] ライブラリでは、以下のライブラリをバックエンドとして使用します。

- [lib:psych] ライブラリ: YAML バージョン 1.1 を扱う事ができます。

### タグの指定

`!ruby/sym foo` などのようにタグを指定することで、読み込み時に記述した値の型を指定できます。

```ruby title="例"
require 'yaml'
p YAML.load(<<~EOS)
  ---
  !ruby/sym foo
EOS
# => :foo
```

[lib:yaml] では、Ruby 向けに以下のローカルタグを扱えます。

- !ruby/array: [c:Array] オブジェクト
- !ruby/class: [c:Class] オブジェクト
- !ruby/hash:  [c:Hash] オブジェクト
- !ruby/module:  [c:Module] オブジェクト
- !ruby/regexp:  [c:Regexp] オブジェクト
- !ruby/range: [c:Range] オブジェクト
- !ruby/string: [c:String] オブジェクト
- !ruby/struct: [c:Struct] オブジェクト
- !ruby/sym(もしくは !ruby/symbol): [c:Symbol] オブジェクト
- !ruby/encoding: [c:Encoding] オブジェクト
- !ruby/exception: 例外オブジェクト
- !ruby/object:<クラス名>: 上記以外のオブジェクト

#%since 3.1
[`YAML.load`](m:Psych.load) が既定で変換するのは、一部のクラスのオブジェクトだけです。それ以外のクラス([c:Regexp] や [c:Range]、自分で定義したクラスなど)のオブジェクトに変換しようとすると、例外 [c:Psych::DisallowedClass] が発生します。変換するには、キーワード引数 `permitted_classes` に変換を許可するクラスを指定してください。`permitted_classes` については [m:Psych.safe_load] を参照してください。
#%end

```ruby title="例"
require 'yaml'

yaml = <<~EOS
  ---
  array: !ruby/array [1, 2, 3]
  hash: !ruby/hash {foo: 1, bar: 2}
  regexp: !ruby/regexp /foo|bar/
  range: !ruby/range 1..10
EOS
#%since 3.1
p YAML.load(yaml, permitted_classes: [Regexp, Range])
#%else
p YAML.load(yaml)
#%end
#%since 3.4
# => {"array" => [1, 2, 3], "hash" => {"foo" => 1, "bar" => 2}, "regexp" => /foo|bar/, "range" => 1..10}
#%else
# => {"array"=>[1, 2, 3], "hash"=>{"foo"=>1, "bar"=>2}, "regexp"=>/foo|bar/, "range"=>1..10}
#%end
```

自分で定義したクラスなどは !ruby/object:<クラス名> を指定します。なお、読み込む場合には既にそのクラスが定義済みでないと読み込めません。

また、キーと値を指定する事でインスタンス変数を代入できます。

```ruby title="例1"
require 'yaml'

class Foo
  def initialize
    @bar = "test"
  end
end

yaml = <<~EOS
  ---
  !ruby/object:Foo
  bar: "test.modified"
EOS
#%since 3.1
p YAML.load(yaml, permitted_classes: [Foo])
#%else
p YAML.load(yaml)
#%end
# => #<Foo:0xf743f754 @bar="test.modified">
```

```ruby title="例2"
require 'yaml'

module Foo
  class Bar
  end
end

yaml = <<~EOS
  ---
  !ruby/object:Foo::Bar {}
EOS
#%since 3.1
p YAML.load(yaml, permitted_classes: [Foo::Bar])
#%else
p YAML.load(yaml)
#%end
# => #<Foo::Bar:0xf73907b8>
```

### 注意

無名クラスを YAML 形式に変換すると [c:TypeError] が発生します。また、
[c:IO] や [c:Thread] オブジェクトなどはインスタンス変数がオブジェクトの状態を保持していないため、変換はできますが、YAML.load した時に完全に復元できない事に注意してください。

標準添付の yaml 関連ライブラリには以下のようなRuby 独自の拡張、制限があります。標準添付ライブラリ以外で yaml を扱うライブラリを使用する場合などに注意してください。

- ":foo" のような文字列はそのまま [c:Symbol] として扱える
- "y" や "n" は真偽値として扱われない

### 参考

YAML Specification

- <https://yaml.org/spec/>
- <https://yaml.org/type/>

Rubyist Magazine: <https://magazine.rubyist.net/>

- プログラマーのための YAML 入門 (初級編): <https://magazine.rubyist.net/articles/0009/0009-YAML.html>
- プログラマーのための YAML 入門 (中級編): <https://magazine.rubyist.net/articles/0010/0010-YAML.html>
- プログラマーのための YAML 入門 (実践編): <https://magazine.rubyist.net/articles/0011/0011-YAML.html>
- プログラマーのための YAML 入門 (検証編): <https://magazine.rubyist.net/articles/0012/0012-YAML.html>
- プログラマーのための YAML 入門 (探索編): <https://magazine.rubyist.net/articles/0013/0013-YAML.html>

その他

- Ruby with YAML: <http://www.namikilab.tuat.ac.jp/~sasada/prog/yaml.html>

# module YAML

YAML (YAML Ain't Markup Language) を扱うモジュールです。

YAML オブジェクトは実際は [c:Psych] オブジェクトです。その他のオブジェクトも同様に実体は別のオブジェクトです。もし確認したいメソッドの記述が見つからない場合は、[lib:psych] ライブラリを確認してください。

```ruby title="例"
require "yaml"

p YAML                # => Psych
p YAML::Stream        # => Psych::Stream
```
