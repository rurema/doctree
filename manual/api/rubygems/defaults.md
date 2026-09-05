---
type: library
---
RubyGems ライブラリで使用するデフォルト値を返すメソッドを定義したライブラリです。

# reopen Gem

## Singleton Methods

### def Gem.default_sources -> [String]

デフォルトのパッケージ情報取得先のリストを返します。

### def Gem.default_dir -> String

デフォルトの Gem パッケージをインストールするディレクトリを返します。

### def Gem.user_dir -> String

ユーザのホームディレクトリの中の Gem のパスを返します。

### def Gem.default_path -> [String]

デフォルトの Gem パッケージをロードするディレクトリのリストを返します。

### def Gem.default_exec_format -> String

デフォルトのインストールするコマンド名を決めるためのフォーマット文字列を返します。

### def Gem.default_bindir -> String

実行ファイルのデフォルトのパスを返します。

### def Gem.ruby_engine -> String

Ruby処理系実装の種類を表す文字列を返します。
