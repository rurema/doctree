---
type: library
category: Network
---
OpenSSL(<https://www.openssl.org/>)
を Ruby から扱うためのライブラリです。

このドキュメントでは SSL/TLS の一般的事項については解説をしません。利用者は、SSL/TLSの各概念、例えば以下の事項について理解している必要があります。
  - 暗号と認証に関する一般的概念
  - セキュリティに対する攻撃法
  - 公開鍵暗号と秘密鍵暗号
  - 署名の役割、署名の方法とその検証
  - 公開鍵基盤(PKI, Public Key Infrastructure)
  - X.509 証明書
  - 暗号と乱数について
#%# 要追加
SSLのようなセキュリティ技術は、その利用者に無条件に安全性を提供することはできません。利用者、とくにSSLでソフトウェアを実装するプログラマは、 SSL/TLS の技術、それが基づいている概念を理解し、ライブラリを適切に利用する必要があります。

この文章の内容は無保証です。この文章は内容を検証して書かれていますが、間違っている可能性もあります。このライブラリをセキュリティ的に重大な用途に用いるのであれば、自分自身でこのドキュメントの内容を検証してください。

OpenSSL は SSL/TLS による通信を提供する高水準なインターフェースとより基本的な機能を提供する低水準なインターフェースがあります。
基本的には高水準なインターフェースのみを利用すべきです。

低水準なインターフェースを利用する場合には、利用したい機能に関する十分な知識と注意深さが必要となります。
#%# どれが高水準インターフェースでどれが低水準かの
#%# リストが必要

### 例

自己署名証明書の作成の例です。自分の秘密鍵で自分の公開鍵に署名しているから自己署名です。

```ruby
require 'openssl'
  
key = OpenSSL::PKey::RSA.new(1024)
digest = OpenSSL::Digest::SHA1.new()
  
issu = sub = OpenSSL::X509::Name.new()
sub.add_entry('C', 'JP')
sub.add_entry('ST', 'Shimane')
sub.add_entry('CN', 'Ruby Taro')
  
cer = OpenSSL::X509::Certificate.new()
cer.not_before = Time.at(0)
cer.not_after = Time.at(0)
cer.public_key = key  # <= 署名する対象となる公開鍵
cer.serial = 1
cer.issuer = issu
cer.subject = sub
  
cer.sign(key, digest) # <= 署名するのに使う秘密鍵とハッシュ関数
print cer.to_text
```

### 参考文献 {#references}

  - [RFC:5246]
  - Eric Rescorla. SSL and TLS : Designing and Building Secure Systems.
    邦訳, Eric Rescorla 著 齋藤孝道・鬼頭利之・古森貞監訳.
    マスタリングTCP/IP SSL/TLS編
  - John Viega, Matt Messier and Pravir Chandra. Network Security with OpenSSL:
    Cryptography for Secure Communications.
    邦訳, John Viega, Matt Messier and Pravir Chandra 著 齋藤孝道監訳.
    OpenSSL -暗号・PKI・SSL/TLSライブラリの詳細-

# module OpenSSL

OpenSSL のすべてのクラス、モジュール、メソッド、定数を保持しているモジュールです。

## Module functions
### module_function def debug -> bool

デバッグモードが on ならば true を返します。

- **SEE** [m:OpenSSL?.debug=]

### module_function def debug=(b)

デバッグモードを on/off します。

- **SEE** [m:OpenSSL?.debug]

### module_function def errors -> [String]

OpenSSL のエラーキューに残っているエラー文字列を返します。

通常、エラーキューはこの拡張ライブラリが空にするため、これは空の配列を返します。もしそうでないならばこのライブラリのバグです。

### module_function def fips_mode=(bool)

FIPS モードを明示的に on/off します。

- **raise** `OpenSSL::OpenSSLError` -- インストールされている OpenSSL が
       FIPS をサポートしていない場合に発生します。

- **SEE** [m:OpenSSL::OPENSSL_FIPS]

### module_function def Digest(name) -> Class

name に対応する [c:OpenSSL::Digest] のサブクラスを返します。

- **param** `name` -- ダイジェストアルゴリズムの名前を表す文字列("MD5" や "SHA256" など)
- **raise** `NameError` -- name に対応するクラスが無い場合に発生します

```ruby title="例"
require "openssl"

p OpenSSL.Digest("MD5") # => OpenSSL::Digest::MD5
```

### module_function def fips_mode -> bool

FIPS モードが現在有効であれば true を返します。

- **SEE** [m:OpenSSL?.fips_mode=]

### module_function def fixed_length_secure_compare(string1, string2) -> bool

長さの等しい文字列同士を、一定時間で比較します。[c:OpenSSL::HMAC] の計算結果同士の比較など、固定長の値を比較する場合に向いています。

比較にかかる時間が入力の値に依存しないようになっているため、比較結果の違いにかかる時間差から内容を推測するタイミング攻撃を防げます。

string1 と string2 が同じ内容であれば true を、長さが等しく内容が異なる場合は false を返します。

- **param** `string1` -- 比較する文字列
- **param** `string2` -- 比較する文字列
- **raise** `ArgumentError` -- string1 と string2 の長さが異なる場合に発生します

### module_function def secure_compare(string1, string2) -> bool

文字列同士を、一定時間で比較します。

内部で SHA-256 によるハッシュ化を行ってから比較するため、[m:OpenSSL?.fixed_length_secure_compare] とは異なり、string1 と string2 の長さが異なっていても使えます。

string1 と string2 が同じ内容であれば true を、そうでなければ false を返します。

このメソッドは SHA-256 によるハッシュ化のためのコストがかかります。string1 と string2 の長さが等しいと分かっている場合は、[m:OpenSSL?.fixed_length_secure_compare] を使うほうが高速です。

- **param** `string1` -- 比較する文字列
- **param** `string2` -- 比較する文字列

## Constants

### const VERSION -> String

Ruby/OpenSSL のバージョンです。

### const OPENSSL_VERSION -> String

ビルド時に使われた OpenSSL 本体のバージョンを表した文字列です。

### const OPENSSL_LIBRARY_VERSION -> String

実行時に使われている OpenSSL 本体のバージョンを表した文字列です。

### const OPENSSL_VERSION_NUMBER -> Integer

システムにインストールされている OpenSSL 本体のバージョンを表した数です。
<https://www.openssl.org/docs/manmaster/man3/OPENSSL_VERSION_NUMBER.html>
も参照してください。

### const OPENSSL_FIPS -> bool

システムにインストールされている OpenSSL が FIPS をサポートしているならば true です。

していなければ false です。

- **SEE** [m:OpenSSL?.fips_mode=]

#%# = module OpenSSL::SSL::SocketForwarder
# class OpenSSL::OpenSSLError < StandardError

すべての OpenSSL 関連の例外クラスのベースとなる例外クラスです。

## Instance Methods

#%since 4.0
### def errors -> [String]

例外が発生した時点で OpenSSL のエラーキューに残っていたエラー文字列の配列を返します。

配列の要素は文字列で、古いものから新しいものの順に並んでいます。書式は OpenSSL 本体やこのライブラリのバージョンによって変わることがあります。

[m:OpenSSL?.debug] を true にしておくと、同じ内容が標準エラー出力にも出力されます。

#%end

