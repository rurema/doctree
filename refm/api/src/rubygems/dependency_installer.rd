require rubygems
require rubygems/dependency_list
require rubygems/installer
require rubygems/spec_fetcher
require rubygems/user_interaction

ある Gem が依存している Gem を同時にインストールするためのライブラリです。

= class Gem::DependencyInstaller
include Gem::UserInteraction

ある Gem が依存している Gem を同時にインストールするためのクラスです。

== Public Instance Methods

--- find_gems_with_sources(dep) -> Array

与えられた条件にマッチする [[c:Gem::Specification]] のインスタンスと URI のペアのリストを
返します。

Gem はローカル (Dir.pwd) とリモート (Gem.sources) の両方から検索します。
結果は、バージョンの新しい順が先にきます。また、ローカルの Gem も先にきます。

@param dep [[c:Gem::Dependency]] のインスタンスを指定します。

--- find_spec_by_name_and_version(gem_name, version = Gem::Requirement.default) -> Array

与えられた Gem の名前とバージョンに関する条件にマッチする [[c:Gem::Specification]] と
それの存在する URI を含む配列を返します。

@param gem_name Gem の名前を指定します。

@param version Gem が満たすバージョンに関する条件を指定します。

--- gather_dependencies -> Array

依存関係を無視するように指定されていない限り、インストールするように指定された
Gem が依存している Gem の情報を集めて返します。

--- gems_to_install -> Array

依存関係によりインストールされる予定の Gem のリストを返します。

--- install(dep_or_name, version = Gem::Requirement.default) -> Array

指定された Gem とその依存する Gem を全てインストールします。

@param dep_or_name Gem の名前か [[c:Gem::Dependency]] のインスタンスを指定します。

@param version バージョンに関する条件を指定します。

@return このメソッドでインストールした Gem のリストを返します。

--- installed_gems -> Array

[[m:Gem::DependencyInstaller#install]] でインストールされた Gem のリストを返します。

== Singleton Methods

--- new(options = {}) -> Gem::DependencyInstaller

自身を初期化します。

オプションとして以下のものを利用できます。

: :cache_dir
  *.gem ファイルを保存するディレクトリを指定します。
: :domain
  :local (カレントディレクトリのみ検索します), :remote ([[m:Gem.sources]] を検索します),
  :both (:local, :remote の両方を検索します) のいずれかを指定可能です。
: :env_shebang
  [[m:Gem::Installer.new]] を参照してください。
: :force
  バージョンチェックとセキュリティポリシーのチェックを行わずにインストールを実行します。
  ただし、署名付きの Gem のみをインストールするポリシーが指定されている場合は上記のチェックを
  実行します。
: :format_executable
  [[m:Gem::Installer.new]] を参照してください。
: :ignore_dependencies
  依存している Gem をインストールしません。
: :install_dir
   Gem をインストールするディレクトリです。
: :security_policy
  セキュリティポリシーを指定します。
: :user_install
  false を指定するとユーザのホームディレクトリにインストールしません。
  nil を指定するとユーザのホームディレクトリにインストールしようとしますが、
  警告を表示します。
: :wrappers
  真を指定するとラッパーをインストールします。
  偽を指定すると、シンボリックリンクをインストールします。

@see [[m:Gem::Installer.new]], [[m:Gem::Installer#install]], [[c:Gem::Security]]

== Constants

--- DEFAULT_OPTIONS -> Hash

自身を初期化する際に使用するデフォルトのオプションです。

    :env_shebang         => false,
    :domain              => :both, # HACK dup
    :force               => false,
    :format_executable   => false, # HACK dup
    :ignore_dependencies => false,
    :security_policy     => nil, # HACK NoSecurity requires OpenSSL.  AlmostNo? Low?
    :wrappers            => true
