---
type: library
---
[c:REXML::Parsers::StreamParser]
で使われるコールバックオブジェクトのためのモジュール、
[c:REXML::StreamListener] を定義しています。

# module REXML::StreamListener

[c:REXML::Parsers::StreamParser]
で使われるコールバックオブジェクトのためのモジュールです。

このモジュールを include して、各メソッドを適切にオーバーライドした
クラスのインスタンスを
[m:REXML::Parsers::StreamParser.new] や
[m:REXML::Document.parse_stream] の引数として渡します。

このモジュールで定義されているメソッド自体は何もしません。
コールバックのデフォルト動作(何もしない)を定義しているだけです。

詳しい用例などについては [ref:c:REXML::Parsers::StreamParser#example] を
見てください。

## Instance Methods

### def tag_start(name, attrs) -> ()

開始タグをパースしたとき
に呼び出されるコールバックメソッドです。

- **param** `name` -- タグ名が文字列で渡されます
- **param** `attrs` -- タグの属性が"属性名" => "属性値"という [c:Hash] で渡されます

### 例

```text
<tag attr1="value1" attr2="value2">
```

という開始タグに対し、

```text
name: "tag"
attrs: {"attr1" => "value1", "attr2" => "value2"}
```

という引数が渡されます。

### def tag_end(name) -> ()

終了タグをパースしたときに呼び出されるコールバックメソッドです。

- **param** `name` -- タグ名が文字列で渡されます

### 例

```text
</tag>
```

という終了タグに対し、

```text
name: "tag"
```

という引数が渡されます。

### def text(text) -> ()

XML文書内のテキストをパースしたときに呼び出されるコールバックメソッドです。

- **param** `text` -- テキストが文字列で渡されます

### def instruction(name, instruction) -> ()

XML処理命令(PI)をパースしたときに呼び出されるコールバックメソッドです。

- **param** `name` -- ターゲット名が文字列で渡されます
- **param** `instruction` -- 処理命令の内容が文字列で渡されます

### 例

```text
<?xml-stylesheet type="text/css" href="style.css"?>
```

というPIに対し

```text
name: "xml-stylesheet"
instruction: " type=\"text/css\" href=\"style.css\""
```

という引数が渡されます。

### def comment(comment) -> ()

XML文書内のコメントをパースしたときに呼び出されるコールバックメソッドです。

- **param** `comment` -- コメントの内容が文字列で渡されます

### def doctype(name, pub_sys, long_name, uri) -> ()

文書型宣言(DTD)をパースしたときに呼び出されるコールバックメソッドです。

pub_sys, long_name, uri はDTDが内部サブセットのみを
利用している場合には nil が渡されます。

- **param** `name` -- 宣言されているルート要素名が文字列で渡されます。
- **param** `pub_sys` -- "PUBLIC" もしくは "SYSTEM" が渡されます。nilが渡される場合もあります。
- **param** `long_name` -- "SYSTEM" の場合はシステム識別子が、"PUBLIC"の場合は公開識別子が
       文字列で渡されます
- **param** `uri` -- "SYSTEM" の場合は nil が、"PUBLIC" の場合はシステム識別子が渡されます

### 例

```text
<!DOCTYPE me PUBLIC "foo" "bar">
```

というDTDに対しては

```text
name: "me"
pub_sys: "PUBLIC"
long_name: "foo"
uri: "bar"
```

という引数が渡されます。

```text
<!DOCTYPE root [
   ...
```

というDTDに対しては

```text
name: "root"
pub_sys: nil
long_name: nil
uri: nil
```

という引数が渡されます。

### def doctype_end -> ()

文書型宣言(DTD)の終了区切りをパースしたときに呼び出されるコールバックメソッドです。

### def attlistdecl(element_name, attributes, raw_content) -> ()

DTDの属性リスト宣言をパースしたときに呼び出されるコールバックです。

- **param** `element_name` -- 要素名が文字列で渡されます
- **param** `attributes` -- 属性名とそのデフォルト値の対応が
     { 属性名文字列 => デフォルト値文字列(無ければnil) } という
     ハッシュテーブルで渡されます
- **param** `raw_content` -- 文書内の属性リスト宣言の文字列がそのまま渡されます

### 例

```text
<!ATTLIST a att CDATA #REQUIRED xyz CDATA "foobar">
```

という属性リスト宣言に対しては

```text
element_name: "a"
attributes: {"att"=>nil, "xyz"=>"foobar"}
raw_content: " \n<!ATTLIST a att CDATA #REQUIRED xyz CDATA \"foobar\">"
```

という引数が渡されます。

### def elementdecl(content) -> ()

DTDの要素型宣言をパースしたときに呼び出されるコールバックメソッドです。

- **param** `content` -- 要素型宣言が文字列として渡されます。

### 例

```text
<!ELEMENT root (a+)>
```

という属性型宣言に対しては

```text
content: "<!ELEMENT root (a+)"
```

という引数が渡されます。

### def entitydecl(content) -> ()

DTDの実体宣言をパースしたときに呼び出されるコールバックメソッドです。

- **param** `content` -- 実体宣言が配列で渡されます

実体宣言の書き方によって content に渡されるデータの形式が異なります。

```ruby
require 'rexml/parsers/baseparser'
require 'rexml/parsers/streamparser'
require 'rexml/streamlistener'
xml = <<EOS
<!DOCTYPE root [
<!ENTITY % YN '"Yes"'>
<!ENTITY % YN 'Yes'>
<!ENTITY WhatHeSaid "He said %YN;">
<!ENTITY open-hatch SYSTEM "http://www.textuality.com/boilerplate/OpenHatch.xml">
<!ENTITY open-hatch PUBLIC "-//Textuality//TEXT Standard open-hatch boilerplate//EN" "http://www.textuality.com/boilerplate/OpenHatch.xml">
<!ENTITY hatch-pic SYSTEM "../grafix/OpenHatch.gif" NDATA gif>
]>
<root />
EOS

class Listener
  include REXML::StreamListener
  def entitydecl(content); p content; end
end
REXML::Parsers::StreamParser.new(xml, Listener.new).parse
# >> ["YN", "\"Yes\"", "%"]
# >> ["YN", "Yes", "%"]
# >> ["WhatHeSaid", "He said %YN;"]
# >> ["open-hatch", "SYSTEM", "http://www.textuality.com/boilerplate/OpenHatch.xml"]
# >> ["open-hatch", "PUBLIC", "-//Textuality//TEXT Standard open-hatch boilerplate//EN", "http://www.textuality.com/boilerplate/OpenHatch.xml"]
# >> ["hatch-pic", "SYSTEM", "../grafix/OpenHatch.gif", "gif"]
```

### def notationdecl(content) -> ()

DTDの記法宣言をパースしたときに呼び出されるコールバックメソッドです。

- **param** `content` -- 記法宣言が
       [記法名文字列, 種別("PUBLIC" もしくは "SYSTEM"), 公開識別子文字列,
       URI文字列] という配列で渡されます。

### def entity(content) -> ()

DTD内で、パラメータ実体参照(%entityname;)が現れたときに呼び出される
コールバックメソッドです。

DTDの各宣言(要素型宣言や実体参照宣言)の内側で使われた
場合はこのメソッドはコールバックされません。
各宣言のためのコールバックメソッド
([m:REXML::StreamListener#elementdecl] や [m:REXML::StreamListener#entitydecl]
など)
の引数の一部として渡されます。

2.0.0 以前ではこのメソッドはコールバックされないことに注意してください。

- **param** `content` -- 参照名が文字列で渡されます。

### def cdata(content) -> ()

CDATA セクションをパースしたときに呼び出されるコールバックメソッドです。

- **param** `content` -- CDATAセクションの内容の文字列が渡されます

### 例

```text
<![CDATA[ xyz ]]>
```

というCDATAセクションに対しては

```text
content: " xyz "
```

という引数が渡されます。

### def xmldecl(version, encoding, standalone) -> ()

XML宣言をパースしたときに呼び出されるコールバックメソッドです。

version, encoding, standalone はXML宣言内で
対応する構成要素が省略されている場合には nil が渡されます。

- **param** `version` -- 宣言されているバージョンが文字列で渡されます。
- **param** `encoding` -- 宣言されているエンコーディングが文字列で渡されます。
- **param** `standalone` -- スタンドアロン文書であるかどうかが "yes" "no" で渡されます

### 例

```text
<?xml version="1.0" encoding="utf-8"?>
```

というXML宣言に対しては

```text
version: "1.0"
encoding: "utf-8"
standalone: nil
```

という引数が渡されます。
