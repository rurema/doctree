---
library: drb
---
# module DRb::DRbProtocol

drb で使われる通信プロトコルを取り扱うモジュールです。

通常ユーザが使うことはないでしょうが、drb のための新しい通信手段を定義したい場合にはこのモジュールを使う必要があります。
通信手段を定義したクラスを [m:DRb::DRbProtocol?.add_protocol] で
drb に登録することで、追加ができます。

デフォルトでは DRbTCPSocket クラスを用い、druby://... という
URI を指定することで TCP/IP で通信します。

通信プロトコルを追加する例としては、例としては [lib:drb/unix] で定義している [c:DRb::DRbUNIXSocket] やサンプルの sample/drb/http0.rb、 sample/drb/http0serv.rb などを見てください。

これらの例を見てわかるように、通信クラスでは取り扱えない URI が open
や open_server に渡された場合は例外 [c:DRb::DRbBadScheme] を
raise することで、その URI が取り扱えないことを drb ライブラリに伝えます。

### 通信プロトコル定義クラスについて

上で説明した通信プロトコル定義クラスは、以下のクラスメソッドをそなえている必要があります。

- **`open(uri, config)`**:
  uri で指定したサーバへの接続を開く。
  返り値として、プロトコルクラスのインスタンスで、開いた接続を保持したオブジェクトを返さなければなりません。
- **`open_server(uri, config)`**:
  サーバを起動し、 uri で指定した場所で接続を待ち受けます。
  返り値として、プロトコルクラスのインスタンスで、接続を待ち受けているオブジェクトを返さなければなりません。
- **`uri_option(uri, config)`**:
  uri をパースして、そこに含まれるオプション("?param=val" など)を取り出します。
  返り値として、[uri, option] という配列を返します。

プロトコルクラスは [m:DRb::DRbProtocol?.add_protocol] で登録します。

DRbProtocol module は登録された各プロトコルクラスに対して順に
open/open_server を呼び出して、接続を確立しようとします。
各プロトコルクラスはその URI が取り扱える場合は接続を確立/待受けし、その通信を取り扱うオブジェクトを返します。URI が取り扱えない場合は
[c:DRb::DRbBadScheme] を発生させなければなりません。
DRbProtocol module に登録されたクラスでは URI を取り扱えない場合は [c:DRb::DRbBadURI] が発生します。
URI は妥当であるが、通信に問題が発生した場合は [c:DRb::DRbConnError]
を発生させる必要があります。

#### open_server

プロトコルクラスの open_server で返されるオブジェクトは以下のメソッドを持っている必要があります。

- **`accept`**:
  接続を受け付けます。返り値としてクライアントとの通信ができるオブジェクト
  (後で説明します)を返します。

- **`close`**:
  接続の待受を終了します。

- **`uri`**:
  接続を待ち受けている uri を返します。

#### open

プロトコルクラスの open で返されるオブジェクトは以下のメソッドを持っている必要があります。

- **`send_request (ref, msg_id, arg, b)`**:
  ref で指定されているオブジェクトの msg_id で指定されているメソッドを
  arg という引数と b というブロック付きで呼び出す、というリクエストを送ります。DRbMessage#send_request を呼び出して通信オブジェクトが保持しているストリームにデータを送る、というのが最も簡単なこのメソッドの実装法です。

- **`recv_reply`**:
  サーバからリプライを受け取り、[success-boolean, reply-value] という配列を返します。DRb.recv_reply を呼び出し、通信オブジェクトが保持しているストリームからリプライを受け取る、というのが最も簡単なこのメソッドの実装法です。

- **`alive?`**:
  接続が生きているならば真を返し、切れていれば偽を返します。

- **`close`**:
  接続を閉じます。

#### open_server().accept

プロトコルクラスの open_server で返されるオブジェクトの accept メソッドで返されるオブジェクトは以下のメソッドを持っている必要があります。

- **`recv_request`**:
  クライアントからのリクエストを受け取り
  [object, message, args, block] という配列を返します。
  DRbMessage#recv_request を呼び出してストリームからメッセージを読み取る、というのが最も簡単なこのメソッドの実装法です。

- **`send_reply(succ, result)`**:
  クライアントにリプライを送る。 DRbMessage#send_reply を呼び出してストリームにメッセージを書き込む、というのが最も簡単なこのメソッドの実装法です。

- **`close`**:
  接続を閉じる

## Module Functions

### module_function def add_protocol(prot) -> ()

新たなプロトコルを DRbProtocol モジュールに登録します。

- **param** `prot` -- プロトコル定義クラス

#%# auto_load, open, open_server, uri_option is used internally
#%# and users should not use these methods directly

# class DRb::DRbConnError < DRb::DRbError

通信エラーが発生したことを意味する例外クラス。

# class DRb::DRbBadScheme < DRb::DRbError

プロトコルクラスが受け取った URI の scheme がそのクラスでサポートされていないことを、伝えるための例外。

- **SEE** [c:DRb::DRbProtocol]

# class DRb::DRbBadURI < DRb::DRbError

URI に含まれている scheme をサポートしているプロトコルが見付からないことを意味する例外クラス。
