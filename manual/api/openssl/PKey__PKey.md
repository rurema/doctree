---
library: openssl
---
# module OpenSSL::PKey

公開鍵暗号関連を集めたモジュールです。

## Module Functions

### module_function def read(string, pass = nil) -> OpenSSL::PKey::PKey
### module_function def read(io, pass = nil) -> OpenSSL::PKey::PKey

DER 形式または PEM 形式でエンコードされた鍵データを読み込み、適切な [c:OpenSSL::PKey::PKey] のサブクラスのインスタンスを返します。

- **param** `string` -- 任意の秘密鍵または公開鍵を含む、DER 形式または PEM 形式でエンコードされた文字列
- **param** `io` -- 任意の秘密鍵または公開鍵を含む、DER 形式または PEM 形式でエンコードされたデータを読み込む [c:IO] オブジェクト
- **param** `pass` -- string または io が暗号化された PEM 形式のリソースである場合に使うパスワード(省略可)
- **raise** `OpenSSL::PKey::PKeyError` -- 鍵の解析に失敗した場合に発生します

```ruby
require "openssl"
rsa = OpenSSL::PKey::RSA.generate(2048)
pkey = OpenSSL::PKey.read(rsa.public_to_der)
p pkey.class # => OpenSSL::PKey::RSA
```

#%since 3.1
### module_function def generate_parameters(algo_name, options = nil) -> OpenSSL::PKey::PKey
### module_function def generate_parameters(algo_name, options = nil) { ... } -> OpenSSL::PKey::PKey

アルゴリズム algo_name の新しい鍵パラメータを生成します。

options はそのアルゴリズムに固有のオプションを指定するハッシュです(省略可)。オプションを指定する順序が意味を持つ場合があります。

ブロックが渡された場合、パラメータ生成の途中経過に関する情報を引数としてブロックが呼び出されます。ブロックに渡される引数の意味はアルゴリズムの実装によって異なります。ブロックは複数回呼び出されることも、まったく呼び出されないこともあります。

指定できるオプションについては、`openssl` コマンドの `genpkey` サブコマンドのドキュメントを参照してください。

- **param** `algo_name` -- アルゴリズムを表す文字列
- **param** `options` -- アルゴリズム固有のオプションを指定するハッシュ(省略可)
- **return** -- 生成したパラメータを保持する [c:OpenSSL::PKey::PKey] オブジェクト

```ruby
require "openssl"
pkey = OpenSSL::PKey.generate_parameters("DSA", "dsa_paramgen_bits" => 2048)
p pkey.p.num_bits # => 2048
```

#%end

#%since 3.1
### module_function def generate_key(algo_name, options = nil) -> OpenSSL::PKey::PKey
### module_function def generate_key(algo_name, options = nil) { ... } -> OpenSSL::PKey::PKey
### module_function def generate_key(pkey, options = nil) -> OpenSSL::PKey::PKey
### module_function def generate_key(pkey, options = nil) { ... } -> OpenSSL::PKey::PKey

新しい鍵(鍵対)を生成します。

第一引数に文字列を指定した場合は、[m:OpenSSL::PKey?.generate_parameters] と同様に、その名前のアルゴリズムに対して新しいランダムな鍵を生成します。

第一引数に [c:OpenSSL::PKey::PKey] オブジェクトを指定した場合は、その鍵が保持するパラメータを使って、同じアルゴリズムの新しいランダムな鍵を生成します。

options とブロックの詳細は [m:OpenSSL::PKey?.generate_parameters] を参照してください。

- **param** `algo_name` -- アルゴリズムを表す文字列
- **param** `pkey` -- パラメータを流用する元になる鍵
- **param** `options` -- アルゴリズム固有のオプションを指定するハッシュ(省略可)
- **return** -- 生成した鍵を保持する [c:OpenSSL::PKey::PKey] オブジェクト
- **SEE** [m:OpenSSL::PKey?.generate_parameters]

```ruby
require "openssl"
pkey_params = OpenSSL::PKey.generate_parameters("DSA", "dsa_paramgen_bits" => 2048)
p pkey_params.priv_key # => nil
pkey = OpenSSL::PKey.generate_key(pkey_params)
p pkey.priv_key.class # => OpenSSL::BN
```

#%end

#%since 3.3
### module_function def new_raw_private_key(algo, string) -> OpenSSL::PKey::PKey

生の秘密鍵のバイト列 string から、アルゴリズム algo の鍵を生成します。

X25519 や Ed25519 のように、raw private/public key 形式を使う公開鍵アルゴリズム向けのメソッドです。

- **param** `algo` -- アルゴリズムを表す文字列
- **param** `string` -- 生の秘密鍵のバイト列
- **raise** `OpenSSL::PKey::PKeyError` -- 鍵の生成に失敗した場合に発生します
- **SEE** [m:OpenSSL::PKey::PKey#raw_private_key], [m:OpenSSL::PKey?.new_raw_public_key]

#%end

#%since 3.3
### module_function def new_raw_public_key(algo, string) -> OpenSSL::PKey::PKey

生の公開鍵のバイト列 string から、アルゴリズム algo の鍵を生成します。

X25519 や Ed25519 のように、raw private/public key 形式を使う公開鍵アルゴリズム向けのメソッドです。

- **param** `algo` -- アルゴリズムを表す文字列
- **param** `string` -- 生の公開鍵のバイト列
- **raise** `OpenSSL::PKey::PKeyError` -- 鍵の生成に失敗した場合に発生します
- **SEE** [m:OpenSSL::PKey::PKey#raw_public_key], [m:OpenSSL::PKey?.new_raw_private_key]

#%end

# class OpenSSL::PKey::PKey < Object

公開鍵暗号のための抽象クラスです。

以下のサブクラスを持ちます。
  - [c:OpenSSL::PKey::RSA]
  - [c:OpenSSL::PKey::DSA]
  - [c:OpenSSL::PKey::DH]
  - [c:OpenSSL::PKey::EC]

```ruby title="例"
require "openssl"
# 署名用の鍵を新規作成
dsa512 = OpenSSL::PKey::DSA.new(512)
data = 'hoge'
# 署名
sign = dsa512.sign("dss1", data)
# 署名の検証
p dsa512.verify(dss1, sign, data)
```

## Instance Methods

### def sign(digest, data) -> String

秘密鍵で data に署名し、署名の文字列を返します。

digest は利用するハッシュ関数の名前を "sha256" や "md5"
といった文字列で指定します。

DSA で署名をする場合はハッシュ関数には "dss1" を指定してください。

- **param** `digest` -- 利用するハッシュ関数の名前
- **param** `data` -- 署名する文字列
- **raise** `OpenSSL::PKey::PKeyError` -- 署名時にエラーが起きた場合に発生します

### def verify(digest, sign, data) -> bool

data を秘密鍵で署名したその署名文字列が sign
であることを公開鍵を使って検証し、検証に成功すれば true
を返します。

digest は利用するハッシュ関数の名前を "sha256" や "md5"
といった文字列で指定します。

DSA で検証をする場合はハッシュ関数には "dss1" を指定してください。

検証に失敗した、つまり署名時と異なるハッシュ関数を使った、
sign が正しい署名でなかった場合などは false を返します。

- **param** `digest` -- 利用するハッシュ関数の名前
- **param** `sign` -- 検証に利用する署名文字列
- **param** `data` -- 検証対象の文字列
- **raise** `OpenSSL::PKey::PKeyError` -- 検証時にエラーが起きた場合に発生します。
       正しい署名でなかった場合など、検証に失敗した場合はこの例外は発生しないことに注意してください

### def oid -> String

`self` に関連付けられた OID のショートネームを返します。

```ruby
require "openssl"
rsa_key = OpenSSL::PKey::RSA.generate(2048)
p rsa_key.oid # => "rsaEncryption"
```

### def private_to_der -> String
### def private_to_der(cipher, password) -> String

秘密鍵を DER 形式の PKCS #8 形式にシリアライズします。

引数なしで呼び出した場合は、暗号化されていない PKCS #8 PrivateKeyInfo 形式を使います。cipher と password を指定して呼び出した場合は、PBES2 暗号化方式を使った PKCS #8 EncryptedPrivateKeyInfo 形式を使います。

- **param** `cipher` -- 秘密鍵を暗号化する暗号アルゴリズムの名前、または [c:OpenSSL::Cipher] オブジェクト
- **param** `password` -- 暗号化に使うパスワード
- **SEE** [m:OpenSSL::PKey::PKey#private_to_pem]

### def private_to_pem -> String
### def private_to_pem(cipher, password) -> String

秘密鍵を PEM 形式の PKCS #8 形式にシリアライズします。

暗号化されていない場合は "-----BEGIN PRIVATE KEY-----" で、暗号化されている場合は "-----BEGIN ENCRYPTED PRIVATE KEY-----" で始まる PEM データになります。

詳細は [m:OpenSSL::PKey::PKey#private_to_der] を参照してください。

- **param** `cipher` -- [m:OpenSSL::PKey::PKey#private_to_der] を参照してください
- **param** `password` -- [m:OpenSSL::PKey::PKey#private_to_der] を参照してください
- **SEE** [m:OpenSSL::PKey::PKey#private_to_der]

### def public_to_der -> String

公開鍵を DER 形式の X.509 SubjectPublicKeyInfo 形式にシリアライズします。

- **raise** `OpenSSL::PKey::PKeyError` -- 公開鍵やパラメータの情報が無い場合などに発生します

### def public_to_pem -> String

公開鍵を PEM 形式の X.509 SubjectPublicKeyInfo 形式にシリアライズします。

PEM データは "-----BEGIN PUBLIC KEY-----" で始まります。

- **raise** `OpenSSL::PKey::PKeyError` -- 公開鍵やパラメータの情報が無い場合などに発生します

#%since 3.3
### def raw_private_key -> String

`self` の生の秘密鍵をバイト列で返します。

X25519 や Ed25519 のように、raw private/public key 形式を使う公開鍵アルゴリズム向けのメソッドです。

- **raise** `OpenSSL::PKey::PKeyError` -- 取得に失敗した場合に発生します
- **SEE** [m:OpenSSL::PKey::PKey#raw_public_key], [m:OpenSSL::PKey?.new_raw_private_key]

#%end

#%since 3.3
### def raw_public_key -> String

`self` の生の公開鍵をバイト列で返します。

X25519 や Ed25519 のように、raw private/public key 形式を使う公開鍵アルゴリズム向けのメソッドです。

- **raise** `OpenSSL::PKey::PKeyError` -- 取得に失敗した場合に発生します
- **SEE** [m:OpenSSL::PKey::PKey#raw_private_key], [m:OpenSSL::PKey?.new_raw_public_key]

#%end

#%since 3.1
### def compare?(other) -> bool

`self` と other が同じ鍵かどうかを比較します。

主に [m:OpenSSL::X509::Certificate#public_key] が返す公開鍵と、対応する秘密鍵を比較する際に使います。

- **param** `other` -- 比較対象の [c:OpenSSL::PKey::PKey] オブジェクト
- **return** -- `self` と other のアルゴリズムの種類、パラメータ、公開鍵が一致すれば true、一致しなければ false
- **raise** `TypeError` -- `self` と other のアルゴリズムの種類が異なる場合に発生します
- **raise** `OpenSSL::PKey::PKeyError` -- 比較の実行に失敗した場合に発生します

```ruby
require "openssl"
rsa_key = OpenSSL::PKey::RSA.generate(2048)
copy = OpenSSL::PKey.read(rsa_key.public_to_der)
p rsa_key.compare?(copy) # => true
```

#%end

#%since 3.1
### def sign_raw(digest, data) -> String
### def sign_raw(digest, data, options) -> String

秘密鍵の部分を使って data に署名します。[m:OpenSSL::PKey::PKey#sign] と異なり、data はこのメソッドの中ではハッシュ化されません。

検証には [m:OpenSSL::PKey::PKey#verify_raw] を使います。

- **param** `digest` -- 利用するメッセージダイジェストアルゴリズムの名前を表す文字列です。鍵の種類によってダイジェストアルゴリズムを必要としない場合は nil を指定します。このメソッドは data をハッシュ化しませんが、署名アルゴリズムによってはこの引数が必要になることがあります
- **param** `data` -- 署名するデータの文字列
- **param** `options` -- OpenSSL に渡すアルゴリズム固有の制御用オプションを指定するハッシュです(省略可)。指定できる内容は OpenSSL のマニュアル `EVP_PKEY_CTX_ctrl_str(3)` を参照してください
- **SEE** [m:OpenSSL::PKey::PKey#verify_raw]

```ruby
require "openssl"
data = "Sign me!"
hash = OpenSSL::Digest.digest("SHA256", data)
pkey = OpenSSL::PKey.generate_key("RSA", "rsa_keygen_bits" => 2048)
signopts = { "rsa_padding_mode" => "pss" }
signature = pkey.sign_raw("SHA256", hash, signopts)
pub_key = pkey.public_key
p pub_key.verify_raw("SHA256", signature, hash, signopts) # => true
```

#%end

#%since 3.1
### def verify_raw(digest, signature, data) -> bool
### def verify_raw(digest, signature, data, options) -> bool

公開鍵の部分を使って、signature が data の署名として正しいかどうかを検証します。[m:OpenSSL::PKey::PKey#verify] と異なり、data はこのメソッドの中ではハッシュ化されません。

署名の生成には [m:OpenSSL::PKey::PKey#sign_raw] を使います。

検証に成功した場合は true を、失敗した場合は false を返します。呼び出し側で返り値を確認する必要があります。

- **param** `digest` -- [m:OpenSSL::PKey::PKey#sign_raw] を参照してください
- **param** `signature` -- 検証する署名の文字列
- **param** `data` -- 検証対象のデータの文字列
- **param** `options` -- [m:OpenSSL::PKey::PKey#sign_raw] を参照してください
- **return** -- 検証に成功すれば true、失敗すれば false
- **SEE** [m:OpenSSL::PKey::PKey#sign_raw]

#%end

#%since 3.1
### def verify_recover(digest, signature) -> String
### def verify_recover(digest, signature, options) -> String

公開鍵の部分を使って、signature から署名対象のデータを復元します。すべての署名アルゴリズムがこの操作に対応しているわけではありません。

- **param** `digest` -- [m:OpenSSL::PKey::PKey#sign_raw] を参照してください
- **param** `signature` -- 検証する署名の文字列
- **param** `options` -- [m:OpenSSL::PKey::PKey#sign_raw] を参照してください
- **return** -- signature から復元されたデータの文字列
- **raise** `OpenSSL::PKey::PKeyError` -- 復元に失敗した場合に発生します

#%end

#%since 3.1
### def derive(peer_pkey) -> String

`self` と peer_pkey から共有の秘密鍵を導出します。

`self` は秘密鍵の部分を、peer_pkey は公開鍵の部分を含んでいる必要があります。

- **param** `peer_pkey` -- 相手の公開鍵を含む [c:OpenSSL::PKey::PKey] オブジェクト
- **return** -- 導出された共有の秘密鍵の文字列
- **raise** `OpenSSL::PKey::PKeyError` -- 導出に失敗した場合に発生します

#%end

#%since 3.1
### def encrypt(data) -> String
### def encrypt(data, options) -> String

`self` の公開鍵の部分を使って data を暗号化します。

復号には [m:OpenSSL::PKey::PKey#decrypt] を使います。

- **param** `data` -- 暗号化する文字列
- **param** `options` -- OpenSSL に渡すアルゴリズム固有の制御用オプションを指定するハッシュです(省略可)。指定できる内容は OpenSSL のマニュアル `EVP_PKEY_CTX_ctrl_str(3)` を参照してください
- **return** -- 暗号化されたデータの文字列
- **raise** `OpenSSL::PKey::PKeyError` -- 暗号化に失敗した場合に発生します
- **SEE** [m:OpenSSL::PKey::PKey#decrypt]

```ruby
require "openssl"
pkey = OpenSSL::PKey.generate_key("RSA", "rsa_keygen_bits" => 2048)
data = "secret data"
encrypted = pkey.encrypt(data, rsa_padding_mode: "oaep")
decrypted = pkey.decrypt(encrypted, rsa_padding_mode: "oaep")
p decrypted # => "secret data"
```

#%end

#%since 3.1
### def decrypt(data) -> String
### def decrypt(data, options) -> String

`self` の秘密鍵の部分を使って data を復号します。

暗号化のパラメータの詳細と使用例は [m:OpenSSL::PKey::PKey#encrypt] を参照してください。

- **param** `data` -- 復号する文字列
- **param** `options` -- [m:OpenSSL::PKey::PKey#encrypt] を参照してください
- **return** -- 復号されたデータの文字列
- **raise** `OpenSSL::PKey::PKeyError` -- 復号に失敗した場合に発生します
- **SEE** [m:OpenSSL::PKey::PKey#encrypt]

#%end

#%since 4.1
### def get_param(key) -> String | OpenSSL::BN

鍵からパラメータを取得します。OpenSSL 3.0 以降で利用できる `EVP_PKEY_get_params()` 関数への低レベルなインターフェースです。

対応するパラメータ名や返り値の型については、対応する `EVP_PKEY-*` のマニュアルページや、利用している OpenSSL プロバイダのドキュメントを確認してください。

- **param** `key` -- 取得したいパラメータの名前を表す文字列
- **return** -- 取得したパラメータの値です。パラメータやアルゴリズムによって型が異なります
- **raise** `OpenSSL::PKey::PKeyError` -- key が認識できないパラメータ名である場合や、取得に失敗した場合に発生します

#%end

#%since 4.1
### def encapsulate -> [String, String]

`self` の公開鍵の部分を使って、鍵カプセル化 (key encapsulation) を行います。

- **return** -- `[暗号化されたデータ, 共有される秘密鍵]` という 2 要素の配列
- **raise** `OpenSSL::PKey::PKeyError` -- カプセル化に失敗した場合に発生します
- **SEE** [m:OpenSSL::PKey::PKey#decapsulate]

#%end

#%since 4.1
### def decapsulate(ciphertext) -> String

`self` の秘密鍵の部分を使って、鍵デカプセル化 (key decapsulation) を行います。[m:OpenSSL::PKey::PKey#encapsulate] が返した暗号化されたデータから、共有される秘密鍵を復元します。

- **param** `ciphertext` -- [m:OpenSSL::PKey::PKey#encapsulate] が返した暗号化されたデータ
- **return** -- 復元された共有の秘密鍵の文字列
- **raise** `OpenSSL::PKey::PKeyError` -- デカプセル化に失敗した場合に発生します
- **SEE** [m:OpenSSL::PKey::PKey#encapsulate]

#%end

# class OpenSSL::PKey::PKeyError < OpenSSL::OpenSSLError

OpenSSL の公開鍵関連のエラーの場合に発生する例外
