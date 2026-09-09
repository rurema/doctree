---
library: openssl
---
# class OpenSSL::SSL::SSLContext < Object

SSL コンテキストクラス。

SSL コネクション([c:OpenSSL::SSL::SSLSocket] や [c:OpenSSL::SSL::SSLServer])
オブジェクトを生成するためのファクトリクラスです。
コネクションを生成するために必要なパラメータ(プロトコルのバージョン、証明書の情報、認証の要件など)を保持します。

コネクションを1度生成して以降は、コンテキストが保持しているパラメータを変更できません。一部のパラメータが共有されるため、安全性のため
[m:Object#freeze] によってオブジェクトを変更不可能にします。
ただしこの凍結は完全ではなく、この後もセッション管理機能によってオブジェクトのキャッシュ領域にセッションを追加したり削除したりできます。

### Constants

verify_mode= と options= で指定できる定数に関しては [c:OpenSSL::SSL] を参照してください。

## Class Methods

### def OpenSSL::SSL::SSLContext.new(ssl_method) -> OpenSSL::SSL::SSLContext
### def OpenSSL::SSL::SSLContext.new -> OpenSSL::SSL::SSLContext

SSL コンテキストオブジェクトを生成します。

ssl_method で利用するプロトコルの種類を文字列もしくはシンボルで指定します。以下のいずれかが利用可能です。
  - 'TLSv1'         TLSv1サーバクライアント両用
  - 'TLSv1_server'  TLSv1サーバ用
  - 'TLSv1_client'  TLSv1クライアント用
  - 'TLSv1_1'
  - 'TLSv1_1_server'
  - 'TLSv1_1_client'
  - 'TLSv1_2'
  - 'TLSv1_2_server'
  - 'TLSv1_2_client'
  - 'SSLv2'         SSLv2サーバクライアント両用
  - 'SSLv2_server'  SSLv2サーバ用
  - 'SSLv2_client'  SSLv2クライアント用
  - 'SSLv3'         SSLv3サーバクライアント両用
  - 'SSLv3_server'  SSLv3サーバ用
  - 'SSLv3_client'  SSLv3クライアント用
  - 'SSLv23'        SSLv2,3/TLSv1サーバクライアント両用
  - 'SSLv23_server' SSLv2,3/TLSv1サーバ用
  - 'SSLv23_client' SSLv2,3/TLSv1クライアント用
SSLv2 はプロトコル上の脆弱性が明らかにされているため使うべきではありません。

SSLv2 は無効化して SSLv3 と TLSv1 の両方を有効化するためには
'SSLv23' を指定し、[m:OpenSSL::SSL::SSLContext#options=] で
[m:OpenSSL::SSL::OP_NO_SSLv2] を指定します。

- **param** `ssl_method` -- プロトコルを表す文字列もしくはシンボル
- **SEE** [m:OpenSSL::SSL::SSLContext#ssl_version=]

## Instance Methods

### def ciphers -> [[String, String, Integer, Integer]]

利用可能な共通鍵暗号の種類を配列で返します。

配列の各要素は以下のような配列です

```text
[暗号方式の名前の文字列, 利用可能なSSL/TLSのバージョン文字列, 鍵長(ビット数), アルゴリズムのビット長]
```

```ruby title="例"
require 'openssl'
ctx = OpenSSL::SSL::SSLContext.new('TLSv1')
p ctx.ciphers
# => [["DHE-RSA-AES256-SHA", "TLSv1/SSLv3", 256, 256], 
#     ["DHE-DSS-AES256-SHA", "TLSv1/SSLv3", 256, 256], ... ]
```

### def ciphers=(ciphers)

利用可能な共通鍵暗号を設定します。

これによって、SSL コネクションにおいて特定の共通鍵暗号だけを利用可能にできます。

指定の方法は2種類あります。1つは

```text
"ALL:!ADH:!LOW:!EXP:!MD5:@STRENGTH"
```

のような文字列で指定する方法で、もう一つは配列で

```text
["ALL", "!ADH", "!LOW", "!EXP", "!MD5", "@STRENGTH"]
```

という配列で指定する方法です。上の2つの例は同じ内容を意味しています。
詳しくは OpenSSL のマニュアルの
SSL_CTX_set_cipher_list の項を見てください。

- **param** `ciphers` -- 利用可能にする共通鍵暗号の種類
- **raise** `OpenSSL::SSL::SSLError` -- 設定に失敗した場合に発生します

### def ca_file -> String | nil

接続相手の検証のために使う、信頼している CA 証明書ファイルのパスを返します。

設定されていない場合は nil を返します。

- **SEE** [m:OpenSSL::SSL::SSLContext#ca_file=]

### def ca_file=(ca)

接続相手の検証のために使う、信頼している CA 証明書ファイルのパスを設定します。

ファイルは以下のように複数の証明書を含んでいても構いません。

```text
(ここに証明書の説明)

-----BEGIN CERTIFICATE-----
... (CA certificate in base64 encoding) ...
-----END CERTIFICATE-----

(ここに証明書の説明)

-----BEGIN CERTIFICATE-----
... (CA certificate in base64 encoding) ...
-----END CERTIFICATE-----
```

デフォルトは nil です。

- **param** `ca` -- CA証明書ファイルのパス文字列
- **SEE** [m:OpenSSL::SSL::SSLContext#ca_file=]

### def ca_path -> String | nil

信頼している CA 証明書ファイルを含むディレクトリを返します。

設定されていない場合は nil を返します。

- **SEE** [m:OpenSSL::SSL::SSLContext#ca_path=]

### def ca_path=(ca)

接続相手の証明書の検証のために使う、信頼している CA 証明書ファイルを含むディレクトリを設定します。

そのディレクトリに含まれる証明書のファイル名は証明書のハッシュ値文字列でなければなりません。

- **param** `ca` -- CA 証明書ファイルを含むディレクトリ名文字列
- **SEE** [m:OpenSSL::SSL::SSLContext#ca_path]

### def cert -> OpenSSL::X509::Certificate

自分自身を証明するための証明書を返します。

デフォルトは nil (証明書なし)です。

- **SEE** [m:OpenSSL::SSL::SSLContext#cert=]

### def cert=(certificate)

自分自身を証明するための証明書を設定します。

デフォルトは nil (証明書なし)です。

- **param** `certificate` -- 設定する証明書([c:OpenSSL::X509::Certificate] のインスタンス)
- **SEE** [m:OpenSSL::SSL::SSLContext#cert]

### def cert_store -> OpenSSL::X509::Store | nil

接続相手の証明書の検証のために使う、信頼している CA 証明書を含む証明書ストアを返します。

デフォルトは nil です。

- **SEE** [m:OpenSSL::SSL::SSLContext#cert_store=]

### def cert_store=(store)

接続相手の証明書の検証のために使う、信頼している CA 証明書を含む証明書ストアを設定します。

通常は [m:OpenSSL::SSL::SSLContext#ca_path=] や
[m:OpenSSL::SSL::SSLContext#ca_file=] で証明書を設定しますが、
CRL を使いたいなど、より詳細な設定をしたい場合にはこれを使います。

デフォルトは nil (証明書ストアを指定しない)です。

- **param** `store` -- 設定する証明書ストア([c:OpenSSL::X509::Store] のインスタンス)
- **SEE** [m:OpenSSL::SSL::SSLContext#cert_store]

### def client_ca -> [OpenSSL::X509::Certificate] | OpenSSL::X509::Certificate | nil

クライアント証明書を要求する時にクライアントに送る CA のリストを返します。

- **SEE** [m:OpenSSL::SSL::SSLContext#client_ca=]

### def client_ca=(ca)

クライアント証明書を要求する時にクライアントに送る CA 証明書のリストを設定します。

クライアントは提示した CA から利用可能(署名されている)な証明書を送り返します。

このメソッドはサーバ側でのみ意味を持ちます。

[c:OpenSSL::X509::Certificate] の配列を渡します。1つの場合は
[c:OpenSSL::X509::Certificate] オブジェクト自体を渡してもかまいません。

- **param** `ca` -- クライアント証明書を要求するときに提示する証明書の配列
- **SEE** [m:OpenSSL::SSL::SSLContext#client_ca]

### def client_cert_cb -> Proc | nil

[m:OpenSSL::SSL::SSLContext#cert=] でクライアント証明書をセットしていなかった場合にサーバからクライアント証明書の要求が来たときに呼びだされるコールバックオブジェクトを返します。

デフォルトは nil (コールバックなし)です。
- **SEE** [m:OpenSSL::SSL::SSLContext#client_cert_cb=]

### def client_cert_cb=(cb)

[m:OpenSSL::SSL::SSLContext#cert=] でクライアント証明書をセットしていなかった場合にサーバからクライアント証明書の要求が来たときに呼びだされるコールバックオブジェクトを設定します。

コールバックに渡される引数は以下のように

```ruby invalid
proc{|sslsocket| ... }
```

1つで、利用している [c:OpenSSL::SSL::SSLSocket]
オブジェクトが渡されます。そのオブジェクトから必要な証明書を見つけるのに必要な情報を取得します。
コールバックはクライアント証明書([c:OpenSSL::X509::Certificate])
とその秘密鍵([c:OpenSSL::PKey::PKey])のペアの配列を返さなければなりません。

証明書と鍵が見付からない場合は nil を返してください。
また、このコールバック内で例外が発生すると、適当な証明書が見付からなかったと判断されます。このとき例外は OpenSSL のライブラリによって握り潰されてしまいます。

デフォルトは nil で、コールバックなしを意味します。この場合はクライアント証明書は利用されません。

このメソッドはクライアント側でのみ意味を持ちます。

```ruby title="例"
require 'openssl'
ctx = OpenSSL::SSL::SSLContext.new(ssl_method)
ctx.client_cert_cb = proc{|sslsocket|
  # sslsocket からコネクションの情報を取り出し、
  # クライアント証明書(cert)とその秘密鍵(privkey)を探しだす
  [cert, privkey]
}
```

- **param** `cb` -- コールバックオブジェクト([c:Proc]、[c:Method] など)
- **SEE** [m:OpenSSL::SSL::SSLContext#client_cert_cb]

### def extra_chain_cert -> [OpenSSL::X509::Certificate] | nil

自分自身を証明する証明書からルート CA までの証明書のリストです。

- **SEE** [m:OpenSSL::SSL::SSLContext#extra_chain_cert=]

### def extra_chain_cert=(certificates)

自分自身を証明する証明書からルート CA までの証明書のリストを配列で設定します。

[m:OpenSSL::SSL::SSLContext#cert] で設定した証明書から相手が持っていると期待されるルート CA 証明書までのリストを渡します。

これによって接続相手はチェインを辿ることでその相手が信頼していない証明書の信頼性を順に確認し、自分自身を証明する証明書の信頼性を確認します。

#%# これを指定しない場合、ca_file や ca_path で指定した信頼されている
#%# 証明書のストレージから証明書チェーンを構成しようとします。 順序は以下の通りです。
#%#   [所有している証明書, 下位 CA 証明書, ... 中間 CA 証明書]
- **param** `certificates` -- 設定する証明書チェイン([c:OpenSSL::X509::Certificate] の
       配列)
- **SEE** [m:OpenSSL::SSL::SSLContext#extra_chain_cert]

### def key -> OpenSSL::PKey::PKey | nil

[m:OpenSSL::SSL::SSLContext#cert] で得られる自分自身を証明するための証明書の公開鍵に対応する秘密鍵を返します。

- **SEE** [m:OpenSSL::SSL::SSLContext#key=]

### def key=(key)

[m:OpenSSL::SSL::SSLContext#cert=] で設定された自分自身を証明するための証明書の公開鍵に対応する秘密鍵を設定します。

デフォルトは nil です。

- **param** `key` -- 設定する秘密鍵([c:OpenSSL::PKey::PKey] のサブクラスのインスタンス)
- **SEE** [m:OpenSSL::SSL::SSLContext#key]

### def options -> Integer | nil

設定されているオプションフラグを返します。

- **SEE** [m:OpenSSL::SSL::SSLContext#options=]

### def options=(options)

オプションを設定します。

以下の値の OR で指定します。
  - [m:OpenSSL::SSL::OP_ALL]
  - [m:OpenSSL::SSL::OP_CIPHER_SERVER_PREFERENCE]
  - [m:OpenSSL::SSL::OP_EPHEMERAL_RSA]
  - [m:OpenSSL::SSL::OP_NETSCAPE_CA_DN_BUG]
  - [m:OpenSSL::SSL::OP_NETSCAPE_DEMO_CIPHER_CHANGE_BUG]
  - [m:OpenSSL::SSL::OP_NO_SESSION_RESUMPTION_ON_RENEGOTIATION]
  - [m:OpenSSL::SSL::OP_NO_SSLv2]
  - [m:OpenSSL::SSL::OP_NO_SSLv3]
  - [m:OpenSSL::SSL::OP_NO_TLSv1]
  - [m:OpenSSL::SSL::OP_NO_TICKET]
  - [m:OpenSSL::SSL::OP_PKCS1_CHECK_1]
  - [m:OpenSSL::SSL::OP_PKCS1_CHECK_2]
  - [m:OpenSSL::SSL::OP_SINGLE_DH_USE]
  - [m:OpenSSL::SSL::OP_SINGLE_ECDH_USE]
  - [m:OpenSSL::SSL::OP_TLS_ROLLBACK_BUG]

- **param** `options` -- 設定するオプションフラグ(整数値)
- **SEE** [m:OpenSSL::SSL::SSLContext#options]

### def timeout -> Integer | nil
### def ssl_timeout -> Integer | nil

このコンテキストから生成するセッションのタイムアウト秒数を返します。

デフォルト値は nil です。

- **SEE** [m:OpenSSL::SSL::SSLContext#timeout=]

### def timeout=(seconds)
### def ssl_timeout=(seconds)

このコンテキストから生成するセッションのタイムアウト秒数を設定します。

nil を指定すると OpenSSL のデフォルトのタイムアウト秒数(300秒)を用います。

- **param** `seconds` -- タイムアウト秒数(整数)
- **SEE** [m:OpenSSL::SSL::Session#timeout]

### def verify_callback -> Proc | nil

オブジェクトに設定されている検証をフィルタするコールバックを返します。

デフォルトのコールバックが設定されている場合には nil を返します。

- **SEE** [m:OpenSSL::X509::Store#verify_callback],
     [m:OpenSSL::SSL::SSLContext#verify_callback=]

### def verify_callback=(proc)

検証をフィルタするコールバックを設定します。

[m:OpenSSL::X509::Store#verify_callback=] と同じ働きをします。

コールバックには [c:Proc] や [c:Method] を渡します。

渡されたコールバックオブジェクトは証明書チェインの検証時にチェインに含まれる各証明書の署名を検証するたびに呼びだされます。
そのときに渡される引数は2つで、1つめは検証が成功したかの真偽値、
2つめは検証後の状態を保存した
[c:OpenSSL::X509::StoreContext] オブジェクトです。
このコールバックには2つの役割があります。1つ目はコンテキストオブジェクトを調べることで詳細なエラー情報を得ることです。2つ目は検証をカスタマイズすることです。このコールバックが true を返すと、たとえ
OpenSSL が検証失敗と判定しても、検証が成功したものと判断し証明書チェインの検証を続けます。逆に false を返すと、検証が失敗したものとみなされ検証を停止し、検証メソッドは検証失敗を返します。詳細なエラー情報を得たいだけの場合はコールバックは第一引数をそのまま返すようにしてください。

nil を設定するとデフォルトのコールバック(単に第一引数をそのまま返すだけ)
が使われます。

初期状態は nil です。

- **param** `proc` -- 設定する [c:Proc] オブジェクト
- **SEE** [m:OpenSSL::SSL::SSLContext#verify_callback],
     [m:OpenSSL::X509::Store#verify_callback=]

### def verify_depth -> Integer | nil

証明書チェイン上の検証する最大の深さを返します。

デフォルトは nil です。

- **SEE** [m:OpenSSL::SSL::SSLContext#verify_depth=]

### def verify_depth=(depth)

証明書チェイン上の検証する最大の深さを設定します。

デフォルトは nil で、この場合 OpenSSL のデフォルト値(9)が使われます。

- **param** `depth` -- 最大深さを表す整数
- **SEE** [m:OpenSSL::SSL::SSLContext#verify_depth]

### def verify_mode -> Integer | nil

検証モードを返します。

デフォルトは nil です。

- **SEE** [m:OpenSSL::SSL::SSLContext#verify_mode=]

### def verify_mode=(mode)

検証モードを設定します。

以下の定数の OR を取って指定します。
  - [m:OpenSSL::SSL::VERIFY_NONE]
  - [m:OpenSSL::SSL::VERIFY_PEER]
  - [m:OpenSSL::SSL::VERIFY_CLIENT_ONCE]
  - [m:OpenSSL::SSL::VERIFY_FAIL_IF_NO_PEER_CERT]
これらの定数の意味はクライアントモードとサーバモードでは異なる意味を持ちます。

デフォルトは nil で、VERIFY_NONE を意味します。

- **param** `mode` -- 設定するモード(整数値)
- **SEE** [m:OpenSSL::SSL::SSLContext#verify_mode]

### def tmp_dh_callback -> Proc | nil

一時的 DH 鍵を生成するためのコールバックを返します。

- **SEE** [m:OpenSSL::SSL::SSLContext#tmp_dh_callback=]

### def tmp_dh_callback=(cb)

一時的 DH 鍵を生成するためのコールバックを設定します。

コールバックには [c:Proc] や [c:Method] を渡します。

暗号で一時的な DH 鍵を利用する場合にはこのコールバックが呼びだされ、呼びだされたブロックは適切な鍵パラメータを返さなければなりません。これで設定するブロックは

```ruby invalid
proc{|sslsocket, is_export, keylen| ... }
```

という引数を取るようにします。それぞれの引数の意味は
  - sslsocket 通信に使われる [c:OpenSSL::SSL::SSLSocket] オブジェクト
  - is_export 輸出規制のある暗号を利用するかどうかを0か0以外かで指定
  - keylen 鍵長
となります。ブロックの返り値には適切な鍵パラメータを含む
[c:OpenSSL::PKey::DH] オブジェクトを返します。鍵パラメータは
keylen で指定された鍵長に対応したものでなければなりません。

[c:OpenSSL::PKey::DH] は DH パラメータと DH 鍵対を保持していますが、これで返されるオブジェクトはパラメータしか用いられません。

cb に nil を指定するとデフォルトのパラメータが利用されます。

デフォルト値は nil です。

- **param** `cb` -- 設定するコールバック
- **SEE** [m:OpenSSL::SSL::SSLContext#tmp_dh_callback]

### def session_id_context -> String | nil

セッション ID コンテキスト文字列を返します。

設定されていない場合は nil を返します。

- **SEE** [c:OpenSSL::SSL::Session],
     [m:OpenSSL::SSL::SSLContext#session_id_context=]

### def session_id_context=(id_context)

セッション ID コンテキストを文字列で設定します。

セッション ID コンテキストは、セッションをグループ化するための識別子で、セッション ID コンテキストとセッション ID の両方が一致する場合に同一のセッションであると判別されます。
この [c:OpenSSL::SSL::SSLContext] オブジェクトで生成されたコネクション([c:OpenSSL::SSL::SSLSocket])に関連付けられたセッションはセッション ID コンテキストを共有します。

セッション ID コンテキストはセッションのグループを識別するための識別子であり、一方セッション ID は各セッションを識別するための識別子であり、この2つは異なる概念であることに注意してください。

クライアント側では意味を持ちません。

- **param** `id_context` -- セッション ID コンテキスト文字列(最大32バイト)
- **SEE** [c:OpenSSL::SSL::Session],
     [m:OpenSSL::SSL::SSLContext#session_id_context],
     [m:OpenSSL::SSL::SSLContext#session_cache_mode=]

### def set_params(params) -> Hash

パラメータをハッシュで設定します。

渡すハッシュテーブルは { パラメータ名のシンボル => パラメータの値 } という形をしていなければなりません。

以下のパラメータを設定できます。
  - :cert ([m:OpenSSL::SSL::SSLContext#cert=])
  - :key ([m:OpenSSL::SSL::SSLContext#key=])
  - :client_ca ([m:OpenSSL::SSL::SSLContext#client_ca=])
  - :ca_file ([m:OpenSSL::SSL::SSLContext#ca_file=])
  - :ca_path ([m:OpenSSL::SSL::SSLContext#ca_path=])
  - :timeout ([m:OpenSSL::SSL::SSLContext#timeout=])
  - :verify_mode ([m:OpenSSL::SSL::SSLContext#verify_mode=])
  - :verify_depth ([m:OpenSSL::SSL::SSLContext#verify_depth=])
  - :verify_callback ([m:OpenSSL::SSL::SSLContext#verify_callback=])
  - :options ([m:OpenSSL::SSL::SSLContext#options=])
  - :cert_store ([m:OpenSSL::SSL::SSLContext#cert_store=])
  - :extra_chain_cert ([m:OpenSSL::SSL::SSLContext#extra_chain_cert=])
  - :client_cert_cb ([m:OpenSSL::SSL::SSLContext#client_cert_cb=])
  - :tmp_dh_callback ([m:OpenSSL::SSL::SSLContext#tmp_dh_callback=])
  - :session_id_context ([m:OpenSSL::SSL::SSLContext#session_id_context=])
  - :session_get_cb ([m:OpenSSL::SSL::SSLContext#session_get_cb=])
  - :session_new_cb ([m:OpenSSL::SSL::SSLContext#session_new_cb=])
  - :session_remove_cb ([m:OpenSSL::SSL::SSLContext#session_remove_cb=])
  - :servername_cb ([m:OpenSSL::SSL::SSLContext#servername_cb=])
指定されなかったパラメータは [m:OpenSSL::SSL::SSLContext::DEFAULT_PARAMS]
の値で初期化されます。

### def ssl_version=(ver)

利用するプロトコルの種類を文字列もしくはシンボルで指定します。

[m:OpenSSL::SSL::SSLContext.new] で指定できるものと同じです。

- **param** `ver` -- 利用するプロトコルの種類

### def servername_cb -> Proc | nil

TLS の Server Name Indication(SNI) 拡張でクライアント側からホスト名が伝えられてきた場合に呼びだされるコールバックを返します。

詳しくは [m:OpenSSL::SSL::SSLContext#servername_cb=] を見てください。

### def servername_cb=(pr)

TLS の Server Name Indication(SNI) 拡張でクライアント側からホスト名が伝えられてきた場合に呼びだされるコールバックを設定します。

このコールバックはハンドシェイク時にクライアント側がサーバのホスト名を伝えてきた場合にサーバ側で呼びだされます。このコールバック内でサーバ側に提示する証明書を調整したりします。

[c:Proc] や [c:Method] をコールバックオブジェクトとして渡します。コールバックに渡される引数は以下のように

```ruby invalid
proc{|sslsocket, hostname| ... }
```

2つで、1つ目は認証および暗号化通信に使われる [c:OpenSSL::SSL::SSLSocket]
オブジェクトで、2つ目がクライアント側から伝えられてきたホスト名です。

コールバックの返り値には認証と暗号化の設定を含んだ
[c:OpenSSL::SSL::SSLContext] オブジェクト、もしくは
nil を返さなければなりません。
これで得られたコンテキストオブジェクトが sslsocket に設定され、コンテキストが持っている証明書などの各情報を用いてハンドシェイクを継続します。
コールバックが nil を返した場合には sslsocket が用いるコンテキストは変更されません。

- **param** `pr` -- コールバックオブジェクト
- **SEE** [m:OpenSSL::SSL::SSLContext#servername_cb]

### def session_add(sess) -> bool

セッションを [c:OpenSSL::SSL::SSLContext] 内部のキャッシュ領域に追加します。

成功時には真を返します。すでにキャッシュ領域にあるセッションを追加しようとした場合は追加されずに偽を返します。

- **param** `sess` -- 追加するセッション([c:OpenSSL::SSL::Session])

### def session_cache_mode -> Integer

セッションキャッシュのモードを返します。

- **SEE** [m:OpenSSL::SSL::SSLContext#session_cache_mode=]

### def session_cache_mode=(mode)

セッションキャッシュのモードを指定します。

以下の定数のORを引数として渡します。
  - [m:OpenSSL::SSL::SSLContext::SESSION_CACHE_OFF]
  - [m:OpenSSL::SSL::SSLContext::SESSION_CACHE_CLIENT]
  - [m:OpenSSL::SSL::SSLContext::SESSION_CACHE_SERVER]
  - [m:OpenSSL::SSL::SSLContext::SESSION_CACHE_BOTH]
  - [m:OpenSSL::SSL::SSLContext::SESSION_CACHE_NO_AUTO_CLEAR]
  - [m:OpenSSL::SSL::SSLContext::SESSION_CACHE_NO_INTERNAL]
  - [m:OpenSSL::SSL::SSLContext::SESSION_CACHE_NO_INTERNAL_LOOKUP]
  - [m:OpenSSL::SSL::SSLContext::SESSION_CACHE_NO_INTERNAL_STORE]

デフォルト値は OpenSSL::SSL::SSLContext::SESSION_CACHE_SERVER です。

- **param** `mode` -- 設定するモード(整数値)
- **SEE** [m:OpenSSL::SSL::SSLContext#session_cache_mode]

### def session_cache_size -> Integer

自身が保持可能なセッションキャッシュのサイズを返します。

- **SEE** [m:OpenSSL::SSL::SSLContext#session_cache_size=]

### def session_cache_size=(size)

自身が保持可能なセッションキャッシュのサイズを指定します。

size に 0 を渡すと制限なしを意味します。

デフォルトは 1024*20 で、20000 セッションまでキャッシュを保持できます。

- **param** `size` -- セッションキャッシュのサイズ(整数値)
- **SEE** [m:OpenSSL::SSL::SSLContext#session_cache_size]

### def session_cache_stats -> {Symbol -> Integer}

セッションキャッシュの内部統計情報をハッシュテーブルで返します。

ハッシュテーブルの各キーとその意味は以下の通りです。
  - :cache_num  内部キャッシュに保持されているセッションの数
  - :connect クライアント側でハンドシェイクした回数
  - :connect_good クライアント側でハンドシェイクが成功した回数
  - :connect_renegotiate クライアント側で再ネゴシエイトした回数
  - :accept サーバ側でハンドシェイクした回数
  - :accept_good サーバ側でハンドシェイクが成功した回数
  - :accept_renegotiate サーバ側で再ネゴシエイトした回数
  - :cache_hits サーバ側で内部キャッシュにヒットした数
  - :cb_hits サーバ側で外部キャッシュにヒットした数
  - :cache_full キャッシュが満杯で破棄したセッションの数
  - :timeouts ヒットしたキャッシュがタイムアウトしてしまっていた回数

### def session_get_cb -> Proc | nil

セッションキャッシュを探索し、内部のキャッシュテーブルには見付からなかった場合に呼び出されるコールバックを返します。

設定されていないときは nil を返します。

- **SEE** [m:OpenSSL::SSL::SSLContext#session_get_cb=]

### def session_get_cb=(cb)

セッションキャッシュを探索し、内部のキャッシュテーブルには見付からなかった場合に呼び出されるコールバックを設定します。

コールバックオブジェクトを call するときの引数は

```text
[ 接続オブジェクト(OpenSSL::SSL::SSLSocket), セッションID(文字列) ]
```

という配列です。このコールバックの返り値が
[c:OpenSSL::SSL::Session] オブジェクトならば、それをキャッシュ値として利用します。それ以外を返したならば、キャッシュは見つからなかったものとして取り扱われます。

セッションキャッシュについて詳しくは [c:OpenSSL::SSL::Session] を見てください。

- **param** `cb` -- コールバックオブジェクト([c:Proc] もしくは [c:Method])
- **SEE** [m:OpenSSL::SSL::SSLContext#session_get_cb]

### def session_new_cb -> Proc | nil

セッションが生成されたときに呼び出されるコールバックを返します。

設定されていないときは nil を返します。

- **SEE** [m:OpenSSL::SSL::SSLContext#session_new_cb=]

### def session_new_cb=(cb)

新たなセッションが作られたときに呼び出されるコールバックを指定します。

コールバックオブジェクトを call するときの引数は

```text
[ 接続オブジェクト(OpenSSL::SSL::SSLSocket), 新たなセッション(OpenSSL::SSL::Session)]
```

という配列です。

セッションキャッシュについて詳しくは [c:OpenSSL::SSL::Session] を見てください。

- **param** `cb` -- コールバックオブジェクト([c:Proc] もしくは [c:Method])
- **SEE** [m:OpenSSL::SSL::SSLContext#session_new_cb]

### def session_remove(sess) -> bool

セッションを [c:OpenSSL::SSL::SSLContext] 内部のキャッシュ領域から取り除きます。

成功時には真を返します。キャッシュ領域に存在しないセッションを削除しようとした場合は偽を返します。

- **param** `sess` -- 削除するセッション([c:OpenSSL::SSL::Session])

### def session_remove_cb -> Proc | nil

セッションが内部キャッシュから破棄されたときに呼び出されるコールバックを返します。

設定されていないときは nil を返します。

- **SEE** [m:OpenSSL::SSL::SSLContext#session_remove_cb=]

### def session_remove_cb=(cb)

セッションが内部キャッシュから破棄されたときに呼び出されるコールバックを設定します。

コールバックオブジェクトを call するときの引数は

```text
[ SSLContextオブジェクト(OpenSSL::SSL::SSLContext), 
  破棄されるセッション(OpenSSL::SSL::Session)]
```

という配列です。

セッションキャッシュについて詳しくは [c:OpenSSL::SSL::Session] を見てください。

- **param** `cb` -- コールバックオブジェクト([c:Proc] もしくは [c:Method])
- **SEE** [m:OpenSSL::SSL::SSLContext#session_remove_cb]

### def flush_sessions(time=nil) -> self

自身が保持しているセッションキャッシュを破棄します。

time に nil を渡すと現在時刻で期限切れになっているキャッシュを破棄します。

time に [c:Time] オブジェクトを渡すと、その時刻で時間切れになるキャッシュを破棄します。

- **param** `time` -- キャッシュ破棄の基準時刻
- **SEE** [m:OpenSSL::SSL::SSLContext#session_cache_mode=]

### def renegotiation_cb -> nil | Proc

ハンドシェイク開始時に呼び出されるコールバックを得ます。

- **SEE** [m:OpenSSL::SSL::SSLContext#renegotiation_cb=]

### def renegotiation_cb=(cb)
#%todo

ハンドシェイク開始時に呼び出されるコールバックを設定します。

コールバックには [c:OpenSSL::SSL::SSLSocket] オブジェクトが渡されます。

このコールバック内で何らかの例外が生じた場合には以降のSSLの処理を停止します。

再ネゴシエーションのたびにこのコールバックが呼び出されるため、何らかの理由で再ネゴシエーションを禁止したい場合などに利用できます。

nil を渡すとコールバックは無効になります。

以下の例は再ネゴシエーションを一切禁止します。

```ruby
num_handshakes = 0
ctx.renegotiation_cb = lambda do |ssl|
  num_handshakes += 1
  raise RuntimeError.new("Client renegotiation disabled") if num_handshakes > 1
end
```

- **param** `cb` -- コールバック(Proc, Method など)もしくは nil
- **SEE** [m:OpenSSL::SSL::SSLContext#renegotiation_cb]

### def add_certificate(certificate, pkey, extra_certs = nil) -> self

証明書とその秘密鍵を `self` に追加します。

`certificate` に対応する秘密鍵を `pkey` で指定します。公開鍵の種類(RSA、ECDSA など)が異なる証明書を複数回に分けて追加でき、ハンドシェイク時に OpenSSL がそのときの状況に最も適した証明書を選択します。

[m:OpenSSL::SSL::SSLContext#cert=]、[m:OpenSSL::SSL::SSLContext#key=]、[m:OpenSSL::SSL::SSLContext#extra_chain_cert=] は証明書を設定するための古い方法で、内部的にはこのメソッドを呼び出します。

- **param** `certificate` -- 追加する証明書([c:OpenSSL::X509::Certificate] のインスタンス)
- **param** `pkey` -- `certificate` に対応する秘密鍵([c:OpenSSL::PKey::PKey] のインスタンス)
- **param** `extra_certs` -- `certificate` に続けて送信する証明書チェイン([c:OpenSSL::X509::Certificate] の配列)
- **raise** `ArgumentError` -- `certificate` が公開鍵を含んでいない場合や、`pkey` が `certificate` の公開鍵と一致しない場合に発生します
- **raise** `OpenSSL::SSL::SSLError` -- 証明書や秘密鍵の設定に失敗した場合に発生します

```ruby invalid
ctx.add_certificate(rsa_cert, rsa_pkey, [ca_intermediate_cert])
```

- **SEE** [m:OpenSSL::SSL::SSLContext#cert=], [m:OpenSSL::SSL::SSLContext#key=], [m:OpenSSL::SSL::SSLContext#extra_chain_cert=]

### def alpn_protocols -> [String] | nil
### def alpn_protocols=(protocols)

Application-Layer Protocol Negotiation(ALPN)で通知するプロトコル名の一覧を取得・設定します。

`alpn_protocols=` で設定した文字列の配列がハンドシェイク時に ALPN 拡張として送信されます。クライアント側で設定するものであり、サーバ側で設定しても効果はありません。設定しなかった場合、ハンドシェイクに ALPN 拡張は含まれません。

サーバ側でクライアントが提示したプロトコルから選択するには [m:OpenSSL::SSL::SSLContext#alpn_select_cb=] を使います。

```ruby title="例"
require 'openssl'
ctx = OpenSSL::SSL::SSLContext.new
ctx.alpn_protocols = ["http/1.1", "spdy/2", "h2"]
```

- **param** `protocols` -- 通知するプロトコル名の文字列の配列
- **SEE** [m:OpenSSL::SSL::SSLContext#alpn_select_cb=], [m:OpenSSL::SSL::SSLSocket#alpn_protocol]

### def alpn_select_cb -> Proc | nil
### def alpn_select_cb=(cb)

ALPN 拡張でクライアントが提示したプロトコルの中から、サーバが利用するプロトコルを選択するためのコールバックを取得・設定します。

コールバックにはクライアントが提示したプロトコル名の文字列の配列が渡され、その中から選んだプロトコル名を文字列で返さなければなりません。提示された中に受け入れられるものがない場合は、コールバック内で例外を発生させるとハンドシェイクが失敗します。

このコールバックを設定しない場合、サーバ側は ALPN 拡張をサポートしません。クライアント側で設定しても効果はありません。

デフォルトは nil です。

```ruby invalid
proc{|protocols| ... }
```

- **param** `cb` -- コールバックオブジェクト([c:Proc] や [c:Method] など)
- **SEE** [m:OpenSSL::SSL::SSLContext#alpn_protocols=]

#%since 3.2
### def ciphersuites=(ciphers)

TLS 1.3 で使う共通鍵暗号の一覧を設定します。

[m:OpenSSL::SSL::SSLContext#ciphers=] は TLS 1.2 以下向けの設定であり、TLS 1.3 の通信には影響しません。TLS 1.3 の暗号を設定するにはこのメソッドを使います。

指定の方法は [m:OpenSSL::SSL::SSLContext#ciphers=] と同様に、コロン区切りの文字列、もしくは名前の配列で指定します。

- **param** `ciphers` -- 利用可能にする TLS 1.3 の共通鍵暗号の種類
- **raise** `OpenSSL::SSL::SSLError` -- 設定に失敗した場合に発生します
- **SEE** [m:OpenSSL::SSL::SSLContext#ciphers=]

#%end

#%since 4.0
### def sigalgs=(sigalgs)

このコンテキストで使う「サポートする署名アルゴリズム」の一覧をコロン区切りの文字列で設定します。

TLS クライアントの場合、この一覧は ClientHello メッセージの "signature_algorithms" 拡張に使われます。TLS サーバの場合、OpenSSL が共有可能な署名アルゴリズムの集合を決定するために使われ、その中から最も適切なものを選択します。

クライアント認証における同等の設定については [m:OpenSSL::SSL::SSLContext#client_sigalgs=] を参照してください。

- **param** `sigalgs` -- コロン区切りの署名アルゴリズム名の文字列(例 `"sigalg1:sigalg2:..."`)
- **raise** `OpenSSL::SSL::SSLError` -- 設定に失敗した場合に発生します
- **SEE** [m:OpenSSL::SSL::SSLContext#client_sigalgs=]

#%end

#%since 4.0
### def client_sigalgs=(sigalgs)

クライアント認証のために使う「サポートする署名アルゴリズム」の一覧をコロン区切りの文字列で設定します。

TLS サーバの場合、この一覧は CertificateRequest メッセージの一部としてクライアントに送信されます。

サーバ認証における同等の設定については [m:OpenSSL::SSL::SSLContext#sigalgs=] を参照してください。

- **param** `sigalgs` -- コロン区切りの署名アルゴリズム名の文字列(例 `"sigalg1:sigalg2:..."`)
- **raise** `OpenSSL::SSL::SSLError` -- 設定に失敗した場合に発生します
- **SEE** [m:OpenSSL::SSL::SSLContext#sigalgs=]

#%end

### def ecdh_curves=(groups_list)
#%since 4.0
### def groups=(groups_list)
#%end

鍵共有(キー交換)に用いるグループの一覧をコロン区切りの文字列で設定します。

TLS クライアントの場合、この一覧はそのまま "supported_groups" 拡張に使われます。TLS サーバの場合、OpenSSL が共有可能なグループの集合を決定するために使われ、その中から最も適切なものを選択します。

#%since 4.0
`ecdh_curves=` は `groups=` の非推奨の別名です。

#%end

```ruby title="例"
require 'openssl'
ctx1 = OpenSSL::SSL::SSLContext.new
ctx1.ecdh_curves = "X25519:P-256:P-224"

ctx2 = OpenSSL::SSL::SSLContext.new
ctx2.ecdh_curves = "P-256"
```

- **param** `groups_list` -- コロン区切りのグループ名の文字列(例 `"X25519:P-256:P-224"`)
- **raise** `OpenSSL::SSL::SSLError` -- 設定に失敗した場合に発生します

### def enable_fallback_scsv -> nil

この `self` に対して TLS_FALLBACK_SCSV を有効にします。

TLS_FALLBACK_SCSV は、クライアントがプロトコルバージョンのダウングレードを再試行していることをサーバに通知し、ダウングレード攻撃を検知できるようにする仕組みです。詳しくは [RFC:7507] を参照してください。

#%since 3.2
### def keylog_cb -> Proc | nil
### def keylog_cb=(cb)

TLS の鍵情報が生成、あるいは受信されたときに呼び出されるコールバックを取得・設定します。

コールバックには [c:OpenSSL::SSL::SSLSocket] オブジェクトと、NSS の SSLKEYLOGFILE デバッグ出力形式のキー情報を含む文字列が渡されます。この情報をファイルに保存しておくことで、Wireshark などのツールで通信内容を復号してデバッグするのに使えます。

OpenSSL 1.1.1 以降でのみ利用できます。

```ruby invalid
proc{|sslsocket, line| ... }
```

- **param** `cb` -- コールバックオブジェクト([c:Proc] や [c:Method] など)

```ruby title="例"
require 'openssl'
context = OpenSSL::SSL::SSLContext.new
context.keylog_cb = proc do |_sock, line|
  File.open('ssl_keylog_file', "a") do |f|
    f.write("#{line}\n")
  end
end
```

#%end

### def min_version=(version)

サポートする SSL/TLS プロトコルバージョンの下限を設定します。

`version` には `OpenSSL::SSL::TLS1_2_VERSION` のような整数の定数、`:TLS1_2` のようなシンボル、もしくは `nil` を指定します。`nil` は「バージョンの制限なし」を意味します。

```ruby title="例"
require 'openssl'
ctx = OpenSSL::SSL::SSLContext.new
ctx.min_version = OpenSSL::SSL::TLS1_1_VERSION
ctx.max_version = OpenSSL::SSL::TLS1_2_VERSION
```

- **param** `version` -- 設定するプロトコルバージョンの下限(整数の定数、シンボル、もしくは nil)
- **raise** `OpenSSL::SSL::SSLError` -- バージョンの設定に失敗した場合に発生します
- **raise** `ArgumentError` -- `version` が認識できない値の場合に発生します
- **SEE** [m:OpenSSL::SSL::SSLContext#max_version=]

### def max_version=(version)

サポートする SSL/TLS プロトコルバージョンの上限を設定します。指定できる値は [m:OpenSSL::SSL::SSLContext#min_version=] と同様です。

- **param** `version` -- 設定するプロトコルバージョンの上限(整数の定数、シンボル、もしくは nil)
- **raise** `OpenSSL::SSL::SSLError` -- バージョンの設定に失敗した場合に発生します
- **raise** `ArgumentError` -- `version` が認識できない値の場合に発生します
- **SEE** [m:OpenSSL::SSL::SSLContext#min_version=]

### def npn_protocols -> [String] | nil
### def npn_protocols=(protocols)

Next Protocol Negotiation(NPN)で通知するプロトコル名の一覧を取得・設定します。

サーバ側でのみ効果があります。設定しなかった場合、ハンドシェイクで NPN 拡張は送信されません。

```ruby title="例"
require 'openssl'
ctx = OpenSSL::SSL::SSLContext.new
ctx.npn_protocols = ["http/1.1", "spdy/2"]
```

- **param** `protocols` -- 通知するプロトコル名の文字列の配列
- **SEE** [m:OpenSSL::SSL::SSLSocket#npn_protocol]

### def npn_select_cb -> Proc | nil
### def npn_select_cb=(cb)

NPN 拡張でサーバが提示したプロトコルの中から、クライアントが利用するプロトコルを選択するためのコールバックを取得・設定します。

クライアント側でのみ効果があります。コールバックにはサーバが提示したプロトコル名の文字列の配列が渡され、その中から選んだプロトコル名を文字列で返さなければなりません。サーバが提示したものの中に受け入れられるものがない場合は、コールバック内で例外を発生させるとハンドシェイクが失敗します。このコールバックを設定しない場合、クライアント側は NPN 拡張をサポートせず、サーバから提示されたプロトコルはすべて無視されます。

```ruby invalid
proc{|protocols| ... }
```

- **param** `cb` -- コールバックオブジェクト([c:Proc] や [c:Method] など)

### def security_level -> Integer
### def security_level=(level)

コンテキストのセキュリティレベルを取得・設定します。

OpenSSL はこのレベルに応じて暗号スイート、楕円曲線・グループ、鍵長、証明書の署名アルゴリズム、プロトコルバージョンなどのパラメータを制限します。例えばレベル 1 では、MAC に MD5 を使う暗号スイートや 1024 ビット未満の RSA 鍵など、80 ビット未満のセキュリティ強度しか持たないパラメータが拒否されます。

すでに設定されているパラメータがそのレベルの基準を満たさない場合、レベルの引き上げも拒否されることに注意してください。その場合は先にレベルを下げる必要があります。

OpenSSL 1.1.0 未満ではこの機能はサポートされておらず、0 以外の値を設定しようとすると `NotImplementedError` が発生します。レベル 0 はすべてのパラメータを許可することを意味し、これは以前のバージョンの OpenSSL と同じ動作です。

- **param** `level` -- 設定するセキュリティレベル(整数)
- **raise** `NotImplementedError` -- OpenSSL 1.1.0 未満で 0 以外の値を設定しようとした場合に発生します

### def setup -> true | nil

`self` の設定を確定させ、内部状態を準備します。

このメソッドは [c:OpenSSL::SSL::SSLSocket] オブジェクトが生成されるときに自動的に呼び出されます。ただしスレッドセーフではないため、複数のスレッドを使うプログラムでは `SSLSocket` オブジェクトを生成する前に明示的に呼び出しておく必要があります。

初めて呼び出したときは true を返します。すでに呼び出し済みの場合は何もせず nil を返します。

#%since 3.1
### def tmp_dh=(pkey)

一時的 DH 鍵交換で使う DH パラメータを設定します。サーバ側でのみ意味を持ちます。

`pkey` には [c:OpenSSL::PKey::DH] のインスタンスを指定します。このオブジェクトが保持している鍵の成分があっても無視され、サーバはハンドシェイクのたびに新しい鍵ペアを生成します。

[m:OpenSSL::SSL::SSLContext#tmp_dh_callback=] よりもこちらの利用が推奨されます。

```ruby invalid
ctx = OpenSSL::SSL::SSLContext.new
ctx.tmp_dh = OpenSSL::PKey::DH.generate(2048)
svr = OpenSSL::SSL::SSLServer.new(tcp_svr, ctx)
Thread.new { svr.accept }
```

- **param** `pkey` -- 一時的 DH 鍵交換で使う DH パラメータ([c:OpenSSL::PKey::DH] のインスタンス)
- **raise** `OpenSSL::SSL::SSLError` -- `pkey` が DH 鍵でない場合や、設定に失敗した場合に発生します
- **SEE** [m:OpenSSL::SSL::SSLContext#tmp_dh_callback=]

#%end

### def verify_hostname -> bool
### def verify_hostname=(bool)

サーバ証明書がホスト名に対して有効かどうかを検証するかどうかを取得・設定します。

これを機能させるには、[m:OpenSSL::SSL::SSLContext#verify_mode=] に `OpenSSL::SSL::VERIFY_PEER` を設定し、かつ [m:OpenSSL::SSL::SSLSocket#hostname=] でサーバのホスト名を設定しておく必要があります。

- **param** `bool` -- 検証を行うかどうかを true か false で指定します
- **SEE** [m:OpenSSL::SSL::SSLContext#verify_mode=], [m:OpenSSL::SSL::SSLSocket#hostname=]

## Constants
### const DEFAULT_CERT_STORE -> OpenSSL::X509::Store

[m:OpenSSL::SSL::SSLContext#set_params] で信頼する CA 証明書
(ca_file, ca_path, cert_store) を一切指定しなかった場合にデフォルトで使われる証明書ストアです。

[m:OpenSSL::X509::Store#set_default_paths] でシステムが提供する証明書を利用するように設定されています。

### const DEFAULT_PARAMS -> { Symbol -> object }

[m:OpenSSL::SSL::SSLContext#set_params] でデフォルト値として使われるパラメータです。

### const METHODS -> [Symbol]

利用可能なメソッド(プロトコル)を [c:Symbol] の配列で返します。

```ruby
require 'openssl'
p OpenSSL::SSL::SSLContext::METHODS
# => [:TLSv1, :TLSv1_server, :TLSv1_client, :SSLv2, :SSLv2_server, ...]
```

### const SESSION_CACHE_OFF -> Integer

セッションをキャッシュしないことを意味します。

[m:OpenSSL::SSL::SSLContext#session_cache_mode=] に渡すフラグとして用います。

### const SESSION_CACHE_CLIENT -> Integer

クライアント側セッションをキャッシュに追加することを意味します。

[m:OpenSSL::SSL::SSLContext#session_cache_mode=] に渡すフラグとして用います。

クライアント側においては、OpenSSL ライブラリがどのセッションを再利用するべきか確実に判定する方法はないので、再利用する場合は
[m:OpenSSL::SSL::SSLSocket#session=] によって明示的にセッションを指定しなければなりません。

### const SESSION_CACHE_SERVER -> Integer

サーバ側でセッションをキャッシュすることを意味します。

[m:OpenSSL::SSL::SSLContext#session_cache_mode=] に渡すフラグとして用います。

このフラグが立っているとサーバ側の [c:OpenSSL::SSL::SSLContext]
でセッションキャッシュの保持と管理、再利用が行われます。

このフラグはデフォルトで有効になっています。

### const SESSION_CACHE_BOTH -> Integer

サーバ側、クライアント側両方でセッションをキャッシュすることを意味します。

[m:OpenSSL::SSL::SSLContext#session_cache_mode=] に渡すフラグとして用います。

実際には
[m:OpenSSL::SSL::SSLContext::SESSION_CACHE_SERVER] と
[m:OpenSSL::SSL::SSLContext::SESSION_CACHE_CLIENT] のビット論理和を取った値です。

### const SESSION_CACHE_NO_AUTO_CLEAR -> Integer

[c:OpenSSL::SSL::SSLContext] 内部のセッションキャッシュ領域を自動的にクリアしないことを意味します。

通常では255コネクションごとにキャッシュを破棄しますが、このフラグを有効にするとそれをしなくなります。
代わりに適当なタイミングで
[m:OpenSSL::SSL::SSLContext#flush_sessions] を呼びキャッシュを破棄しなければなりません。

[m:OpenSSL::SSL::SSLContext#session_cache_mode=] に渡すフラグとして用います。

### const SESSION_CACHE_NO_INTERNAL -> Integer

[m:OpenSSL::SSL::SSLContext::SESSION_CACHE_NO_INTERNAL_STORE]
と
[m:OpenSSL::SSL::SSLContext::SESSION_CACHE_NO_INTERNAL_LOOKUP]
の両方を有効にすることを意味します。

[m:OpenSSL::SSL::SSLContext#session_cache_mode=] に渡すフラグとして用います。

### const SESSION_CACHE_NO_INTERNAL_LOOKUP -> Integer

サーバ側でセッションキャッシュが必要になった場合
[c:OpenSSL::SSL::SSLContext] が保持するキャッシュ領域を探索しないことを意味します。

[m:OpenSSL::SSL::SSLContext#session_cache_mode=] に渡すフラグとして用います。

このフラグを ON にすると、キャッシュの探索が必要になった場合必ずコールバック([m:OpenSSL::SSL::SSLContext#session_get_cb=]
で設定したもの)を呼ぶようになります。

### const SESSION_CACHE_NO_INTERNAL_STORE -> Integer

セッションキャッシュを [c:OpenSSL::SSL::SSLContext] 内部のキャッシュ領域に保持しないことを意味します。

[m:OpenSSL::SSL::SSLContext#session_cache_mode=] に渡すフラグとして用います。

ハンドシェイクによってセッションが開始された場合にはそのセッションを [c:OpenSSL::SSL::SSLContext] 内部にキャッシュとして保持しますが、このフラグを有効にすると自動的にキャッシュされることはなくなります。
