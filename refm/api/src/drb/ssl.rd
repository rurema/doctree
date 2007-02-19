DRb のプロトコルとして SSL/TLS 上で通信する drbssl が使えるようになります。

 require 'drb/ssl'
 obj = ''
 DRb::DRbServer.new( 'drbssl://localhost:10000', 
                     obj, 
                     {:SSLCertName => [["CN","fqdn.example.com"]]})

#@todo
