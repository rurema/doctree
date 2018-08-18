Ruby プログラムを S 式として扱うためのライブラリです。

= reopen Ripper

--- Ripper.sexp(src, filename = '-', lineno = 1) -> object

Ruby プログラム str を解析して S 式のツリーにして返します。

@param src Ruby プログラムを文字列か IO オブジェクトで指定します。

@param filename src のファイル名を文字列で指定します。省略すると "-" になります。

@param lineno src の開始行番号を指定します。省略すると 1 になります。

実行結果は、括弧の代わりに配列の要素として S 式のツリーを表現しています。

例:

  require 'ripper'
  require 'pp'

  pp Ripper.sexp("def m(a) nil end")
    # => [:program,
          [[:def,
            [:@ident, "m", [1, 4]],
            [:paren, [:params, [[:@ident, "a", [1, 6]]], nil, nil, nil, nil]],
            [:bodystmt, [[:var_ref, [:@kw, "nil", [1, 9]]]], nil, nil, nil]]]]

パーサイベントは以下のような形式になります。

  [:イベント名, ...]

例:

  [:program, ...]

スキャナイベントは以下のような形式になります。

  [:@イベント名, トークン, 位置情報(行、桁の配列)]

例:

  [:@ident, "m", [1, 4]]

また、Ripper.sexp は [[m:Ripper.sexp_raw]] とは異なり、読みやすさのため
に stmts_add や stmts_new のような _add、_new で終わるパーサイベントを
省略します。_add で終わるパーサイベントはハンドラの引数が 0 個のものが
省略されます。詳しくは [[m:Ripper::PARSER_EVENTS]] を確認してください。

@see [[m:Ripper.sexp_raw]]

--- Ripper.sexp_raw(src, filename = '-', lineno = 1) -> object

Ruby プログラム str を解析して S 式のツリーにして返します。

@param src Ruby プログラムを文字列か IO オブジェクトで指定します。

@param filename src のファイル名を文字列で指定します。省略すると "-" になります。

@param lineno src の開始行番号を指定します。省略すると 1 になります。

実行結果は、括弧の代わりに配列の要素として S 式のツリーを表現しています。

例:

  require 'ripper'
  require 'pp'

  pp Ripper.sexp_raw("def m(a) nil end")
    # => [:program,
          [:stmts_add,
           [:stmts_new],
           [:def,
            [:@ident, "m", [1, 4]],
            [:paren, [:params, [[:@ident, "a", [1, 6]]], nil, nil, nil]],
            [:bodystmt,
             [:stmts_add, [:stmts_new], [:var_ref, [:@kw, "nil", [1, 9]]]],
             nil,
             nil,
             nil]]]]

Ripper.sexp_raw は [[m:Ripper.sexp]] とは異なり解析結果を加工しません。

@see [[m:Ripper.sexp]]
