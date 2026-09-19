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

### def Gem.cache_home -> String

ユーザーのキャッシュディレクトリの標準的な場所を返します。

環境変数 `XDG_CACHE_HOME` が設定されていればその値を、設定されていなければ [m:Gem.user_home] の下の `.cache` を返します。

- **return** -- ユーザーのキャッシュディレクトリの標準的な場所です。

### def Gem.config_file -> String
{: since="1.9.2"}

ユーザーの `.gemrc` ファイルの標準的な場所を返します。

[m:Gem.user_home] の直下に `.gemrc` があればそのパスを、無ければ [m:Gem.config_home] の下の `gem/gemrc` を返します。

- **return** -- ユーザーの `.gemrc` ファイルの標準的な場所です。

### def Gem.config_home -> String

ユーザーの設定ディレクトリの標準的な場所を返します。

環境変数 `XDG_CONFIG_HOME` が設定されていればその値を、設定されていなければ [m:Gem.user_home] の下の `.config` を返します。

- **return** -- ユーザーの設定ディレクトリの標準的な場所です。

### def Gem.data_home -> String

ユーザーのデータディレクトリの標準的な場所を返します。

環境変数 `XDG_DATA_HOME` が設定されていればその値を、設定されていなければ [m:Gem.user_home] の下の `.local/share` を返します。

- **return** -- ユーザーのデータディレクトリの標準的な場所です。

### def Gem.default_specifications_dir -> String
{: since="2.7.0"}

default gem(Ruby にあらかじめ組み込まれている Gem)の gemspec ファイルが置かれるディレクトリを返します。

[m:Gem.default_dir] の下の `specifications/default` です。

- **return** -- default gem の gemspec ファイルが置かれるディレクトリです。

#%since 3.2
### def Gem.state_home -> String

ユーザーの状態ファイル用ディレクトリの標準的な場所を返します。

環境変数 `XDG_STATE_HOME` が設定されていればその値を、設定されていなければ [m:Gem.user_home] の下の `.local/state` を返します。

- **return** -- ユーザーの状態ファイル用ディレクトリの標準的な場所です。

#%end

### def Gem.user_home -> String
{: since="1.9.2"}

ユーザーのホームディレクトリを返します。

内部で `Dir.home` を使って求めます。何らかの理由で求められなかった場合、Windows であれば `HOMEDRIVE`(または `SystemDrive`)が指すドライブのルートを、それ以外であれば `/` を返します。

- **return** -- ユーザーのホームディレクトリです。

