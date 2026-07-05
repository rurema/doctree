---
type: library
require:
  - rubygems
---
設定ファイルに書かれている gem コマンドのオプションを
オブジェクトに保存するためのライブラリです。

# class Gem::ConfigFile

設定ファイルに書かれている gem コマンドのオプションを
オブジェクトに保存するためのクラスです。

このクラスのインスタンスはハッシュのように振る舞います。

## Public Instance Methods

### def [](key) -> object

引数で与えられたキーに対応する設定情報を返します。

- **param** `key` -- 設定情報を取得するために使用するキーを指定します。

### def []=(key, value)

引数で与えられたキーに対応する設定情報を自身に保存します。

- **param** `key` -- 設定情報をセットするために使用するキーを指定します。

- **param** `value` -- 設定情報の値を指定します。

### def args -> Array

設定ファイルオブジェクトに与えられたコマンドライン引数のリストを返します。

### def backtrace -> bool

エラー発生時にバックトレースを出力するかどうかを返します。

真の場合はバックトレースを出力します。そうでない場合はバックトレースを出力しません。

### def backtrace=(backtrace)

エラー発生時にバックトレースを出力するかどうか設定します。

- **param** `backtrace` -- 真を指定するとエラー発生時にバックトレースを出力するようになります。

### def benchmark -> bool

真の場合はベンチマークを実行します。
そうでない場合は、ベンチマークを実行しません。

### def benchmark=(benchmark)

ベンチマークを実行するかどうか設定します。

- **param** `benchmark` -- 真を指定するとベンチマークを実行するようになります。

### def bulk_threshold -> Integer

一括ダウンロードの閾値を返します。
インストールしていない Gem がこの数値を越えるとき一括ダウンロードを行います。

### def bulk_threshold=(bulk_threshold)

一括ダウンロードの閾値を設定します。

- **param** `bulk_threshold` -- 数値を指定します。

### def config_file_name -> String

設定ファイルの名前を返します。

### def each{|key, value| ... } -> Hash

設定ファイルの各項目のキーと値をブロック引数として与えられたブロックを評価します。

### def handle_arguments(arg_list)

コマンドに渡された引数を処理します。

- **param** `arg_list` -- コマンドに渡された引数の配列を指定します。

### def load_file(file_name) -> object

与えられたファイル名のファイルが存在すれば YAML ファイルとしてロードします。

- **param** `file_name` -- YAML 形式で記述された設定ファイル名を指定します。

### def path -> String

Gem を探索するパスを返します。

### def path=(path)

Gem を探索するパスをセットします。

### def really_verbose -> bool

このメソッドの返り値が真の場合は verbose モードよりも多くの情報を表示します。

### def update_sources -> bool

真の場合は [c:Gem::SourceInfoCache] を毎回更新します。
そうでない場合は、キャッシュがあればキャッシュの情報を使用します。

### def update_sources=(update_sources)

[c:Gem::SourceInfoCache] を毎回更新するかどうか設定します。

- **param** `update_sources` -- 真を指定すると毎回 [c:Gem::SourceInfoCache] を更新します。

### def verbose -> bool | Symbol

ログの出力レベルを返します。

- **SEE** [m:Gem::ConfigFile#verbose=]

### def verbose=(verbose_level)

ログの出力レベルをセットします。

以下の出力レベルを設定できます。

- **`false`**:
  何も出力しません。
- **`true`**:
  通常のログを出力します。
- **`:loud`**:
  より多くのログを出力します。

- **param** `verbose_level` -- 真偽値またはシンボルを指定します。

### def write
#@# -> discard

自身を読み込んだ設定ファイルを書き換えます。

## Protected Instance Methods

### def hash -> Hash

設定ファイルの各項目のキーと値を要素として持つハッシュです。

## Constants

### const DEFAULT_BACKTRACE -> false

バックトレースが表示されるかどうかのデフォルト値です。

### const DEFAULT_BENCHMARK -> false

ベンチマークを実行するかどうかのデフォルト値です。

### const DEFAULT_BULK_THRESHOLD -> 1000

一括ダウンロードをするかどうかのデフォルト値です。

### const DEFAULT_UPDATE_SOURCES -> true

毎回 [c:Gem::SourceInfoCache] を更新するかどうかのデフォルト値です。

### const DEFAULT_VERBOSITY -> true

ログレベルのデフォルト値です。

### def OPERATING_SYSTEM_DEFAULTS -> {}

Ruby をパッケージングしている人がデフォルトの設定値をセットするために使用します。

使用するファイルは rubygems/defaults/operating_system.rb です。

### def PLATFORM_DEFAULTS -> {}

Ruby の実装者がデフォルトの設定値をセットするために使用します。

使用するファイルは rubygems/defaults/#{RUBY_ENGINE}.rb です。

### const SYSTEM_WIDE_CONFIG_FILE -> String

システム全体の設定ファイルのパスです。
