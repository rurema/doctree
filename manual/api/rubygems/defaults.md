---
type: library
---
RubyGems ライブラリで使用するデフォルト値を返すメソッドを定義したライブラリです。

# reopen Gem

## Singleton Methods

### def default_sources -> [String]

デフォルトのパッケージ情報取得先のリストを返します。

### def default_dir -> String

デフォルトの Gem パッケージをインストールするディレクトリを返します。

### def user_dir -> String

ユーザのホームディレクトリの中の Gem のパスを返します。

### def default_path -> [String]

デフォルトの Gem パッケージをロードするディレクトリのリストを返します。

### def default_exec_format -> String

デフォルトのインストールするコマンド名を決めるためのフォーマット文字列を返します。

### def default_bindir -> String

実行ファイルのデフォルトのパスを返します。

### def default_system_source_cache_dir -> String

デフォルトのシステム全体のソースキャッシュファイルのパスを返します。

### def default_user_source_cache_dir -> String

デフォルトのユーザ専用のソースキャッシュファイルのパスを返します。

### def ruby_engine -> String

Ruby処理系実装の種類を表す文字列を返します。
