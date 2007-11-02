#@since 1.8.1
require webrick/httprequest
require webrick/httpresponse
require webrick/config

一般の CGI 環境で WEBrick のサーブレットと同じように CGI スクリプトを書くための
クラス。サーバが WEBrick でなくても使うことが出来る。

[[lib:webrick]]

[[c:WEBrick::HTTPServlet::AbstractServlet]] と同じようにメソッド do_GET や
do_POST を再定義することによって CGI スクリプトを書く。

普通は WEBrick::CGI のサブクラスを定義して、そのクラスに対してメソッド do_XXX を
定義する。

 #!/usr/local/bin/ruby
 require 'webrick/cgi'

 class MyCGI < WEBrick::CGI
   def do_GET(req, res)
     res["content-type"] = "text/plain"
     ret = "hoge\n"
     res.body = ret
   end
 end

 MyCGI.new.start()

= class WEBrick::CGI < Object

== Class Methods

--- new(config={}, *options)
#@todo
CGI オブジェクトを生成する。

== Instance Methods

#@since 1.8.3
--- [](key)
#@todo
#@end

#@since 1.8.3
--- config
#@todo
#@end

#@since 1.8.3
--- logger
#@todo
#@end

--- service(req, res)
#@todo

--- start(env=ENV, stdin=$stdin, stdout=$stdout)
#@todo
スクリプトを実行する。env にはスクリプトが受け取るべき環境変数、stdin には
スクリプトの入力元、stdout には出力先を指定する。

= class WEBrick::CGI::CGIError < StandardError

= class WEBrick::CGI::Socket
include Enumerable

== Class Methods

--- new(config, env, stdin, stdout)
#@todo

== Instance Methods

--- <<(data)
#@todo

--- addr
#@todo

--- cert
#@todo

--- cipher
#@todo

--- each {|line| ... }
#@todo

--- gets(eol = WEBrick::LF)
#@todo

--- peeraddr
#@todo

--- peer_cert
#@todo

--- peer_cert_chain
#@todo

--- read(size = nil)
#@todo

#@end
