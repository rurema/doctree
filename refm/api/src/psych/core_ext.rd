
= reopen Object

== Class Methods
 
--- yaml_tag(tag) -> ()
クラスと tag の間を関連付けます。

これによって tag 付けされた YAML ドキュメントを Ruby のオブジェクトに
変換したりその逆をしたりすることができます。

@param tag 対象のクラスに関連付けるタグの文字列

=== Example
  require 'psych'
  
  class Foo
    def initialize(x)
      @x = x
    end
  
    attr_reader :x
  end
  
  # Dumps Ruby object normally  
  p Psych.dump(Foo.new(3)) 
  # =>
  # --- !ruby/object:Foo
  # x: 3
  
  # Registers tag with class Foo
  Foo.yaml_as("tag:example.com,2013:foo")
  # ... and dumps the object of Foo class
  Psych.dump(Foo.new(3), STDOUT)
  # =>
  # --- !<tag:example.com,2013:foo>
  # x: 3 
  
  # Loads the object from the tagged YAML node
  p Psych.load(<<EOS)
  --- !<tag:example.com,2012:foo>
  x: 8
  EOS
  # => #<Foo:0x0000000130f48 @x=8>

   
 
== Instance Method
--- to_yaml(options = {}) -> String
--- psych_to_yaml(options = {}) -> String
オブジェクトを YAML document に変換します。

options でオプションを指定できます。
[[m:Psych.dump]] と同じなので詳しくはそちらを参照してください。

[[lib:syck]] に to_yaml メソッドがあるため、
psych_to_yaml が別名として定義されています。将来的に
syck が廃止された場合  psych_to_yaml は廃止
される予定であるため、特別の事情がない限り to_yaml を用いてください。

@param options 出力オプション
@see [[m:Psych.dump]]

= reopen Module

== Instance Methods

--- yaml_as(tag) -> ()
--- psych_yaml_as(tag) -> ()

クラスと tag の間を関連付けます。

これによって tag 付けされた YAML ドキュメントを Ruby のオブジェクトに
変換したりその逆をしたりすることができます。

この method は deprecated です。 [[m:Object.yaml_tag]] を
かわりに使ってください。

@param tag 対象のクラスに関連付けるタグの文字列

= reopen Kernel

== Instance Methods

--- y(*objects) -> String
--- psych_y(*objects) -> String
objects を YAML document に変換します。

このメソッドは irb 上でのみ定義されます。

[[lib:syck]] に y メソッドがあるため、
psych_y が別名として定義されています。将来的に
syck が廃止された場合  psych_y は廃止
される予定であるため、特別の事情がない限り y を用いてください。

@param objects YAML document に変換する Ruby のオブジェクト

