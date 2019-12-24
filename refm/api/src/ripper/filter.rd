イベントドリブンスタイルで Ruby プログラムを加工するためのライブラリです。

= class Ripper::Filter

イベントドリブンスタイルで Ruby プログラムを加工するためのクラスです。

このクラスを継承して、必要なイベントに対応するメソッドを定義して使用し
ます。

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

Ruby プログラムを解析して、[[m:Ripper::SCANNER_EVENTS]] にあるスキャナ
イベントを実行します。イベントはプログラムに書いた順番で実行されます。

上記の例では、parse メソッドに渡した空文字列を初期値として、イベントハ
ンドラが ARGF で渡された Ruby プログラムを HTML にして返します。

== Class Methods

--- new(src, filename = '-', lineno = 1) -> Ripper::Filter

Ripper::Filter オブジェクトを作成します。

@param src Ruby プログラムを文字列か IO オブジェクトで指定します。

@param filename src のファイル名を文字列で指定します。省略すると "-" になります。

@param lineno src の開始行番号を指定します。省略すると 1 になります。

== Instance Methods

--- filename -> String

Ruby プログラムのファイル名を文字列で返します。

--- lineno -> Integer | nil

現在のトークンの行番号を 1 から始まる数値で返します。

このメソッドはイベントハンドラの中でのみ意味のある値を返します。イベン
トハンドラの中で self.lineno を実行してください。

--- column -> Integer | nil

現在のトークンの桁番号を 0 から始まる数値で返します。

このメソッドはイベントハンドラの中でのみ意味のある値を返します。イベン
トハンドラの中で self.column を実行してください。

--- parse(init = nil) -> object

自身の持つ Ruby プログラムの解析を開始します。各種イベントハンドラで処
理を行った結果を返します。

@param init 任意の値を指定できます。この値がイベントハンドラに渡されていきます。

引数 init を初期値としてイベントハンドラに渡されていきます。各種イベン
トハンドラの戻り値は次のイベントハンドラに渡されます。
[[m:Enumerable#inject]] のように、最終的な結果を戻り値として返します。

@see [[m:Ripper::Filter#on_default]], [[m:Ripper::Filter#on_XXX]]

== Private Instance Methods

--- on_default(event, token, data) -> object

イベントハンドラが未定義のイベントが実行された場合に実行されるイベント
ハンドラです。

@param event 実行されたイベントを :on_XXX 形式のシンボルで指定されます。

@param token 現在のトークンが指定されます。

@param data 前のイベントハンドラの戻り値です。最初のイベントの場合は
            [[m:Ripper::Filter#parse]] の引数になります。

このメソッドの戻り値は次のイベントハンドラの data 引数に渡されます。
on_default をオーバライドしなかった場合は data 引数をそのまま返します。

@see [[m:Ripper::Filter#parse]], [[m:Ripper::Filter#on_XXX]]

--- on_XXX(token, data) -> object

各種スキャナイベントを実行します。

実際には on_XXX というメソッドは存在しません。「XXX」の部分を
[[m:Ripper::SCANNER_EVENTS]] にあるスキャナイベントに読み替えてください。

@param token 現在のトークンが指定されます。

@param data 前のイベントハンドラの戻り値です。最初のイベントの場合は
            [[m:Ripper::Filter#parse]] の引数になります。

オーバライドしなかった場合は on_default が実行されます。

このメソッドの戻り値は次のイベントハンドラの data 引数に渡されます。

@see [[m:Ripper::Filter#parse]], [[m:Ripper::Filter#on_default]], [[m:Ripper::SCANNER_EVENTS]]
