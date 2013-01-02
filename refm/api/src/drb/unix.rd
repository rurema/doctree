DRb のプロトコルとして UNIX ドメインソケット経由で通信する drbunix が使えるようになります。

 require 'drb/unix'
 obj = ''
 DRb::DRbServer.new('drbunix:/tmp/hoge', obj)


[[m:DRb::DRbServer.new]] や [[m:DRb.#start_service]] が 
"drbunix" スキームを受け入れるようになります。
また、[[m:DRb::DRbObject.new_with_uri]] でも drbunix スキームが使えるようになります。

サーバを起動するときは以下のオプションが追加で利用できます。

: :UNIXFileMode
  UNIX ドメインソケットと結び付けられたファイルのモードを指定します。
  指定しない場合は [[m:UnixServer.new]] がデフォルトで設定する
  値を利用します。
: :UNIXFileOwner
  UNIX ドメインソケットと結び付けられたファイルの所有者を指定します。
  指定しない場合は [[m:UnixServer.new]] がデフォルトで設定する
  値を利用します。
: :UNIXFileGroup
  UNIX ドメインソケットと結び付けられたファイルのグループを指定します。
  指定しない場合は [[m:UnixServer.new]] がデフォルトで設定する
  値を利用します。

