このライブラリは obsolete です。
[[lib:cgi]] ライブラリを使ってください。

= class CGI_cgi_lib

このライブラリは obsolete です。
[[lib:cgi]] ライブラリを使ってください。

== Singleton Methods

--- new(input = $stdin) -> CGI_cgi_lib

自身を初期化します。

--- rfc1123_date(time) -> String

与えられた [[c:Time]] オブジェクトを [[rfc:1123]] で定められた形式の文字列に変換します。

@param time [[c:Time]] オブジェクトを指定します。

--- escape(str) -> String

与えられた文字列を URL エンコードします。

@param str 文字列を指定します。

--- unescape(str) -> String

URL エンコードされた文字列をデコードします。

@param str URL エンコードされた文字列を指定します。

--- escapeHTML(str) -> String

与えられた文字列に含まれる危険な文字列を実態参照に置き換えます。

@param str 文字列を指定します。

--- tag(element, attributes = {}) -> String
--- tag(element, attributes = {}){ ... } -> String

HTML タグを表す文字列を作って返します。

ブロックが与えられた場合は、ブロックを評価した結果が HTML タグに挟まれます。

@param element タグの名前を指定します。

@param attributes タグに指定する属性をハッシュで指定します。

--- cookie(options) -> String

生のクッキー文字列を作成します。

@param options ハッシュを指定します。

--- header(*options) -> String
HTTP ヘッダ文字列を作成します。

@param options オプションを指定します。

--- print(*options){ ... } -> ()

標準出力にブロックを評価した結果を書き込みます。

@param options [[m:CGI_cgi_lib.header]] と同じです。

--- message(message, title = "", header = ["Content-Type: text/html"]) -> true
メッセージを標準出力に出力します。

@param message メッセージを指定します。

@param title タイトルを指定します。

@param header HTTP ヘッダーを指定します。

--- error -> ()
エラーメッセージを出力して [[m:Kernel.#exit]] します。

== Instance Methods

--- read_from_cmdline

オフラインモード。

コマンドライン引数か、標準入力からクエリパラメータを読み込みます。

--- inputs -> Hash

クエリパラメータを表すハッシュ。

--- cookie -> Hash

クッキーを表すハッシュ。

== Constants

--- CR -> String

キャリッジリターンです。

--- LF -> String

ラインフィードです。

--- EOL -> String

行末です。

--- RFC822_DAYS -> [String]

[[rfc:822]] で定められている曜日の略称です。

--- RFC822_MONTHS -> [String]

[[rfc:822]] で定められている月の略称です。
