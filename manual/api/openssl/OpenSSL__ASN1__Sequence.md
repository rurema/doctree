---
library: openssl
---
# class OpenSSL::ASN1::Sequence < OpenSSL::ASN1::Constructive

ASN.1 の Sequence 型(Universal タグのタグ番号16)を表すクラスです。

## Class method
### def new(value) ->  OpenSSL::ASN1::Sequence
### def new(value, tag, tagging, tag_class) -> OpenSSL::ASN1::Sequence

ASN.1 の Sequence 型の値を表現する OpenSSL::ASN1::Sequence オブジェクトを
生成します。

value 以外の引数を省略した場合はタグクラスは :UNIVERSAL、
タグ は [m:OpenSSL::ASN1::SEQUENCE] となります。

- **param** `value` -- ASN.1値を表すRubyのオブジェクト([c:OpenSSL::ASN1::ASN1Data]の配列)
- **param** `tag` -- タグ番号
- **param** `tagging` -- タグ付けの方法(:IMPLICIT もしくは :EXPLICIT)
- **param** `tag_class` -- タグクラス(:UNIVERSAL, :CONTEXT_SPECIFIC, :APPLICATION, :PRIVATE のいずれか)

