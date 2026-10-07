---
type: library
include:
  - REXML::Validation::Validator
---
XML 文書を RELAX NG のスキーマで検証するためのライブラリです。

[c:REXML::Validation::RelaxNG] のオブジェクト(バリデータ)を、[m:REXML::Parsers::UltraLightParser#add_listener] などでパーサに登録して使います。パーサが文書を読み進めるのに合わせて検証が行われ、文書がスキーマに合わないことが分かった時点で [c:REXML::Validation::ValidationException] が発生します。

```ruby title="例"
require 'rexml/parsers/ultralightparser'
require 'rexml/validation/relaxng'

schema = <<~RELAXNG
  <?xml version="1.0" encoding="UTF-8"?>
  <element name="addressBook" xmlns="http://relaxng.org/ns/structure/1.0">
    <zeroOrMore>
      <element name="card">
        <element name="name"><text/></element>
        <element name="email"><text/></element>
      </element>
    </zeroOrMore>
  </element>
RELAXNG

validator = REXML::Validation::RelaxNG.new(schema)

# スキーマに合う文書は、例外が発生せずにパースが終わる
xml = "<addressBook><card><name>John Smith</name><email>js@example.com</email></card></addressBook>"
parser = REXML::Parsers::UltraLightParser.new(xml)
parser.add_listener(validator)
parser.parse

# 同じバリデータで別の文書を検証する前に reset を呼ぶ
validator.reset

# スキーマに合わない文書では例外が発生する
xml = "<addressBook><card><name>John Smith</name></card></addressBook>"
parser = REXML::Parsers::UltraLightParser.new(xml)
parser.add_listener(validator)
begin
  parser.parse
rescue REXML::Validation::ValidationException => e
  p e.class  # => REXML::Validation::ValidationException
end
```

要素と要素の間にある空白(改行やインデント)もテキストとして検証されます。スキーマがテキストを許していない位置に空白があると、検証に失敗します。

# class REXML::Validation::RelaxNG < Object

#%# REXML::Validation::State などの状態を表すクラスは内部用なのでここでは省略

RELAX NG のスキーマ(XML 構文)に基づくバリデータです。

スキーマのうち、次の要素に対応しています。

`empty`, `element`, `attribute`, `text`, `optional`, `oneOrMore`, `zeroOrMore`, `group`, `value`, `interleave`, `ref`, `grammar`, `start`, `define`

`choice` と `mixed` は、一部の形だけ検証できます。`choice` は、選択肢が `value` や `attribute`、内容が `empty` の `element` のときは動きます。テキストや子要素を持つ `element` を選択肢にすると、スキーマに合う文書でも [c:REXML::Validation::ValidationException] が発生します。`mixed` は、テキストの後に子要素が続く形だけを受け付けます。

次の要素には対応していません。スキーマに書いても無視されます。

`data`, `param`, `include`, `externalRef`, `notAllowed`, `nsName`, `except`, `name`

無視されるため、`notAllowed` を書いても何も禁止されず、`include` と `externalRef` は参照先のファイルを読みません。`element` と `attribute` の名前は `name` 属性で指定してください。子要素の `name` は無視されます。`anyName` を書くと、スキーマの読み込み時に [c:NameError] が発生します。`ref` で参照する名前は、`define` で定義しておいてください。未定義の名前を参照すると [c:NoMethodError] が発生します。

## Class Methods

### def REXML::Validation::RelaxNG.new(source) -> REXML::Validation::RelaxNG
{: since=""}

スキーマ `source` を読み込み、バリデータを作成して返します。

- **param** `source` -- RELAX NG のスキーマ(文字列、[c:IO]、[c:IO]互換オブジェクト([c:StringIO]など))

## Instance Methods

### def receive(event) -> ()
{: since=""}

パーサのイベント `event` を受け取り、[m:REXML::Validation::Validator#validate] で検証します。

バリデータを [m:REXML::Parsers::UltraLightParser#add_listener] などで登録したパーサが、イベントが発生するたびに呼び出します。

- **param** `event` -- パーサのイベント
- **raise** `REXML::Validation::ValidationException` -- 文書がスキーマに合わないときに発生します

### def current -> object
{: since=""}
### def current=(value)
{: since=""}

内部用なのでユーザは使わないでください。

### def count -> Integer
{: since=""}
### def count=(value)
{: since=""}

内部用なのでユーザは使わないでください。

### def references -> Hash
{: since=""}

内部用なのでユーザは使わないでください。

## Constants

### const INFINITY -> Float
{: since=""}

内部用なのでユーザは使わないでください。

### const EMPTY -> object
{: since=""}

内部用なのでユーザは使わないでください。

### const TEXT -> Array
{: since=""}

内部用なのでユーザは使わないでください。
