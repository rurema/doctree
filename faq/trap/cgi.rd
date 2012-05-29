= trap::CGI
* ((<CGI#out|cgi/out>)) は標準出力への出力を行いますが、 ((<CGI#header|cgi/header>)) では
  出力を行いません。ただ文字列を返すだけです。
  
  そのため
  
    cgi = CGI.new
    cgi.out({"charset" => "shift_jis"}){
      "<html><head><title>TITLE</title></head><body>BODY</body></html>\r\n"
    }
  
  は正しい例ですが
  
    cgi = CGI.new
    cgi.header({"charset" => "shift_jis"})
    print "<html><head><title>TITLE</title></head><body>BODY</body></html>\r\n"

  は間違った例です。
