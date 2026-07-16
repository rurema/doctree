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

p str_r == YAML.load(str_l)  # => true
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

!ruby/sym :foo などのようにタグを指定することで、読み込み時に記述した値
の型を指定できます。

```ruby title="例"
require 'yaml'
p YAML.load(<<~EOS)
  ---
  !ruby/sym :foo
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

```ruby title="例"
require 'yaml'
p YAML.load(<<~EOS)
  ---
  array: !ruby/array [1, 2, 3]
  hash: !ruby/hash {foo: 1, bar: 2}
  regexp: !ruby/regexp /foo|bar/
  range: !ruby/range 1..10
EOS
# => {"regexp"=>/foo|bar/, "hash"=>{"foo"=>1, "bar"=>2}, "array"=>[1, 2, 3], "range"=>1..10}
```

これらは tag:ruby.yaml.org,2002:array のように指定する事もできます。

```ruby title="例"
require 'yaml'
p YAML.load(<<~EOS)
  ---
  array: !tag:ruby.yaml.org,2002:array [1, 2, 3]
  hash: !tag:ruby.yaml.org,2002:hash {foo: 1, bar: 2}
EOS
# => {"hash"=>{"foo"=>1, "bar"=>2}, "array"=>[1, 2, 3]}
```

自分で定義したクラスなどは !ruby/object:<クラス名> を指定します。なお、
読み込む場合には既にそのクラスが定義済みでないと読み込めません。

また、キーと値を指定する事でインスタンス変数を代入できます。

```ruby title="例1"
require 'yaml'

class Foo
  def initialize
    @bar = "test"
  end
end

p YAML.load(<<~EOS)
  ---
  !ruby/object:Foo
  bar: "test.modified"
EOS
# => #<Foo:0xf743f754 @bar="test.modified">
```

```ruby title="例2"
require 'yaml'

module Foo
  class Bar
  end
end

p YAML.load(<<~EOS)
  ---
  !ruby/object:Foo
EOS
# => #<Foo::Bar:0xf73907b8>
```


### 注意

無名クラスを YAML 形式に変換すると [c:TypeError] が発生します。また、
[c:IO] や [c:Thread] オブジェクトなどはインスタンス変数がオブジェク
トの状態を保持していないため、変換はできますが、YAML.load した時に完全
に復元できない事に注意してください。

標準添付の yaml 関連ライブラリには以下のようなRuby 独自の拡張、制限があ
ります。標準添付ライブラリ以外で yaml を扱うライブラリを使用する場合な
どに注意してください。

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

YAML オブジェクトは実際は [c:Psych] オブジェクトです。その他のオブジェ
クトも同様に実体は別のオブジェクトです。もし確認したいメソッドの記述が
見つからない場合は、[lib:psych] ライブラリを確認してください。

```ruby title="例"
require "yaml"

p YAML                # => Psych
p YAML::Stream        # => Psych::Stream
```
