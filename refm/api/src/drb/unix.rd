DRb のプロトコルとして UNIX ドメインソケット経由で通信する drbunix が使えるようになります。

 require 'drb/unix'
 obj = ''
 DRb::DRbServer.new('drbunix:/tmp/hoge', obj)
