---
library: rubygems/remote_fetcher
include:
  - Gem::UserInteraction
---
# class Gem::RemoteFetcher

リモートソースから Gem パッケージや Gem パッケージの情報を取得するためのクラスです。

## Singleton Methods

### def Gem::RemoteFetcher.fetcher -> Gem::RemoteFetcher

このクラスの唯一のインスタンスを返します。

## Instance Methods

### def download(spec, source_uri, install_dir = Gem.dir) -> String

source_uri から取得した Gem パッケージをキャッシュディレクトリに配置します。

既に Gem パッケージが存在する場合は、ファイルを置き換えませんが source_uri が
ローカルパス (file://) である場合は常にファイルを置き換えます。

- **param** `spec` -- [c:Gem::Specification] のインスタンスを指定します。

- **param** `source_uri` -- 取得先の URI を指定します。

- **param** `install_dir` -- ダウンロードしたファイルの配置先を指定します。

- **return** -- ローカルにコピーした Gem ファイルのパスを返します。

- **raise** `Gem::RemoteFetcher::FetchError` -- Gem の取得に失敗した場合に発生します。

### def fetch_path(uri, mtime = nil, head = false) -> String | object

与えられた URI からダウンロードしたデータを文字列として返します。

uri のスキームが http/https/s3 で head に真を指定した場合は、ボディを
読まずにレスポンスオブジェクト([m:Gem::RemoteFetcher#request] の戻り値)を
そのまま返します。file:// の場合は head の指定によらず常に文字列を返します。

- **param** `uri` -- データ取得先の URI を指定します。

- **param** `mtime` -- 更新時刻を指定します。

- **param** `head` -- 真を指定するとヘッダ情報のみ取得します。

#%until 3.3
### def request(uri, request_class, last_modified = nil) -> Net::HTTPResponse

与えられた URI に対してリクエストを実行し、[c:Net::HTTPResponse] を返します。

- **param** `uri` -- URI を指定します。

- **param** `request_class` -- [c:Net::HTTP::Head] か [c:Net::HTTP::Get] を指定します。

- **param** `last_modified` -- 最終更新時刻を指定します。

- **SEE** [c:Net::HTTP], [c:Net::HTTP::Head], [c:Net::HTTP::Get]
#%end
#%since 3.3
### def request(uri, request_class, last_modified = nil) -> Gem::Net::HTTPResponse

与えられた URI に対してリクエストを実行し、レスポンスオブジェクトを返します。

Ruby 3.3 以降の RubyGems は net-http を `Gem::Net` 名前空間の下に取り込んで
いるため、戻り値は [c:Net::HTTPResponse] ではなく、それと同じインター
フェースを持つ別クラス `Gem::Net::HTTPResponse` です。

- **param** `uri` -- URI を指定します。

- **param** `request_class` -- `Gem::Net::HTTP::Head` か `Gem::Net::HTTP::Get` を指定します。

- **param** `last_modified` -- 最終更新時刻を指定します。
#%end
