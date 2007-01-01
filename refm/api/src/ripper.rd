require ripper/filter
require ripper/lexer
require ripper/sexp

Ruby プログラムを解析するためのライブラリです。

= class Ripper

以下を参照して下さい。

  * [[url:http://i.loveruby.net/w/RipperTutorial.html]]
  * [[url:http://i.loveruby.net/w/RipperTutorial.TokenStreamInterface.html]]

Ruby プログラムをテキストとして扱いたい場合、
例えばソース色付けを行いたい場合は、
[[c:Ripper::Filter]] クラスを使うとよいでしょう。

== Class Methods

--- new(src, filename = "(ripper)", lineno = 1)

Ripper オブジェクトを作成します。

第一引数 src には Ruby プログラム (文字列)、
第二引数 filename には src のファイル名、
第三引数 lineno には src の開始行番号を、それぞれ与えます。

--- lex(src, filename = '-', lineno = 1)
--- lex(src, filename = '-', lineno = 1)
#@# → [((Integer,Integer), Symbol, String)] 

Ruby プログラム str をトークンに分割し、そのリストを返します。
ただし tokenize と違い、トークンの種類と位置情報も付属します。

使用例

  require 'ripper'
  require 'pp'

  pp Ripper.lex("def m(a) nil end")
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

Ripper.lex は分割したトークンを詳しい情報とともに返します。
返り値の配列の要素は 3 要素の配列 (概念的にはタプル) です。
その内訳を以下に示します。

:位置情報 (Integer,Integer) 
    トークンが置かれている行 (1-origin) と桁 (0-origin) の 2 要素の配列です。 
:種類 (Symbol) 
    トークンの種類が「:on_XXX」の形式のシンボルで渡されます。
:トークン (String) 
    トークン文字列です。

--- parse(src, filename = '(ripper)', lineno = 1)

--- sexp(src, filename = '-', lineno = 1)

--- sexp_raw(src, filename = '-', lineno = 1)

--- slice(src, pattern, n = 0)
#@# → String

Ruby プログラム文字列 src から
pattern の n 番目の括弧にマッチするテキストを返します。
ただし、n が 0 のときは pattern 全体を表します。

pattern はイベント ID またはメタパターンを列挙した文字列で表現します。
メタパターンには Ruby の正規表現と同じメタ記号が使えます。

使用例

  p Ripper.slice(%(<<HERE\nstring\#{nil}\nHERE),
                 "heredoc_beg .*? nl $(.*?) heredoc_end", 1)
      # => "string\#{nil}\n"

--- token_match(src, pattern)

--- tokenize(src, filename = '-', lineno = 1)
#@# → [String]

Ruby プログラム str をトークンに分割し、そのリストを返します。

使用例

  require 'ripper'
  p Ripper.tokenize("def m(a) nil end")
      #=> ["def", " ", "m", "(", "a", ")", " ", "nil", " ", "end"]

Ripper.tokenize は空白やコメントも含め、
元の文字列にある文字は 1 バイトも残さずに分割します。
ただし、ごく僅かな例外として、__END__ 以降の文字列は黙って捨てられます。
これは現在のところ仕様と考えてください。

--- yydebug
--- yydebug=

== Instance Methods

--- parse

--- column

--- lineno

--- end_seen?

== Private Instance Methods

--- warn(fmt, *args)

--- warning(fmt, *args)

--- compile_error(msg)

== Constants

--- Version

--- EVENTS 

PARSER_EVENTS + SCANNER_EVENTS

--- PARSER_EVENTS

パーサイベントのイベント ID (シンボル) のリストを返します。

--- PARSER_EVENT_TABLE

--- SCANNER_EVENTS

スキャナイベントのイベント ID (シンボル) のリストを返します。

--- SCANNER_EVENT_TABLE

