
RubyGems ライブラリで使用するデフォルト値を返すメソッドを定義したライブラリです。

= reopen Gem

== Singleton Methods

--- default_sources -> [String]

デフォルトのパッケージ情報取得先のリストを返します。

--- default_dir -> String

デフォルトの Gem パッケージをインストールするディレクトリを返します。

--- user_dir -> String

ユーザのホームディレクトリの中の Gem のパスを返します。

--- default_path -> [String]

デフォルトの Gem パッケージをロードするディレクトリのリストを返します。

--- default_exec_format -> String

デフォルトのインストールするコマンド名を決めるためのフォーマット文字列を返します。

--- default_bindir -> String

実行ファイルのデフォルトのパスを返します。

--- default_system_source_cache_dir -> String

デフォルトのシステム全体のソースキャッシュファイルのパスを返します。

--- default_user_source_cache_dir -> String

デフォルトのユーザ専用のソースキャッシュファイルのパスを返します。

--- ruby_engine -> String

Ruby処理系実装の種類を表す文字列を返します。
