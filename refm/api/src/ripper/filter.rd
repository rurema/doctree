イベントドリブンスタイルで Ruby プログラムを加工するためのライブラリです。

= class Ripper::Filter

イベントドリブンスタイルで Ruby プログラムを加工するためのクラスです。

=== 使用例

  require 'ripper'
  require 'cgi'
  
  class Ruby2HTML < Ripper::Filter
    def on_default(event, tok, f)
      f << CGI.escapeHTML(tok)
    end
  
    def on_comment(tok, f)
      f << %Q[<span class="comment">#{CGI.escapeHTML(tok)}</span>]
    end
  
    def on_tstring_beg(tok, f)
      f << %Q[<span class="string">#{CGI.escapeHTML(tok)}]
    end
  
    def on_tstring_end(tok, f)
      f << %Q[#{CGI.escapeHTML(tok)}</span>]
    end
  end
  
  Ruby2HTML.new(ARGF).parse('')

== Class Methods

--- new(src, filename = '-', lineno = 1)
#@todo

== Instance Methods

--- filename
#@todo

--- lineno
#@todo

--- column
#@todo

--- parse(init = nil)
#@todo

== Private Instance Methods

--- on_default(event, token, data)
#@todo

