---
library: openssl
---
# class OpenSSL::ASN1::ASN1Data < Object

ASN.1 データ型を表すクラス。

UNIVERSAL なタグを持つ ASN.1 値はこのクラスの2つのサブクラス、
[c:OpenSSL::ASN1::Primitive] もしくは [c:OpenSSL::ASN1::Constructive]
のインスタンスとして表現されます。

それ以外の値はこのクラスのインスタンスとして表現されます。

## Class Methods
### def OpenSSL::ASN1::ASN1Data.new(value, tag, tag_class) -> OpenSSL::ASN1::ASN1Data

ASN.1 値を表現する [c:OpenSSL::ASN1::ASN1Data] オブジェクトを生成します。

通常 UNIVERSAL なタグクラスを持つ ASN.1 値はこのクラスのサブクラスで表現されるため、tag_class はそれ以外(:CONTEXT_SPECIFIC、:APPLICATION、
:PRIVATE のいずれか)を指定します。

value としては、通常は文字列(IMPLICIT tagging 相当)
もしくは OpenSSL::ASN1::ASN1Data の配列(IMPLICIT tagging相当)
を指定します。

- **param** `value` -- そのオブジェクトが表現する値
- **param** `tag` -- タグ
- **param** `tag_class` -- タグクラス

## Instance Methods

### def value -> object

ASN.1 値に対応するRubyのオブジェクトを返します。

- **SEE** [m:OpenSSL::ASN1::ASN1Data#value=]

### def value=(value)

ASN.1 値に対応するRubyのオブジェクトを変更します。

- **param** `value` -- 設定するオブジェクト
- **SEE** [m:OpenSSL::ASN1::ASN1Data#value]

### def tag -> Integer

タグ番号を返します。

タグ番号です。Universal 型の場合は BOOLEAN = 1 から BMPSTRING = 30
のいずれかの値をとります。

- **SEE** [m:OpenSSL::ASN1::ASN1Data#tag=]

### def tag=(tag)

タグ番号を設定します。

- **param** `tag` -- 設定するタグ番号
- **SEE** [m:OpenSSL::ASN1::ASN1Data#tag]

### def tag_class -> Symbol

タグクラスを返します。

:UNIVERSAL、:CONTEXT_SPECIFIC、:APPLICATION, :PRIVATE のいずれかを返します。

- **SEE** [m:OpenSSL::ASN1::ASN1Data#tag_class=]

### def tag_class=(tag_class)

タグクラスを設定します。

- **param** `tag_class` -- 設定するタグクラス。:UNIVERSAL、:ONTEXT_SPECIFIC、:APPLICATION、:PRIVATE のいずれか
- **SEE** [m:OpenSSL::ASN1::ASN1Data#tag_class]

### def to_der -> String

ASN.1 値の DER 表現を返します。

- **SEE** [m:OpenSSL::ASN1?.decode]

### def indefinite_length -> bool
### def indefinite_length=(bool)
### def infinite_length -> bool
### def infinite_length=(bool)

エンコードやデコードで indefinite length 形式(不定長形式)を使うかどうかを取得・設定します。

デコード時は、パースした値が indefinite length 形式でエンコードされていれば true になります。エンコード時に true を設定すると、indefinite length 形式でエンコードされます。

DER ではすべての値が definite length 形式(長さ確定形式)でエンコードされますが、BER では、長さの部分をゼロにすることで、後続の内容が分割されて送られてくることを示す indefinite length 形式が使えます。SET や SEQUENCE だけでなく、OCTET STRING や BIT STRING のような単純型もこの形式にできます。分割されたデータの終わりは EOC (End of Content) タグで示されます。

`infinite_length`・`infinite_length=` は `indefinite_length`・`indefinite_length=` の別名です。以前はこちらの名前が使われていましたが、綴りの誤りのため `indefinite_length` に改名され、`infinite_length` は互換性のために残されています。

- **param** `bool` -- 設定する真偽値

