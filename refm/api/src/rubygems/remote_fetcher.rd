require rubygems

リモートソースから Gem パッケージや Gem パッケージの情報を取得するためのライブラリです。

= class Gem::RemoteFetcher
include Gem::UserInteraction

リモートソースから Gem パッケージや Gem パッケージの情報を取得するためのクラスです。

== Singleton Methods

--- fetcher -> Gem::RemoteFetcher

このクラスの唯一のインスタンスを返します。

== Instance Methods

--- download(spec, source_uri, install_dir = Gem.dir) -> String

source_uri から取得した Gem パッケージをキャッシュディレクトリに配置します。

既に Gem パッケージが存在する場合は、ファイルを置き換えませんが source_uri が
ローカルパス (file://) である場合は常にファイルを置き換えます。

@param spec [[c:Gem::Specification]] のインスタンスを指定します。

@param source_uri 取得先の URI を指定します。

@param install_dir ダウンロードしたファイルの配置先を指定します。

@return ローカルにコピーした Gem ファイルのパスを返します。

@raise Gem::RemoteFetcher::FetchError 

--- fetch_path(uri, mtime = nil, head = false) -> String | Hash

与えられた URI からダウンロードしたデータを文字列として返します。

ヘッダ情報のみ取得した場合はハッシュを返します。

@param uri データ取得先の URI を指定します。

@param mtime 更新時刻を指定します。

@param head 真を指定するとヘッダ情報のみ取得します。

--- fetch_size(uri) -> Integer

与えられた URI からダウンロードするデータのサイズを返します。

@param uri データ取得先の URI を指定します。

--- escape(str) -> String

URI 文字列をエンコードした文字列を返します。

@param str 文字列を指定します。

@see [[m:URI.escape]]

--- unescape(str) -> String

URI 文字列をデコードした文字列を返します。

@param str 文字列を指定します。

@see [[m:URI.unescape]]

--- get_proxy_from_env -> URI | nil

環境変数にセットされている HTTP proxy の情報を取得して返します。

ここでチェックしている環境変数は以下の通りです。

 * http_proxy
 * http_proxy_user
 * http_proxy_pass
 * HTTP_PROXY
 * HTTP_PROXY_USER
 * HTTP_PROXY_PASS

--- normalize_uri(uri) -> String

URI のスキーム部分が欠けている場合に "http://" を補って返します。

@param uri URI 文字列を指定します。

--- connection_for(uri) -> Net::HTTP

HTTP コネクションを生成して返します。

既に接続している URI であれば、生成済みのコネクションを返します。
また、必要があればプロキシを使用します。

@param uri 接続先の URI を指定します。

--- open_uri_or_path(uri, last_modified = nil, head = false, depth = 0) -> StringIO | File

@param uri URI を指定します。

@param last_modified 最終更新時刻を指定します。

@param head 真を指定するとヘッダ情報のみ取得します。

@param depth 現在のリダイレクト回数を指定します。

@raise Gem::RemoteFetcher::FetchError デフォルトでは 11 回リダイレクトした場合に発生します。
       depth を指定すると 10 - depth 回より多くリダイレクトした場合にこの例外が発生するようになります。
       また HTTP のレスポンスが想定外のものの場合にも発生します。

--- request(uri, request_class, last_modified = nil) -> Net::HTTPResponse

与えられた URI に対してリクエストを実行し、[[c:Net::HTTPResponse]] を返します。

@param uri URI を指定します。

@param request_class [[c:Net::HTTP::Head]] か [[c:Net::HTTP::Get]] を指定します。

@param last_modified 最終更新時刻を指定します。

@see [[c:Net::HTTP]], [[c:Net::HTTP::Head]], [[c:Net::HTTP::Get]]

--- reset(connection) -> Net::HTTP

与えられたコネクションをリセットします。

@param connection コネクションを指定します。


--- file_uri?(uri) -> bool

"file://" で始まる文字列である場合は真を返します。そうでない場合は偽を返します。

@param uri URI を表す文字列を指定します。

--- get_file_uri_path(uri) -> String

与えられた URI から "file://" を取り除いた文字列を返します。

@param uri URI を表す文字列を指定します。

= class Gem::RemoteFetcher::FetchError < Gem::Exception

[[c:Gem::RemoteFetcher]] での処理で発生する IO や HTTP の例外をラップする例外クラスです。

== Singleton Methods

--- new(message, uri) -> Gem::RemoteFetcher::FetchError

この例外クラスを初期化します。

@param message メッセージを指定します。

@param uri 問題が発生した URI を指定します。


== Instance Methods

--- uri -> URI

問題が発生した URI を返します。

#@#--- to_s -> String
#@# nodoc
#@#例外の情報を文字列として返します。
