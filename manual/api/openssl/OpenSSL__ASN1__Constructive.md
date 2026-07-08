---
library: openssl
include:
  - Enumerable
---
# class OpenSSL::ASN1::Constructive < OpenSSL::ASN1::ASN1Data

ASN.1 の構造型を表すクラスです。

通常はこのクラス自身は用いず、各サブクラスを利用します。
## Instance Methods

### def tagging -> Symbol | nil
タグ付けの方式を返します。

:IMPLICIT、:EXPLICIT、nil のいずれかを返します。

タグ([m:OpenSSL::ASN1::ASN1Data#tag])が :UNIVERSAL ならば
この値は無視されます。

nil は :IMPLICIT と同義です。

- **SEE** [m:OpenSSL::ASN1::Constructive#tagging=]

### def tagging=(tag)
タグ付けの方式を設定します。

- **param** `tagging` -- タグ付けの方式(:IMPLICIT または :EXPLICIT)
- **SEE** [m:OpenSSL::ASN1::Constructive#tagging=]

### def each {|item| ... } -> self
構造型のデータに含まれる各要素に対してブロックを
評価します。

