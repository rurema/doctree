---
library: drb/unix
---
# class DRb::DRbUNIXSocket

drbunix: という形式の URI を使い、UNIX ドメインソケット経由で通信する
プロトコル実装クラスです。[lib:drb/unix] を require すると、
[m:DRb::DRbProtocol?.add_protocol] によって自動的に drb に登録されます。

内部的には、druby:// (TCP/IP) 用のプロトコル実装クラスである
DRbTCPSocket のサブクラスとして実装されています。

プロトコル実装クラスに要求されるインターフェースについては
[c:DRb::DRbProtocol] を参照してください。通常、ユーザーがこのクラスの
メソッドを直接呼び出すことはありません。

## Class Methods

### def open(uri, config) -> DRb::DRbUNIXSocket

uri で指定した UNIX ドメインソケットに接続します。

- **param** `uri` -- "drbunix:パス" という形式の URI を指定します。

- **param** `config` -- 接続の設定を [c:Hash] で指定します。

- **raise** `DRb::DRbBadScheme` -- uri が "drbunix:" で始まらない場合に発生します。

### def open_server(uri, config) -> DRb::DRbUNIXSocket

uri で指定したパスに UNIX ドメインソケットを作成し、接続を待ち受けます。

パスの部分を省略した場合(例: "drbunix:")は、一時ファイルにソケットを作成します。

- **param** `uri` -- "drbunix:パス" という形式の URI を指定します。

- **param** `config` -- 接続の設定を [c:Hash] で指定します。
             `:UNIXFileMode`、`:UNIXFileOwner`、`:UNIXFileGroup` を指定できます。
             詳細は [lib:drb/unix] を参照してください。

### def uri_option(uri, config) -> [String, String | nil]

uri をパースして [uri, option] という配列を返します。

- **param** `uri` -- "drbunix:パス" または "drbunix:パス?オプション" という
             形式の URI を指定します。

- **param** `config` -- 接続の設定を [c:Hash] で指定します。

```ruby
require 'drb/unix'
p DRb::DRbUNIXSocket.uri_option("drbunix:/tmp/foo?opt1", {}) # => ["drbunix:/tmp/foo", "opt1"]
```

## Instance Methods

### def close -> ()

接続を閉じます。[m:DRb::DRbUNIXSocket.open_server] が返したオブジェクトの
場合は、待ち受け用の UNIX ドメインソケットファイルも削除します。

### def accept -> DRb::DRbUNIXSocket

クライアントからの接続を受け付け、そのクライアントとの通信を行うための
新しい DRbUNIXSocket オブジェクトを返します。

[m:DRb::DRbUNIXSocket.open_server] が返したオブジェクトに対して呼び出します。

### def uri -> String

接続している、または接続を待ち受けている URI を返します。
