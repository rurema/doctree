---
library: rexml/document
---
# class REXML::NotationDecl < REXML::Child

DTD の記法宣言を表すクラスです。

```ruby
require 'rexml/document'

doctype = REXML::Document.new(<<EOS).doctype
<!DOCTYPE foo [
<!NOTATION type-image-svg       PUBLIC "-//W3C//DTD SVG 1.1//EN"
      "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">
<!NOTATION type-image-gif       PUBLIC "image/gif">
<!NOTATION foobar               SYSTEM "http://example.org/foobar.dtd">
]>
EOS

svg = doctype.notation("type-image-svg")
p svg.name  # => "type-image-svg"
p svg.to_s  # => "<!NOTATION type-image-svg PUBLIC \"-//W3C//DTD SVG 1.1//EN\" \"http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd\">"
p svg.public # => "-//W3C//DTD SVG 1.1//EN"
p svg.system # => "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd"

gif = doctype.notation("type-image-gif")
p gif.name # => "type-image-gif"
p gif.to_s # => "<!NOTATION type-image-gif PUBLIC \"image/gif\">"
p gif.public # => "image/gif"
p gif.system # => nil

foobar = doctype.notation("foobar")
p foobar.name # => "foobar"
p foobar.to_s # => "<!NOTATION foobar SYSTEM \"http://example.org/foobar.dtd\">"
p foobar.public # => nil
p foobar.system # => "http://example.org/foobar.dtd"
```

## Class Methods

### def new(name, middle, pub, sys) -> REXML::NotationDecl

NotationDecl オブジェクトを生成します。

- **param** `name` -- 記法名(文字列)
- **param** `middle` -- 種別("PUBLIC" もしくは "SYSTEM")
- **param** `pub` -- 公開識別子(文字列)
- **param** `sys` -- URI(文字列)

## Instance Methods

### def public -> String | nil

公開識別子を返します。

宣言が公開識別子を含まない場合は nil を返します。

### def public=(value)

公開識別子を value に変更します。

- **param** `value` -- 設定する公開識別子(文字列)

### def system -> String | nil

システム識別子(URI)を返します。

宣言がシステム識別子を含まない場合は nil を返します。

### def system=(value)

システム識別子を変更します。

- **param** `value` -- 設定するシステム識別子

### def to_s -> String

self を文字列化したものを返します。

### def write(output, indent = -1)

output へ self を文字列化して出力します。

このメソッドは deprecated です。[c:REXML::Formatter] で
出力してください。

- **param** `output` -- 出力先の IO オブジェクト
- **param** `indent` -- インデントの大きさ。無視されます。

### def name -> String

記法宣言の名前を返します。
