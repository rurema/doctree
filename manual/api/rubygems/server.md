---
type: library
include:
  - Gem::UserInteraction
require:
  - rubygems
  - rubygems/doc_manager
---
Gem パッケージを配布したり Gem パッケージに同梱されているドキュメントを参照するための
簡易ウェブサーバを動かすためのライブラリです。

[lib:rubygems/commands/server_command] を使用して起動するウェブサーバの本体です。

このライブラリを使用したウェブサーバは以下の設定で動作します。

- **`"/"`**:
  インストールされている Gem パッケージの一覧を表示します。
- **`"/specs.#{Gem.marshal_version}.gz"`**:
  インストールされている全バージョンの情報 (パッケージ名、バージョン、プラットフォーム) を返します。
- **"/latest_specs.#{Gem.marshal_version}.gz"**:
  インストールされている最新バージョンの情報 (パッケージ名、バージョン、プラットフォーム) を返します。
- **"/quick/index", "/quick/index.rz", "/quick/latest_index", "/quick/latest_index.rz"**:
  インストールされている Gem パッケージの一覧を返します。
- **`"/gems/"`**:
  ダウンロード可能な Gem パッケージの一覧を表示します。

以下のインデックスはレガシーなものです。

- **`"/Marshal.#{Gem.marshal_version}"`**:
  インストールされている Gem パッケージの [c:Gem::SourceIndex] を [c:Marshal] の
  形式でダンプしたものを返します。
- **`"/yaml"`**:
  インストールされている Gem パッケージの [c:Gem::SourceIndex] を YAML 形式で
  ダンプしたメタデータを返します。この機能は非推奨です。

# class Gem::Server

Gem パッケージを配布したり Gem パッケージに同梱されているドキュメントを参照するための
簡易ウェブサーバを動かすためのクラスです。

## Instance Methods

### def Marshal(request, response) -> ()

メソッド名に対応する URI に対するリクエストを処理するメソッドです。

- **param** `request` --  [c:WEBrick::HTTPRequest] オブジェクトが自動的に指定されます。

- **param** `response` -- [c:WEBrick::HTTPResponse] オブジェクトが自動的に指定されます。

### def latest_specs(request, response) -> ()

メソッド名に対応する URI に対するリクエストを処理するメソッドです。

- **param** `request` --  [c:WEBrick::HTTPRequest] オブジェクトが自動的に指定されます。

- **param** `response` -- [c:WEBrick::HTTPResponse] オブジェクトが自動的に指定されます。

### def quick(request, response) -> ()

メソッド名に対応する URI に対するリクエストを処理するメソッドです。

- **param** `request` --  [c:WEBrick::HTTPRequest] オブジェクトが自動的に指定されます。

- **param** `response` -- [c:WEBrick::HTTPResponse] オブジェクトが自動的に指定されます。

### def root(request, response) -> ()

メソッド名に対応する URI に対するリクエストを処理するメソッドです。

- **param** `request` --  [c:WEBrick::HTTPRequest] オブジェクトが自動的に指定されます。

- **param** `response` -- [c:WEBrick::HTTPResponse] オブジェクトが自動的に指定されます。

### def run -> ()

サーバを実行します。

### def specs(request, response) -> ()

メソッド名に対応する URI に対するリクエストを処理するメソッドです。

- **param** `request` --  [c:WEBrick::HTTPRequest] オブジェクトが自動的に指定されます。

- **param** `response` -- [c:WEBrick::HTTPResponse] オブジェクトが自動的に指定されます。

### def yaml(request, response) -> ()

メソッド名に対応する URI に対するリクエストを処理するメソッドです。

- **param** `request` --  [c:WEBrick::HTTPRequest] オブジェクトが自動的に指定されます。

- **param** `response` -- [c:WEBrick::HTTPResponse] オブジェクトが自動的に指定されます。

## Singleton Methods

#@since 1.9.2
### def new(gem_dirs, port, daemon, addresses = nil) -> Gem::Server
#@else
### def new(gem_dir, port, daemon) -> Gem::Server
#@end

サーバーを初期化します。

#@since 1.9.2
- **param** `gem_dirs` -- Gem を格納しているディレクトリを指定します。
#@end
- **param** `gem_dir` -- Gem を格納しているディレクトリを指定します。

- **param** `port` -- リッスンするポートを指定します。

- **param** `daemon` -- 真を指定するとデーモンとして起動します。

#@since 1.9.2
- **param** `addresses` -- 
#@end

### def run(options) -> Gem::Server

与えられたオプションを使用してサーバを起動します。

- **param** `options` -- オプションを表すハッシュを指定します。含まれるキーは :gemdir, :port, :daemon です。

- **SEE** [m:Gem::Server.new]


## Constants

### const DOC_TEMPLATE -> String

ドキュメントのテンプレートを表す文字列です。

### const RDOC_CSS -> String

RDoc のための CSS を表す文字列です。
