Ruby プログラムをトークンのリストとして処理するためのライブラリです。

= reopen Ripper

--- Ripper.lex(src, filename = '-', lineno = 1) -> [[Integer, Integer], Symbol, String]

Ruby プログラム str をトークンに分割し、そのリストを返します。
ただし [[m:Ripper.tokenize]] と違い、トークンの種類と位置情報も付属します。

@param src Ruby プログラムを文字列か IO オブジェクトで指定します。

@param filename src のファイル名を文字列で指定します。省略すると "-" になります。

@param lineno src の開始行番号を指定します。省略すると 1 になります。

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

: 位置情報 (Integer,Integer)
    トークンが置かれている行 (1-origin) と桁 (0-origin) の 2 要素の配列です。
: 種類 (Symbol)
    トークンの種類が「:on_XXX」の形式のシンボルで渡されます。
: トークン (String)
    トークン文字列です。

--- Ripper.tokenize(src, filename = '-', lineno = 1) -> [String]

Ruby プログラム str をトークンに分割し、そのリストを返します。

@param src Ruby プログラムを文字列か IO オブジェクトで指定します。

@param filename src のファイル名を文字列で指定します。省略すると "-" になります。

@param lineno src の開始行番号を指定します。省略すると 1 になります。

使用例

  require 'ripper'
  p Ripper.tokenize("def m(a) nil end")
      #=> ["def", " ", "m", "(", "a", ")", " ", "nil", " ", "end"]

Ripper.tokenize は空白やコメントも含め、
元の文字列にある文字は 1 バイトも残さずに分割します。
ただし、ごく僅かな例外として、__END__ 以降の文字列は黙って捨てられます。
これは現在のところ仕様と考えてください。

--- Ripper.slice(src, pattern, n = 0) -> String | nil

Ruby プログラム src のうち、
パターン pattern の n 番目の括弧にマッチする文字列を取り出します。

マッチしない場合は nil を返します。

@param src Ruby プログラムを文字列か IO オブジェクトで指定します。

@param pattern 取り出すプログラムのパターンを文字列で指定します。

@param n pattern で指定した文字列の内、n 番目の括弧の中の文字列だけが必
         要な時に指定します。省略すると 0 (pattern 全体)になります。

pattern は Ripper のイベント ID のリストを文字列で記述します。
また pattern には Ruby の正規表現と同じメタ文字も使えます。
ただし「.」は任意のトークン 1 つにマッチし、
その他のメタ文字もすべて文字単位ではなくトークン単位で動作します。

使用例

  require 'ripper'
  p Ripper.slice(%(<<HERE\nstring\#{nil}\nHERE),
                 "heredoc_beg .*? nl $(.*?) heredoc_end", 1)
      # => "string\#{nil}\n"

イベント ID は [[m:Ripper::SCANNER_EVENTS]] で確認できます。

--- Ripper.token_match(src, pattern) -> Ripper::TokenPattern::MatchData | nil

Ruby プログラム src に対してパターン pattern をマッチし、
マッチデータを返します。

ライブラリ内部で使用します。

= class Ripper::Lexer < Ripper

Ruby プログラムの字句解析器です。

== Instance Methods

--- tokenize -> [String]

自身の持つ Ruby プログラムをトークンに分割し、そのリストを返します。

ライブラリ内部で使用します。 [[m:Ripper.tokenize]] を使用してください。

--- lex -> [[Integer, Integer], Symbol, String]

自身の持つ Ruby プログラムをトークンに分割し、そのリストを返します。

ライブラリ内部で使用します。 [[m:Ripper.lex]] を使用してください。

--- parse -> [[Integer, Integer], Symbol, String]

自身の持つ Ruby プログラムをトークンに分割し、そのリストを返します。た
だし [[m:Ripper::Lexer#lex]] と違い、結果をソートしません。

ライブラリ内部で使用します。
