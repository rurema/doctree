---
type: library
require:
  - rubygems
---
設定ファイルに書かれている gem コマンドのオプションをオブジェクトに保存するためのライブラリです。

# class Gem::ConfigFile

設定ファイルに書かれている gem コマンドのオプションをオブジェクトに保存するためのクラスです。

このクラスのインスタンスはハッシュのように振る舞います。

## Public Instance Methods

### def [](key) -> object

引数で与えられたキーに対応する設定情報を返します。

- **param** `key` -- 設定情報を取得するために使用するキーを指定します。

### def []=(key, value)

引数で与えられたキーに対応する設定情報を自身に保存します。

- **param** `key` -- 設定情報をセットするために使用するキーを指定します。

- **param** `value` -- 設定情報の値を指定します。

### def api_keys -> {Symbol => String}
{: since="1.9.3"}

認証情報ファイルに保存されている API キーのハッシュを返します。

キーは rubygems.org の場合は `:rubygems`、それ以外の場合はホスト名のシンボルで、値は API キーです。
認証情報ファイル([m:Gem::ConfigFile#credentials_path])が無いときは、設定ファイルから読み込んだハッシュをそのまま返します。
#%since 4.1
`credential_store` 設定で OS の認証情報ストアに保存したキーは含まれません。
#%end

- **SEE** [m:Gem::ConfigFile#credentials_path], [m:Gem::ConfigFile#set_api_key]

### def args -> Array

設定ファイルオブジェクトに与えられたコマンドライン引数のリストを返します。

### def backtrace -> bool

エラー発生時にバックトレースを出力するかどうかを返します。

真の場合はバックトレースを出力します。そうでない場合はバックトレースを出力しません。

### def backtrace=(backtrace)

エラー発生時にバックトレースを出力するかどうか設定します。

- **param** `backtrace` -- 真を指定するとエラー発生時にバックトレースを出力するようになります。

### def bulk_threshold -> Integer

一括ダウンロードの閾値を返します。
インストールしていない Gem がこの数値を越えるとき一括ダウンロードを行います。

### def bulk_threshold=(bulk_threshold)

一括ダウンロードの閾値を設定します。

- **param** `bulk_threshold` -- 数値を指定します。

### def cert_expiration_length_days -> Integer
{: since="2.6.0"}

`gem cert` で証明書を作るときの有効期間(日数)を返します。

デフォルトは 365 日([m:Gem::ConfigFile::DEFAULT_CERT_EXPIRATION_LENGTH_DAYS])です。

```ruby title="例"
Gem.configuration.cert_expiration_length_days # => 365
```

- **SEE** [m:Gem::ConfigFile#cert_expiration_length_days=]

### def cert_expiration_length_days=(days)
{: since="2.6.0"}

`gem cert` で証明書を作るときの有効期間(日数)を設定します。

- **param** `days` -- 日数を整数で指定します。

- **SEE** [m:Gem::ConfigFile#cert_expiration_length_days]

### def concurrent_downloads -> Integer
{: since="2.6.0"}

同時にダウンロードする gem の数を返します。

デフォルトは 8([m:Gem::ConfigFile::DEFAULT_CONCURRENT_DOWNLOADS])です。

```ruby title="例"
Gem.configuration.concurrent_downloads # => 8
```

- **SEE** [m:Gem::ConfigFile#concurrent_downloads=]

### def concurrent_downloads=(count)
{: since="2.6.0"}

同時にダウンロードする gem の数を設定します。

- **param** `count` -- gem の数を整数で指定します。

- **SEE** [m:Gem::ConfigFile#concurrent_downloads]

### def config_file_name -> String

設定ファイルの名前を返します。

#%since 4.1
### def cooldown -> Integer

新しく公開された gem の版を、インストールや更新の対象にするまで待つ日数(cooldown)を返します。

0 の場合は待ちません。デフォルトは 0([m:Gem::ConfigFile::DEFAULT_COOLDOWN])です。
Bundler の `cooldown` 設定も読み込まれ、この設定との長い方が使われます。
非負の整数として読めない値は、警告が出力されたうえで無視されます。

- **SEE** [m:Gem::ConfigFile#cooldown=]

### def cooldown=(days)

新しく公開された gem の版を、インストールや更新の対象にするまで待つ日数(cooldown)を設定します。

- **param** `days` -- 日数を非負の整数で指定します。0 を指定すると待ちません。

- **SEE** [m:Gem::ConfigFile#cooldown]

#%end
### def credentials_path -> String
{: since="1.9.2"}

API キーを保存する認証情報ファイルのパスを返します。

[m:Gem.user_home] の下の `.gem/credentials` があればそのパスを、無ければ [m:Gem.data_home] の下の `gem/credentials` を返します。

- **SEE** [m:Gem::ConfigFile#api_keys]

### def disable_default_gem_server -> bool | nil
{: since="2.0.0"}

`gem push` でホストの明示を必須にするかどうかを返します。

真の場合は、`gem push` でホストを明示する必要があります。設定ファイルの `disable_default_gem_server` キーの値で、設定が無い場合は nil を返します。

- **SEE** [m:Gem::ConfigFile#disable_default_gem_server=]

### def disable_default_gem_server=(flag)
{: since="2.0.0"}

`gem push` でホストの明示を必須にするかどうかを設定します。

- **param** `flag` -- 真を指定すると、`gem push` でホストを明示する必要があります。

- **SEE** [m:Gem::ConfigFile#disable_default_gem_server]

### def each{|key, value| ... } -> Hash

設定ファイルの各項目のキーと値をブロック引数として与えられたブロックを評価します。

#%since 4.1
### def global_gem_cache -> bool

取得した `.gem` ファイルを、複数の Ruby で共有するグローバルキャッシュに置くかどうかを返します。

真の場合は `~/.cache/gem/gems`(環境変数 `XDG_CACHE_HOME` があればその下)に置きます。
デフォルトは偽([m:Gem::ConfigFile::DEFAULT_GLOBAL_GEM_CACHE])ですが、環境変数 `RUBYGEMS_GLOBAL_GEM_CACHE` が `true` の場合は真になります。

- **SEE** [m:Gem::ConfigFile#global_gem_cache=]

### def global_gem_cache=(flag)

取得した `.gem` ファイルを、複数の Ruby で共有するグローバルキャッシュに置くかどうかを設定します。

- **param** `flag` -- 真を指定するとグローバルキャッシュに置きます。

- **SEE** [m:Gem::ConfigFile#global_gem_cache]

#%end
### def handle_arguments(arg_list)

コマンドに渡された引数を処理します。

- **param** `arg_list` -- コマンドに渡された引数の配列を指定します。

### def home -> String | nil
{: since="1.9.1"}

gem をインストールするディレクトリを返します。

設定ファイルの `gemhome` キーの値で、設定が無い場合は nil を返します。非推奨です。

- **SEE** [m:Gem::ConfigFile#home=]

### def home=(dir)
{: since="1.9.1"}

gem をインストールするディレクトリを設定します。非推奨です。

- **param** `dir` -- ディレクトリのパスを指定します。

- **SEE** [m:Gem::ConfigFile#home]

#%since 3.4
### def install_extension_in_lib -> bool

拡張ライブラリを、拡張ライブラリ用のディレクトリだけでなく `lib` にもインストールするかどうかを返します。

デフォルトは真([m:Gem::ConfigFile::DEFAULT_INSTALL_EXTENSION_IN_LIB])です。

- **SEE** [m:Gem::ConfigFile#install_extension_in_lib=]

### def install_extension_in_lib=(flag)

拡張ライブラリを、拡張ライブラリ用のディレクトリだけでなく `lib` にもインストールするかどうかを設定します。

- **param** `flag` -- 真を指定すると `lib` にもインストールします。

- **SEE** [m:Gem::ConfigFile#install_extension_in_lib]

#%end
#%since 3.1
### def ipv4_fallback_enabled -> bool

IPv6 で接続できない場合や接続が遅い場合に、IPv4 にフォールバックするかどうかを返します。実験的な機能です。

デフォルトは偽([m:Gem::ConfigFile::DEFAULT_IPV4_FALLBACK_ENABLED])ですが、環境変数 `IPV4_FALLBACK_ENABLED` が `true` の場合は真になります。

- **SEE** [m:Gem::ConfigFile#ipv4_fallback_enabled=]

### def ipv4_fallback_enabled=(flag)

IPv6 で接続できない場合や接続が遅い場合に、IPv4 にフォールバックするかどうかを設定します。

- **param** `flag` -- 真を指定すると IPv4 にフォールバックします。

- **SEE** [m:Gem::ConfigFile#ipv4_fallback_enabled]

#%end
### def load_file(file_name) -> object

与えられたファイル名のファイルが存在すれば YAML ファイルとしてロードします。

- **param** `file_name` -- YAML 形式で記述された設定ファイル名を指定します。

### def path -> String

Gem を探索するパスを返します。

### def path=(path)

Gem を探索するパスをセットします。

### def really_verbose -> bool

このメソッドの返り値が真の場合は verbose モードよりも多くの情報を表示します。

### def rubygems_api_key -> String | nil
{: since="1.9.2"}

rubygems.org の API キーを返します。

未設定の場合は nil を返します。
#%since 4.1
`credential_store` 設定で OS の認証情報ストアに保存したキーがあれば、そちらを返します。
#%end

- **SEE** [m:Gem::ConfigFile#rubygems_api_key=]

### def rubygems_api_key=(api_key)
{: since="1.9.2"}

rubygems.org の API キーを設定し、認証情報ファイルに書き込みます。

- **param** `api_key` -- API キーを文字列で指定します。

- **SEE** [m:Gem::ConfigFile#rubygems_api_key], [m:Gem::ConfigFile#set_api_key]

### def set_api_key(host, api_key) -> ()
{: since="2.4.0"}

`host` の API キーを認証情報ファイルに書き込みます。

認証情報ファイルは、パーミッション 0600 で作られます。
#%since 4.1
`credential_store` 設定が有効なときは、認証情報ファイルではなく OS の認証情報ストアに保存します。
#%end

- **param** `host` -- ホスト名をシンボルまたは文字列で指定します。

- **param** `api_key` -- API キーを文字列で指定します。

- **SEE** [m:Gem::ConfigFile#api_keys], [m:Gem::ConfigFile#credentials_path]

### def sources -> [String] | nil
{: since="2.4.0"}

gem を探すソースの URL の配列を返します。

設定ファイルの `sources` キーの値で、設定が無い場合は nil を返します。

- **SEE** [m:Gem?.sources], [m:Gem::ConfigFile#sources=]

### def sources=(sources)
{: since="2.4.0"}

gem を探すソースの URL の配列を設定します。

- **param** `sources` -- URL の文字列の配列を指定します。

- **SEE** [m:Gem::ConfigFile#sources]

### def ssl_ca_cert -> String | nil
{: since="2.0.0"}

HTTPS 接続に使う CA 証明書のファイルまたはディレクトリのパスを返します。

設定ファイルの `ssl_ca_cert` キーの値で、設定が無い場合は nil を返します。

- **SEE** [m:Gem::ConfigFile#ssl_ca_cert=]

### def ssl_ca_cert=(path)
{: since="2.2.0"}

HTTPS 接続に使う CA 証明書のファイルまたはディレクトリのパスを設定します。

- **param** `path` -- ファイルまたはディレクトリのパスを指定します。

- **SEE** [m:Gem::ConfigFile#ssl_ca_cert]

### def ssl_client_cert -> String | nil
{: since="2.1.0"}

クライアント認証付きの HTTPS 接続に使うクライアント証明書のファイルまたはディレクトリのパスを返します。

設定ファイルの `ssl_client_cert` キーの値で、設定が無い場合は nil を返します。

### def ssl_verify_mode -> Integer | nil
{: since="2.0.0"}

HTTPS 接続で使う OpenSSL の検証モードを返します。

設定ファイルの `ssl_verify_mode` キーの値(`OpenSSL::SSL::VERIFY_PEER` などの整数)で、設定が無い場合は nil を返します。

#%since 4.1
### def unset_api_key! -> [bool, bool]
{: since="2.5.0"}
#%else
### def unset_api_key! -> Integer | false
{: since="2.5.0"}
#%end

認証情報ファイルを削除して、すべての API キーを消します。

#%since 4.1
認証情報ストアに保存されているキーも消します。

- **return** -- 認証情報ストアのキーを消せたかどうかと、認証情報ファイルを消せたかどうかの 2 要素の配列を返します。
#%else
- **return** -- 認証情報ファイルが無ければ偽を返します。あれば削除して、削除したファイルの数(1)を返します。
#%end

- **SEE** [m:Gem::ConfigFile#credentials_path]

### def update_sources -> bool

真の場合は `Gem::SourceInfoCache` を毎回更新します。
そうでない場合は、キャッシュがあればキャッシュの情報を使用します。

### def update_sources=(update_sources)

`Gem::SourceInfoCache` を毎回更新するかどうか設定します。

- **param** `update_sources` -- 真を指定すると毎回 `Gem::SourceInfoCache` を更新します。

#%since 4.1
### def use_psych -> bool

YAML の読み書きに、RubyGems 内蔵の pure Ruby のシリアライザではなく Psych(C 拡張)を使うかどうかを返します。

デフォルトは偽([m:Gem::ConfigFile::DEFAULT_USE_PSYCH])ですが、環境変数 `RUBYGEMS_USE_PSYCH` が `true` の場合は真になります。

- **SEE** [m:Gem::ConfigFile#use_psych=]

### def use_psych=(flag)

YAML の読み書きに、RubyGems 内蔵の pure Ruby のシリアライザではなく Psych(C 拡張)を使うかどうかを設定します。

- **param** `flag` -- 真を指定すると Psych を使います。

- **SEE** [m:Gem::ConfigFile#use_psych]

#%end
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
#%# -> discard

自身を読み込んだ設定ファイルを書き換えます。

## Protected Instance Methods

### def hash -> Hash

設定ファイルの各項目のキーと値を要素として持つハッシュです。

## Constants

#%since 3.2
### const DEFAULT_BACKTRACE -> true
#%else
### const DEFAULT_BACKTRACE -> false
#%end

バックトレースが表示されるかどうかのデフォルト値です。

### const DEFAULT_BULK_THRESHOLD -> 1000

一括ダウンロードをするかどうかのデフォルト値です。

### const DEFAULT_CERT_EXPIRATION_LENGTH_DAYS -> 365
{: since="2.6.0"}

[m:Gem::ConfigFile#cert_expiration_length_days] のデフォルト値です。

### const DEFAULT_CONCURRENT_DOWNLOADS -> 8
{: since="2.6.0"}

[m:Gem::ConfigFile#concurrent_downloads] のデフォルト値です。

#%since 4.1
### const DEFAULT_COOLDOWN -> 0

[m:Gem::ConfigFile#cooldown] のデフォルト値です。

### const DEFAULT_GLOBAL_GEM_CACHE -> false

[m:Gem::ConfigFile#global_gem_cache] のデフォルト値です。

#%end
#%since 3.4
### const DEFAULT_INSTALL_EXTENSION_IN_LIB -> true

[m:Gem::ConfigFile#install_extension_in_lib] のデフォルト値です。

#%end
#%since 3.1
### const DEFAULT_IPV4_FALLBACK_ENABLED -> false

[m:Gem::ConfigFile#ipv4_fallback_enabled] のデフォルト値です。

#%end
### const DEFAULT_UPDATE_SOURCES -> true

毎回 `Gem::SourceInfoCache` を更新するかどうかのデフォルト値です。

#%since 4.1
### const DEFAULT_USE_PSYCH -> false

[m:Gem::ConfigFile#use_psych] のデフォルト値です。

#%end
### const DEFAULT_VERBOSITY -> true

ログレベルのデフォルト値です。

### const OPERATING_SYSTEM_DEFAULTS -> {}

Ruby をパッケージングしている人がデフォルトの設定値をセットするために使用します。

使用するファイルは rubygems/defaults/operating_system.rb です。

### const PLATFORM_DEFAULTS -> {}

Ruby の実装者がデフォルトの設定値をセットするために使用します。

使用するファイルは rubygems/defaults/#{RUBY_ENGINE}.rb です。

### const SYSTEM_WIDE_CONFIG_FILE -> String

システム全体の設定ファイルのパスです。
