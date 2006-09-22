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
CGI オブジェクトを生成する。

== Instance Methods

--- start(env=ENV, stdin=$stdin, stdout=$stdout)
スクリプトを実行する。env にはスクリプトが受け取るべき環境変数、stdin には
スクリプトの入力元、stdout には出力先を指定する。
