---
type: library
require:
  - webrick/httpservlet/abstract
---
ERB を扱うためのサーブレットを提供するライブラリです。

# class WEBrick::HTTPServlet::ERBHandler < WEBrick::HTTPServlet::AbstractServlet

ERB を扱うためのサーブレットです。

## Class Methods

### def new(server, name) -> WEBrick::HTTPServlet::ERBHandler

自身を初期化します。

- **param** `server` -- [c:WEBrick::GenericServer] のサブクラスのインスタンスを
              指定します。

- **param** `name` -- 実行したい ERB のファイル名を指定します。

## Instance Methods

### def do_GET(request, response) -> ()
### def do_POST(request, response) -> ()

GET, POST リクエストを処理します。

- **param** `request` -- [c:WEBrick::HTTPRequest] のインスタンスを指定します。

- **param** `response` -- [c:WEBrick::HTTPResponse] のインスタンスを指定します。
