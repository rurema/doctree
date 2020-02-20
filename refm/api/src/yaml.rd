category FileFormat

構造化されたデータを表現するフォーマットであるYAML (YAML Ain't Markup Language) を扱うためのライブラリです。

#@samplecode 例1: 構造化された配列
require 'yaml'

data = ["Taro san", "Jiro san", "Saburo san"]
str_r = YAML.dump(data)

str_l = <<EOT
---
- Taro san
- Jiro san
- Saburo san
EOT

p str_r == str_l  # => true
#@end

#@samplecode 例2: 構造化されたハッシュ
require 'yaml'
require 'date'

str_l = <<YAML_EOT
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
#@end

#@samplecode 例3: 構造化されたログ
require 'yaml'
require 'stringio'

strio_r = StringIO.new(<<EOT)
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

EOT

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
#@end

=== バックエンドの選択

[[lib:yaml]] ライブラリでは、以下のライブラリをバックエンドとして使用します。

#@until 2.0.0
 * [[lib:syck]] ライブラリ: YAML バージョン 1.0 を扱う事ができます。
#@end
#@since 1.9.2
 * [[lib:psych]] ライブラリ: YAML バージョン 1.1 を扱う事ができます。

#@until 2.0.0
require "yaml" した場合、特に何もしなければ
#@since 1.9.3
[[lib:psych]] ライブラリを使用します。
#@else
[[lib:syck]] ライブラリを使用します。
#@end

デフォルト以外のバックエンドを使用したい場合、[[lib:yaml]] ライブラリを
require する前に [[lib:psych]] か [[lib:syck]] を require してください。

例1: [[lib:psych]] を使用する場合

  require "psych"
  require "yaml"
  YAML.load(...)

例2: [[lib:syck]] を使用する場合

  require "syck"
  require "yaml"
  YAML.load(...)

また、[[lib:yaml]] を require した後でも、YAML::ENGINE.yamler に
"psych" を代入する事で [[lib:psych]] を使用できます。([[lib:syck]] の場
合も同様です)

  require "yaml"
  require "psych"
  YAML::ENGINE.yamler = "psych"
  YAML.load(...)

#@end
#@end

=== タグの指定

!ruby/sym :foo などのようにタグを指定することで、読み込み時に記述した値
の型を指定できます。

例:

  require 'yaml'
  p YAML.load(<<EOS)
  ---
  !ruby/sym :foo
  EOS
  # => :foo

[[lib:yaml]] では、Ruby 向けに以下のローカルタグを扱えます。

 * !ruby/array: [[c:Array]] オブジェクト
 * !ruby/class: [[c:Class]] オブジェクト
 * !ruby/hash:  [[c:Hash]] オブジェクト
 * !ruby/module:  [[c:Module]] オブジェクト
 * !ruby/regexp:  [[c:Regexp]] オブジェクト
 * !ruby/range: [[c:Range]] オブジェクト
 * !ruby/string: [[c:String]] オブジェクト
 * !ruby/struct: [[c:Struct]] オブジェクト
 * !ruby/sym(もしくは !ruby/symbol): [[c:Symbol]] オブジェクト
 * !ruby/encoding: [[c:Encoding]] オブジェクト
 * !ruby/exception: 例外オブジェクト
 * !ruby/object:<クラス名>: 上記以外のオブジェクト

例:

  require 'yaml'
  p YAML.load(<<EOS)
  ---
  array: !ruby/array [1, 2, 3]
  hash: !ruby/hash {foo: 1, bar: 2}
  regexp: !ruby/regexp /foo|bar/
  range: !ruby/range 1..10
  EOS
  # => {"regexp"=>/foo|bar/, "hash"=>{"foo"=>1, "bar"=>2}, "array"=>[1, 2, 3], "range"=>1..10}

これらは tag:ruby.yaml.org,2002:array のように指定する事もできます。

例:

  require 'yaml'
  p YAML.load(<<EOS)
  ---
  array: !tag:ruby.yaml.org,2002:array [1, 2, 3]
  hash: !tag:ruby.yaml.org,2002:hash {foo: 1, bar: 2}
  EOS
  # => {"hash"=>{"foo"=>1, "bar"=>2}, "array"=>[1, 2, 3]}

自分で定義したクラスなどは !ruby/object:<クラス名> を指定します。なお、
読み込む場合には既にそのクラスが定義済みでないと読み込めません。

また、キーと値を指定する事でインスタンス変数を代入できます。

例1:

  require 'yaml'
  
  class Foo
    def initialize
      @bar = "test"
    end
  end
  
  p YAML.load(<<EOS)
  ---
  !ruby/object:Foo
  bar: "test.modified"
  EOS
  # => #<Foo:0xf743f754 @bar="test.modified">

例2:

  require 'yaml'
  
  module Foo
    class Bar
    end
  end
  
  p YAML.load(<<EOS)
  ---
  !ruby/object:Foo::Bar
  EOS
  # => #<Foo::Bar:0xf73907b8>

#@until 2.0.0
また、YAML 形式に変換する際のタグを変更したい場合、to_yaml_type メソッ
ドをオーバライドしてください。
#@since 1.9.2
([[lib:syck]] のみ)
#@end

例:

#@since 1.9.3
  require "syck"
#@end
  require "yaml"
  class Foo
    def to_yaml_type
      return "!tag:example.com,2002:foo"
    end
  end
  p Foo.new.to_yaml # => "--- !example.com,2002/foo {}\n\n"
#@end

=== 注意

無名クラスを YAML 形式に変換すると [[c:TypeError]] が発生します。また、
[[c:IO]] や [[c:Thread]] オブジェクトなどはインスタンス変数がオブジェク
トの状態を保持していないため、変換はできますが、YAML.load した時に完全
に復元できない事に注意してください。

標準添付の yaml 関連ライブラリには以下のようなRuby 独自の拡張、制限があ
ります。標準添付ライブラリ以外で yaml を扱うライブラリを使用する場合な
どに注意してください。

 * ":foo" のような文字列はそのまま [[c:Symbol]] として扱える
 * "y" や "n" は真偽値として扱われない

=== 参考

YAML Specification

 * [[url:https://yaml.org/spec/]]
 * [[url:https://yaml.org/type/]]

YAML4R

 * [[url:http://yaml4r.sourceforge.net/]]
 * [[url:http://yaml4r.sourceforge.net/cookbook/]]([[url:http://yaml.org/YAML_for_ruby.html]])
 * [[url:http://yaml4r.sourceforge.net/doc/]]

Rubyist Magazine: [[url:https://magazine.rubyist.net/]]

 * プログラマーのための YAML 入門 (初級編): [[url:https://magazine.rubyist.net/articles/0009/0009-YAML.html]]
 * プログラマーのための YAML 入門 (中級編): [[url:https://magazine.rubyist.net/articles/0010/0010-YAML.html]]
 * プログラマーのための YAML 入門 (実践編): [[url:https://magazine.rubyist.net/articles/0011/0011-YAML.html]]
 * プログラマーのための YAML 入門 (検証編): [[url:https://magazine.rubyist.net/articles/0012/0012-YAML.html]]
 * プログラマーのための YAML 入門 (探索編): [[url:https://magazine.rubyist.net/articles/0013/0013-YAML.html]]

その他

 * Ruby with YAML: [[url:http://www.namikilab.tuat.ac.jp/~sasada/prog/yaml.html]]

= module YAML

YAML (YAML Ain't Markup Language) を扱うモジュールです。

YAML オブジェクトは実際は [[c:Psych]] オブジェクトです。その他のオブジェ
クトも同様に実体は別のオブジェクトです。もし確認したいメソッドの記述が
見つからない場合は、[[lib:psych]] ライブラリを確認してください。

  require "yaml"

  p YAML                # => Psych
  p YAML::Stream        # => Psych::Stream
