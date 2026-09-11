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

# reopen Set

## Instance Methods

#%since 4.0
### def encode_with(coder) -> Psych::Coder

`self` を YAML にダンプするために [m:Psych.dump] などから呼び出されます。

`self` の要素をキー、true を値とするハッシュを組み立て、coder に "hash" というキーで登録します。

Ruby 3.4 までは [c:Set] は Ruby で書かれた通常のオブジェクトであり、この定義がなくても Psych でダンプできていました。Ruby 4.0 から Set は C で実装されたコアクラスになったため、以前と同じ形式でダンプできるようにこのメソッドが定義されています。

- **param** `coder` -- 情報を書き込む Psych::Coder オブジェクト
- **SEE** [m:Set#each]
#%end

#%since 4.0
### def init_with(coder) -> self

[m:Psych.load] などによって YAML から `self` を復元するために呼び出されます。

[m:Set#encode_with] によって coder に登録された要素を取り出し、[m:Set#replace] で `self` の内容をその要素に置き換えます。

- **param** `coder` -- 要素の情報を保持する Psych::Coder オブジェクト
- **SEE** [m:Set#replace]
#%end
