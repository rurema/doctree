require rubygems

設定ファイルに書かれている gem コマンドのオプションを
オブジェクトに保存するためのライブラリです。

= class Gem::ConfigFile

設定ファイルに書かれている gem コマンドのオプションを
オブジェクトに保存するためのクラスです。

このクラスのインスタンスはハッシュのように振る舞います。

== Public Instance Methods

--- [](key) -> object
#@todo

引数で与えられたキーに対応する設定情報を返します。

@param key 設定情報を取得するために使用するキーを指定します。

--- []=(key, value)
#@todo

引数で与えられたキーに対応する設定情報を自身に保存します。

@param key 設定情報をセットするために使用するキーを指定します。

@param value 設定情報の値を指定します。

--- args -> Array
#@todo

設定ファイルオブジェクトに与えられたコマンドライン引数のリストを返します。

--- backtrace -> bool
#@todo

エラー発生時にバックトレースを出力するかどうかを返します。

真の場合はバックトレースを出力します。そうでない場合はバックトレースを出力しません。

--- backtrace=(backtrace)
#@todo

エラー発生時にバックトレースを出力するかどうか設定します。

@param backtrace 真を指定するとエラー発生時にバックトレースを出力するようになります。

--- benchmark -> bool
#@todo

真の場合はベンチマークを実行します。

--- benchmark=(benchmark)
#@todo

ベンチマークを実行するかどうか設定します。

@param benchmark 真を指定するとベンチマークを実行するようになります。

--- bulk_threshold -> Integer
#@todo

Bulk threshold value.  If the number of missing gems are above
this threshold value, then a bulk download technique is used.

--- bulk_threshold=(bulk_threshold)
#@todo

Bulk threshold value.  If the number of missing gems are above
this threshold value, then a bulk download technique is used.

--- config_file_name -> String
#@todo

設定ファイルの名前を返します。

--- each{|key, value| ... }
#@todo

設定ファイルの各項目のキーと値をブロック引数として与えられたブロックを評価します。

--- handle_arguments(arg_list)
#@todo

コマンドに渡された引数を処理します。

@param arg_list コマンドに渡された引数の配列を指定します。

--- load_file(file_name) -> object
#@todo

与えられたファイル名のファイルが存在すれば YAML ファイルとしてロードします。

@param file_name YAML 形式で記述された設定ファイル名を指定します。

--- path -> String
#@todo

Gem を探索するパスを返します。

--- path=(path)
#@todo

Gem を探索するパスをセットします。

--- really_verbose -> bool
#@todo

このメソッドの返り値が真の場合は verbose モードよりも多くの情報を表示します。

--- update_sources -> bool
#@todo

真の場合は [[c:Gem::SourceInfoCache]] を毎回更新します。
そうでない場合は、キャッシュがあればキャッシュの情報を使用します。

--- update_sources=(update_sources)
#@todo

@param update_sources 真を指定すると毎回 [[c:Gem::SourceInfoCache]] を更新します。

--- verbose -> bool | Symbol
#@todo

ログの出力レベルを返します。

@see [[m:Gem::ConfigFile#verbose=]]

--- verbose=(verbose_level)
#@todo

ログの出力レベルをセットします。

以下の出力レベルを設定することができます。

: false
  何も出力しません。
: true
  通常のログを出力します。
: :loud
  より多くのログを出力します。

@param verbose_level 真偽値またはシンボルを指定します。

--- write
#@todo

自身を読み込んだ設定ファイルを書き換えます。

== Protected Instance Methods

--- hash -> Hash
#@todo



== Constants

--- DEFAULT_BACKTRACE -> false
#@todo

デフォルトでバックトレースが表示されるかどうか

--- DEFAULT_BENCHMARK -> false
#@todo

--- DEFAULT_BULK_THRESHOLD -> 1000
#@todo

--- DEFAULT_UPDATE_SOURCES -> true
#@todo

--- DEFAULT_VERBOSITY -> true
#@todo

--- OPERATING_SYSTEM_DEFAULTS -> {}
#@todo

Ruby をパッケージングしている人がデフォルトの設定値をセットするために使用します。

使用するファイルは rubygems/defaults/operating_system.rb です。

--- PLATFORM_DEFAULTS -> {}
#@todo

Ruby の実装者がデフォルトの設定値をセットするために使用します。

使用するファイルは rubygems/defaults/#{RUBY_ENGINE}.rb です。

--- SYSTEM_WIDE_CONFIG_FILE -> String
#@todo

