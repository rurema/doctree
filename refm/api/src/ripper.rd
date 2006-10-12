#@since 1.9
= class Ripper

((<執筆者募集>))

以下を参照して下さい。

  * [[url:http://i.loveruby.net/w/RipperTutorial.html]]
  * [[url:http://i.loveruby.net/w/RipperTutorial.TokenStreamInterface.html]]

Ruby プログラムをテキストとして扱いたい場合、例えばソース色付けを行いたい場合は、
[[c:Ripper::Filter]] の利用を検討するとよいでしょう。

== Class Methods

--- new(src, filename = "(ripper)", lineno = 1)

--- lex(src, filename = '-', lineno = 1)
--- lex(src, filename = '-', lineno = 1)
→ [((Integer,Integer), Symbol, String)] 

Ruby プログラム str をトークンに分割し、そのリストを返す。ただし tokenize と違い、トークンの種類と位置情報が付帯する。 

使用例
  require 'ripper'
  require 'pp'

  pp Ripper.scan("def m(a) nil end")
      #=> [[[1, 0], :on_kw, "def"],
           [[1, 3], :on_sp, " "],
           [[1, 4], :on_ident, "m"],
           [[1, 5], :on_lparen, "("],
           [[1, 6], :on_ident, "a"],
           [[1, 7], :on_rparen, ")"],
           [[1, 8], :on_sp, " "],
           [[1, 9], :on_kw, "nil"],
           [[1, 12], :on_sp, " "],
           [[1, 13], :on_kw, "end"]]

Ripper.scan は分割したトークンを詳しい情報とともに返します。返り値の配列の要素は 3 要素の配列 (概念的にはタプル) です。その内訳を以下に示します。

:位置情報 (Integer,Integer) 
  トークンが置かれている行 (1-origin) と桁 (0-origin) の 2 要素の配列。 
:種類 (Symbol) 
  「:on_XXX」の形式で表される、トークンの種類。 
:トークン (String) 
  トークン文字列。

--- parse(src, filename = '(ripper)', lineno = 1)

--- sexp(src, filename = '-', lineno = 1)

--- slice(src, pattern, n = 0)
→ String
pattern を正規表現にコンパイルし、src は文字列にコンパイルして、正規表現マッチを行う。
そして、n 番目のカッコ内を取り出す

使用例

  p Ripper.slice(%(<<HERE\nstring\#{nil}\nHERE),
                 "heredoc_beg .*? nl $(.*?) heredoc_end", 1)
  # => "string\#{nil}\n"

--- token_match(src, pattern)

--- tokenize(src, filename = '-', lineno = 1)
→ [String]
Ruby プログラム str をトークンに分割し、そのリストを返す。 

使用例

  require 'ripper'
  p Ripper.tokenize("def m(a) nil end")
      #=> ["def", " ", "m", "(", "a", ")", " ", "nil", " ", "end"]

Ripper.tokenize は最も単純なトークンストリーム API です。特に説明することはありません。

Ripper.tokenize は空白やコメントも含め、元の文字列にある文字は 1 バイトも残さずに分割しますが、そのごく僅かな例外として、__END__ 以降の文字列は黙って捨てられます。これは現在のところ仕様と考えてください。

--- yydebug
--- yydebug=

== Instance Methods

--- parse

--- column

--- lineno

== Constants

--- Version

--- EVENTS 

PARSER_EVENTS + SCANNER_EVENTS

--- PARSER_EVENTS

--- PARSER_EVENT_TABLE

--- SCANNER_EVENTS

--- SCANNER_EVENT_TABLE

= class Ripper::Filter

イベントドリブンインターフェイスを持つクラス。

利用例

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
#@end
