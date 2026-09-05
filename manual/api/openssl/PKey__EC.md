---
library: openssl
---
# class OpenSSL::PKey::EC < OpenSSL::PKey::PKey

EC(Ellicptic Curve,楕円曲線)暗号鍵のクラスです。

このクラスのメソッドについてより詳しく知りたい場合は openssl のドキュメントの対応する関数の項を見てください。

## Class methods
### def OpenSSL::PKey::EC.builtin_curves -> [[String, String]]

組み込みの曲線の名前と、それに対する説明を文字列の配列ペアの配列で返します。

```ruby title="例"
require 'openssl'

p OpenSSL::PKey::EC.builtin_curves
# => [["secp112r1", "SECG/WTLS curve over a 112 bit prime field"],
#     ["secp112r2", "SECG curve over a 112 bit prime field"], 
#     ["secp128r1", "SECG curve over a 128 bit prime field"], 
#     ["secp128r2", "SECG curve over a 128 bit prime field"],
#     ... ]
```

- **SEE** [m:OpenSSL::PKey::EC::Group.new]

### def OpenSSL::PKey::EC.new -> OpenSSL::PKey::EC
### def OpenSSL::PKey::EC.new(obj) -> OpenSSL::PKey::EC

OpenSSL::PKey::EC オブジェクトを生成します。

引数の種類や内容によって異なる挙動をします。

引数なしの場合は、空の EC オブジェクトを生成します。
これにはパラメータ(曲線から定義される群)も鍵対も含まれていません。

引数が OpenSSL::PKey::EC オブジェクトである場合には、そのオブジェクトのコピーを返します。

引数が [c:OpenSSL::PKey::EC::Group] のオブジェクトである場合には、それを群として設定されます。鍵対は含まれません。

引数が DER 形式もしくは PEM 形式の文字列である場合は、その内容を読み込んで EC オブジェクトを出力します。その内容によって鍵対の両方、もしくは公開鍵のみ含まれています。

引数が曲線の名前の文字列である場合には、その曲線で定義される群がパラメータとして設定されます。鍵対は含まれません。

- **param** `obj` -- ECオブジェクトの生成元(EC オブジェクト or EC::Group オブジェクト
           or 文字列)
- **raise** `OpenSSL::PKey::ECError` -- オブジェクトの生成に失敗した場合に発生します

### def OpenSSL::PKey::EC.generate(ec_group) -> OpenSSL::PKey::EC
### def OpenSSL::PKey::EC.generate(string) -> OpenSSL::PKey::EC

新しいランダムな秘密鍵と公開鍵を持つ EC オブジェクトを生成します。

- **param** `ec_group` -- 鍵パラメータとなる群を表す [c:OpenSSL::PKey::EC::Group] オブジェクト
- **param** `string` -- 曲線の名前を表す文字列
- **SEE** [m:OpenSSL::PKey::EC.new]

## Instance methods
### def group -> OpenSSL::PKey::EC::Group

鍵パラメータとなる群を表すオブジェクトを返します。

- **SEE** [m:OpenSSL::PKey::EC#group=]

### def group=(gr)

鍵パラメータとなる群を表すオブジェクトを設定します。

通常このメソッドで値を変更することはありません。
よく考えて必要な場合のみ利用してください。

- **param** `gr` -- 設定する [c:OpenSSL::PKey::EC::Group] オブジェクト
- **raise** `OpenSSL::PKey::ECError` -- Group オブジェクトの設定に失敗した場合に発生します
- **SEE** [m:OpenSSL::PKey::EC#group]

### def private_key -> OpenSSL::BN|nil

秘密鍵となる整数を返します。

鍵が設定されていない場合は nil を返します。

- **SEE** [m:OpenSSL::PKey::EC#private_key=]

### def private_key=(privkey)

秘密鍵となる整数を設定します。

nil を渡すことで EC オブジェクトが公開鍵のみを持つ状態に変更できます。

- **param** `privkey` -- 設定する秘密鍵([c:OpenSSL::BN] オブジェクト)
- **raise** `OpenSSL::PKey::ECError` -- 秘密鍵の設定に失敗した場合に発生します
- **SEE** [m:OpenSSL::PKey::EC#private_key]

### def public_key -> OpenSSL::PKey::EC::Point|nil

公開鍵となる楕円曲線上の点を表すオブジェクトを返します。

鍵が設定されていない場合は nil を返します。

- **raise** `OpenSSL::PKey::ECError` -- 公開鍵の取得時にエラーが生じた場合に発生します
- **SEE** [m:OpenSSL::PKey::EC#public_key=]

### def public_key=(pubkey)

公開鍵となる楕円曲線上の点を表すオブジェクトを設定します。

通常このメソッドで値を変更することはありません。
よく考えて必要な場合のみ利用してください。

- **param** `pubkey` -- 公開鍵となる [c:OpenSSL::PKey::EC::Point] オブジェクト
- **raise** `OpenSSL::PKey::ECError` -- 公開鍵の設定時にエラーが生じた場合に発生します
- **SEE** [m:OpenSSL::PKey::EC#public_key]

### def private_key? -> bool
### def private? -> bool

EC オブジェクトが秘密鍵を保持していれば真を返します。

### def public_key? -> bool
### def public? -> bool

EC オブジェクトが公開鍵を保持していれば真を返します。

[c:OpenSSL::PKey::RSA] や [c:OpenSSL::PKey::DSA] と異なり、EC オブジェクトが公開鍵を含まない場合が存在します。
例えば、[m:OpenSSL::PKey::EC.new] でパラメータとなる群のみを指定して EC オブジェクトを作った場合は、公開鍵も秘密鍵も保持していません。この場合 [m:OpenSSL::PKey::EC#generate_key] で鍵を生成するまで、その状態のままです。

このメソッドを呼ぶ前に [c:OpenSSL::Random] の各モジュール関数によって乱数が適切に初期化されている必要があります。

### def generate_key! -> self
### def generate_key -> self

鍵ペアを乱数で生成します。

OpenSSL 3.0 以降とリンクされている場合は、鍵オブジェクトが変更不可(immutable)になるためこのメソッドは利用できません。代わりに [m:OpenSSL::PKey::EC.generate] を使ってください。

- **raise** `OpenSSL::PKey::ECError` -- 鍵ペアの生成に失敗した場合、または OpenSSL 3.0 以降とリンクされている場合に発生します

### def check_key -> true

パラメータと鍵対をチェックします。

なんらかの意味で鍵対に問題がある場合には例外 ECError を発生します。

- **raise** `OpenSSL::PKey::ECError` -- 鍵に問題がある場合に発生します

### def dh_compute_key(pubkey) -> String

自分の秘密鍵と相手の公開鍵から ECDH によって鍵文字列を計算し、返します。

相手の公開鍵は [c:OpenSSL::PKey::EC::Point] オブジェクトである必要があります。

- **param** `pubkey` -- 相手の公開鍵
- **raise** `OpenSSL::PKey::ECError` -- 鍵交換に失敗した場合に発生します

### def dsa_sign_asn1(data) -> String

秘密鍵を用い、data に ECDSA で署名します。

結果は文字列として返します。

data のダイジェストを取る処理はこのメソッドに含まれていません。
自身で適当なダイジェストを取る必要があります。

- **param** `data` -- 署名対象のデータ(文字列)
- **raise** `OpenSSL::PKey::ECError` -- EC オブジェクトが秘密鍵を保持していない場合、もしくは署名に失敗した場合に発生します
- **SEE** [m:OpenSSL::PKey::EC#dsa_verify_asn1]

### def dsa_verify_asn1(data, sig) -> bool

公開鍵を用い、署名を ECDSA で検証します。

data のダイジェストを取る処理はこのメソッドに含まれていません。
自身で適当なダイジェストを取る必要があります。

検証に成功した場合は true を返します。

- **param** `data` -- 署名対象のデータ(文字列)
- **param** `sig` -- 署名データ(文字列)
- **raise** `OpenSSL::PKey::ECError` -- 署名の検証時にエラーが生じた場合に発生します
- **SEE** [m:OpenSSL::PKey::EC#dsa_sign_asn1]

### def export(cipher = nil, pass = nil) -> String
### def to_pem(cipher = nil, pass = nil) -> String

鍵を PEM 形式の文字列に変換します。

`self` が公開鍵の情報しか持たない場合は X.509 SubjectPublicKeyInfo 形式になります。この場合 cipher と pass は無視されます。

`self` が秘密鍵の情報を持つ場合は SEC 1/RFC 5915 の ECPrivateKey 形式になります。cipher と pass を指定すると、OpenSSL の伝統的な PEM 暗号化形式で暗号化します。この形式は鍵導出に MD5 を使うため、FIPS 準拠のシステムでは利用できません。

このメソッドは互換性のために残されています。X.509 SubjectPublicKeyInfo 形式が必要なら [m:OpenSSL::PKey::PKey#public_to_pem] を、PKCS #8 形式が必要なら [m:OpenSSL::PKey::PKey#private_to_pem] を使ってください。

- **param** `cipher` -- 秘密鍵を暗号化する暗号アルゴリズムの名前、または [c:OpenSSL::Cipher] オブジェクト
- **param** `pass` -- 暗号化に使うパスワード
- **raise** `OpenSSL::PKey::ECError` -- 文字列への変換に失敗した場合に発生します。
       公開鍵が含まれていない場合や、鍵が妥当でない場合などに失敗します。

### def to_der -> String

鍵を DER 形式の文字列に変換します。

- **raise** `OpenSSL::PKey::ECError` -- 文字列への変換に失敗した場合に発生します。
       公開鍵が含まれていない場合や、鍵が妥当でない場合などに失敗します。

### def to_text -> String

鍵を人間が読める形式に変換します。

- **raise** `OpenSSL::PKey::ECError` -- 文字列への変換に失敗した場合に発生します。
       公開鍵が含まれていない場合や、鍵が妥当でない場合などに失敗します。

## Constants
### const NAMED_CURVE -> Integer

その群が名前を持つ曲線から定義されていることを意味するフラグです。

[m:OpenSSL::PKey::EC::Group#asn1_flag=] で利用されます。

# class OpenSSL::PKey::ECError < OpenSSL::PKey::PKeyError

楕円曲線暗号関連のエラーが生じた場合に発生する例外です。

# class OpenSSL::PKey::EC::Group

楕円曲線から定義される群を表すクラスです。

楕円曲線暗号のパラメータとしての役割をはたします。

## Class methods
### def OpenSSL::PKey::EC::Group.new(obj) -> OpenSSL::PKey::EC::Group
### def OpenSSL::PKey::EC::Group.new(sym, p, a, b) -> OpenSSL::PKey::EC::Group

楕円曲線から定義される群を表すオブジェクトを生成します。

引数の種類と個数によって挙動が異なります。

引数が1つの場合は、シンボル、[c:OpenSSL::PKey::EC::Group] オブジェクト、文字列のいずれかを渡すことができます。

引数にシンボルを渡した場合は対応する群を返します。以下の4つを指定できます。
  - :GFp_simple
  - :GFp_mont
  - :GFp_nist
  - :GF2m_simple
この方法で生成された Group オブジェクトは不完全です。

[c:OpenSSL::PKey::EC::Group] オブジェクトを渡した場合はそれを複製したオブジェクトを返します。

文字列を渡した場合は、PEM もしくは DER 形式のデータとみなしてデータを読み込み、オブジェクトを生成します。

曲線名文字列を渡した場合は、その曲線で定義される群を表すオブジェクトを返します。

引数が4つの場合は sym で :GFp_simple もしくは :GF2m_simple を指定し、それと p, a, b という 3 つの整数で定義される楕円曲線から定義される群を返します。

- **param** `obj` -- Groupオブジェクト生成のためのデータ(シンボル、Group, 文字列のいずれか)
- **param** `sym` -- Group を定義するためのシンボル
- **param** `p` -- 整数([c:OpenSSL::BN])
- **param** `a` -- 整数([c:OpenSSL::BN])
- **param** `b` -- 整数([c:OpenSSL::BN])
- **raise** `OpenSSL::PKey::EC::Group::Error` -- オブジェクトの生成に失敗した場合に発生します。
       曲線名が不正である場合などに発生します。

## Instance methods
### def generator -> OpenSSL::PKey::EC::Point

群の生成元を返します。

### def set_generator(generator, order, cofactor) -> self

群のパラメータを設定します。

- **param** `generator` -- 生成元([c:OpenSSL::PKey::EC::Point] オブジェクト)
- **param** `order` -- 生成元の位数([c:OpenSSL::BN] オブジェクト)
- **param** `cofactor` -- 余因子[c:OpenSSL::BN] オブジェクト
- **raise** `OpenSSL::PKey::EC::Group::Error` -- 設定に失敗した場合に発生します

### def order -> OpenSSL::BN

生成元の位数を返します。

- **raise** `OpenSSL::PKey::EC::Group::Error` -- 位数の取得に失敗した場合に発生します

### def cofactor -> OpenSSL::BN

余因子を返します。

- **raise** `OpenSSL::PKey::EC::Group::Error` -- 余因子の取得に失敗した場合に発生します

### def curve_name -> String | nil

曲線の名前を文字列で返します。

名前がない場合は nil を返します。

### def asn1_flag -> Integer

自身に設定された ASN1 フラグを返します。

- **SEE** [m:OpenSSL::PKey::EC::Group#asn1_flag=]

### def asn1_flag=(flags)

自身に ASN1 フラグを設定します。

現在利用可能なフラグは以下の通りです。
  - [m:OpenSSL::PKey::EC::NAMED_CURVE]

- **SEE** [m:OpenSSL::PKey::EC::Group#asn1_flag]

### def point_conversion_form -> Symbol

点のエンコーディング方式を返します。

以下のいずれかを返します。
  - :compressed
  - :uncompressed
  - :hybrid
詳しくは  X9.62 (ECDSA) などを参照してください。

- **raise** `OpenSSL::PKey::EC::Group::Error` -- 得られたエンコーディングが未知の値であった場合に発生します。
- **SEE** [m:OpenSSL::PKey::EC::Group#point_conversion_form=]

### def point_conversion_form=(sym)

点のエンコーディング方式を設定します。

以下のいずれかを設定します。
  - :compressed
  - :uncompressed
  - :hybrid
詳しくは  X9.62 (ECDSA) などを参照してください。

- **param** `sym` -- 設定する方式([c:Symbol])
- **SEE** [m:OpenSSL::PKey::EC::Group#point_conversion_form]

### def seed -> String | nil

seed を返します。

seed が設定されていない場合は nil を返します。

- **SEE** [m:OpenSSL::PKey::EC::Group#seed]

### def seed=(s)

seed を設定します。

- **param** `s` -- seed(文字列)
- **raise** `OpenSSL::PKey::EC::Group::Error` -- seedの設定に失敗した場合に発生します。
- **SEE** [m:OpenSSL::PKey::EC::Group#seed]

### def degree -> Integer

群の定義の元となっている体の要素を表現するのに必要なビット数を返します。

### def to_pem -> String

自身を PEM 形式の文字列に変換します。

- **raise** `OpenSSL::PKey::EC::Group::Error` -- 変換に失敗した場合に発生します。

### def to_der -> String

自身を DER 形式の文字列に変換します。

- **raise** `OpenSSL::PKey::EC::Group::Error` -- 変換に失敗した場合に発生します。

### def to_text -> String

自身を人間に可読な形式の文字列に変換します。

- **raise** `OpenSSL::PKey::EC::Group::Error` -- 変換に失敗した場合に発生します。

### def ==(other) -> bool
### def eql?(other) -> bool

自身が other と等しいときは true を返します。

- **param** `other` -- 比較対象の [c:OpenSSL::PKey::EC::Group] オブジェクト

# class OpenSSL::PKey::EC::Point

楕円曲線暗号の公開鍵となる曲線上の点を表します。

## Class methods
### def OpenSSL::PKey::EC::Point.new(point) -> OpenSSL::PKey::EC::Point
### def OpenSSL::PKey::EC::Point.new(group) -> OpenSSL::PKey::EC::Point
### def OpenSSL::PKey::EC::Point.new(group, bn) -> OpenSSL::PKey::EC::Point

Point オブジェクトを生成します。

引数に OpenSSL::PKey::EC::Point オブジェクトを渡した場合はそれを複製します。

引数に OpenSSL::PKey::EC::Group オブジェクトを渡した場合はそれに関連付けられたオブジェクトを返します。

引数に OpenSSL::PKey::EC::Group オブジェクトと整数を渡した場合は、整数で定義される点を返します。

- **param** `point` -- 複製する [c:OpenSSL::PKey::EC::Point] オブジェクト
- **param** `group` -- 関連付ける群([c:OpenSSL::PKey::EC::Group] オブジェクト)
- **param** `bn` -- 点を表す整数([c:OpenSSL::BN] オブジェクト)
- **raise** `OpenSSL::PKey::EC::Point::Error` -- オブジェクトの生成に失敗した場合に発生します。

## Instance methods
### def group -> OpenSSL::PKey::EC::Group

自身と関連付けられた群を返します。

### def eql?(other) -> bool
### def ==(other) -> bool

自身が other と等しいならば true を返します。

- **raise** `OpenSSL::PKey::EC::Point::Error` -- エラーが生じた場合に発生します

### def infinity? -> bool

自身が無限遠点であるならば true を返します。

- **raise** `OpenSSL::PKey::EC::Point::Error` -- エラーが生じた場合に発生します
- **SEE** [m:OpenSSL::PKey::EC::Point#set_to_infinity!]

### def on_curve? -> bool

点が曲線上にあるならば真を返します。

[c:OpenSSL::PKey::EC::Group] で得られる群と関連付けられた曲線を考えます。

- **raise** `OpenSSL::PKey::EC::Point::Error` -- エラーが生じた場合に発生します

### def make_affine! -> self
#%todo
- **raise** `OpenSSL::PKey::EC::Point::Error` -- エラーが生じた場合に発生します

### def invert! -> self

自身をその逆元に設定します。

- **raise** `OpenSSL::PKey::EC::Point::Error` -- エラーが生じた場合に発生します

### def set_to_infinity! -> self

自身を無限遠点に設定します。

- **raise** `OpenSSL::PKey::EC::Point::Error` -- エラーが生じた場合に発生します
- **SEE** [m:OpenSSL::PKey::EC::Point#infinity?]

### def to_bn -> OpenSSL::BN

点を整数に変換します。

- **raise** `OpenSSL::PKey::EC::Point::Error` -- 変換に失敗した場合に発生します

### def to_octet_string(conversion_form) -> String

楕円曲線上の点をオクテット文字列(バイト列)として返します。

- **param** `conversion_form` -- 点の変換方式を :compressed、:uncompressed、:hybrid のいずれかのシンボルで指定します

### def add(point) -> OpenSSL::PKey::EC::Point

楕円曲線上の点の加算を行います。

`self` と point の和を表す新しい [c:OpenSSL::PKey::EC::Point] オブジェクトを返します。

- **param** `point` -- 加算するもう一方の [c:OpenSSL::PKey::EC::Point] オブジェクト
- **return** -- 演算結果を表す新しい [c:OpenSSL::PKey::EC::Point] オブジェクト
- **raise** `OpenSSL::PKey::EC::Point::Error` -- 演算に失敗した場合に発生します

### def mul(bn1, bn2 = nil) -> OpenSSL::PKey::EC::Point

楕円曲線上の点のスカラー倍算を行います。

`bn1 * self + bn2 * G` を計算した結果を表す新しい [c:OpenSSL::PKey::EC::Point] オブジェクトを返します。ここで G は `self` が属する群の生成元です。bn2 を省略した場合は、単に `bn1 * self` を計算します。

Ruby 3.4 までは、複数の点と係数の配列を渡す `point.mul(bns, points [, bn2])` という形式もサポートされていましたが、Ruby 4.0 で廃止されました。

- **param** `bn1` -- 掛ける整数を表す [c:OpenSSL::BN] オブジェクト
- **param** `bn2` -- 生成元 G に掛ける整数を表す [c:OpenSSL::BN] オブジェクトです(省略可)
- **return** -- 演算結果を表す新しい [c:OpenSSL::PKey::EC::Point] オブジェクト
- **raise** `OpenSSL::PKey::EC::Point::Error` -- 演算に失敗した場合に発生します

# class OpenSSL::PKey::EC::Group::Error < OpenSSL::OpenSSLError

[c:OpenSSL::PKey::EC::Group] 関連のエラーを表す例外クラスです。

# class OpenSSL::PKey::EC::Point::Error < OpenSSL::OpenSSLError

[c:OpenSSL::PKey::EC::Point] 関連のエラーを表す例外クラスです。
