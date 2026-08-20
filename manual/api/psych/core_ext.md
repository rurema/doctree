---
library: psych
---
# reopen Object

## Class Methods
 
### def Object.yaml_tag(tag) -> ()

クラスと tag の間を関連付けます。

これによって tag 付けされた YAML ドキュメントを Ruby のオブジェクトに変換したりその逆をしたりできます。

- **param** `tag` -- 対象のクラスに関連付けるタグの文字列

### Example

```ruby
require 'psych'
  
class Foo
  def initialize(x)
    @x = x
  end
  
  attr_reader :x
end
  
# Dumps Ruby object normally  
puts Psych.dump(Foo.new(3))
# =>
# --- !ruby/object:Foo
# x: 3
  
# Registers tag with class Foo
Foo.yaml_tag("tag:example.com,2013:foo")
# ... and dumps the object of Foo class
Psych.dump(Foo.new(3), STDOUT)
# =>
# --- !<tag:example.com,2013:foo>
# x: 3 
  
# Loads the object from the tagged YAML node
#%since 3.1
p Psych.load(<<EOS, permitted_classes: [Foo])
#%else
p Psych.load(<<EOS)
#%end
--- !<tag:example.com,2013:foo>
x: 8
EOS
# => #<Foo:0x0000000130f48 @x=8>
```

## Instance Method
### def to_yaml(options = {}) -> String

オブジェクトを YAML document に変換します。

options でオプションを指定できます。
[m:Psych.dump] と同じなので詳しくはそちらを参照してください。

- **param** `options` -- 出力オプション
- **SEE** [m:Psych.dump]

# reopen Module

## Instance Methods

# reopen Kernel

## Instance Methods

### def y(*objects) -> nil

objects を YAML document として標準出力に出力します。

このメソッドは irb 上でのみ定義されます。

- **param** `objects` -- YAML document に変換する Ruby のオブジェクト
