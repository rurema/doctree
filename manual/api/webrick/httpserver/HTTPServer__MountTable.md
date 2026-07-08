---
library: webrick/httpserver
---
# class WEBrick::HTTPServer::MountTable

サーバ上のパスとサーブレットの対応関係を管理するためのクラスです。

## Class Methods

### def new -> WEBrick::HTTPServer::MountTable

自身を初期化します。

## Instance Methods

### def [](dir) -> WEBrick::HTTPServlet::AbstractServlet

与えられたディレクトリに対応するサーブレットを返します。

- **param** `dir` -- ディレクトリを指定します。

- **return** -- [c:WEBrick::HTTPServlet::AbstractServlet] のサブクラスのインタンスを返します。

### def []=(dir, val)

与えられたディレクトリに対応するサーブレットを登録します。

- **param** `dir` -- ディレクトリを指定します。

- **param** `val` -- サーブレットを指定します。

### def delete(dir) -> WEBrick::HTTPServlet::AbstractServlet

ディレクトリとサーブレットの対応を削除してサーブレットを返します。

- **param** `dir` -- ディレクトリを指定します。

- **return** -- [c:WEBrick::HTTPServlet::AbstractServlet] のサブクラスのインタンスを返します。

### def scan(path) -> Array
#@# 自信ない
与えられたパスをスクリプトの名前と PATH_INFO に分割します。

- **param** `path` -- パスを指定します。
