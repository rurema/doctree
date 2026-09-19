---
type: library
require:
  - rubygems/defaults
  - rubygems/exceptions
  - rubygems/version
  - rubygems/requirement
  - rubygems/dependency
  - rubygems/gem_path_searcher
  - rubygems/source_index
  - rubygems/platform
  - rubygems/builder
sublibrary:
  - rubygems/gem_runner
---
RubyGems を扱うためのクラスやモジュールが定義されているライブラリです。

このリファレンスでは、利用者向けの API([c:Gem] モジュールの設定・検索系のメソッド、[c:Gem::Specification] の gemspec 属性と検索系のメソッド、
[c:Gem::Version]・[c:Gem::Requirement]・[c:Gem::Dependency]・[c:Gem::Platform])と例外クラスを扱います。
`Gem::Installer`・`Gem::Indexer`・`Gem::RemoteFetcher`・`Gem::Security`・`Gem::Commands::*` などの内部クラスや、
`Gem::Net::HTTP` のように RubyGems が同梱している他のライブラリのコピー(vendored)は、
ページがあるものも含めて RubyGems の版に追随した記述はしていません。完全な API については公式ドキュメントを参照してください。

- プロジェクトページ: <https://github.com/ruby/rubygems>
- リファレンス: <https://docs.ruby-lang.org/en/master/Gem.html>

#%# _builtin/ 以下に移動する予定だったが形式が違いすぎるため保留

### gem コマンドの使い方 {#gem_command}

```console
$ gem help
  
  RubyGems は Ruby のための高機能なパッケージ管理ツールです。
  これはより多くの情報へのポインタを含んでいる基本的なヘルプメッセージです。
  
    使用方法:
      gem -h/--help
      gem -v/--version
      gem command [arguments...] [options...]
  
    例:
      gem install rake
      gem list --local
      gem build package.gemspec
      gem help install
  
    さらにヘルプ:
      gem help commands            全ての 'gem' コマンドをリストアップします
      gem help examples            いくつかの使用方法の例を表示します
      gem help platforms           プラットフォームに関する情報を表示します
      gem help <COMMAND>           COMMAND に関するヘルプを表示します
                                     (e.g. 'gem help install')
    より詳しい情報:
      https://rubygems.org
```

#### Gem パッケージをインストールする

例えば rak ( <https://rubygems.org/gems/rak> ) をインストールするには、以下のいずれかを実行します。

```console
$ gem install rak
$ sudo gem install rak
```

特定のバージョンの Gem パッケージをインストールするには以下のようにします。

```console
$ gem install rak --version 0.8.1    # バージョン 0.8.1 をインストールする
$ gem install rak --version '>= 0.5' # バージョン 0.5 以上のものをインストールする
```

Proxy サーバ経由で Gem パッケージをインストールするには以下のようにします。

```console
$ gem install rak -p http://user:password@proxy.example.com/
```

#### Gem パッケージをアンインストールする

例えば rak をアンインストールするには、以下のいずれかを実行します。

```console
$ gem uninstall rak
$ sudo gem uninstall rak
```

特定のバージョンの Gem パッケージをアンインストールするには以下のようにします。

```console
$ gem uninstall rak --version 0.8.1
```

#### Gem パッケージを更新する

インストールされている Gem パッケージを更新するには以下のようにします。

```console
$ gem update
$ sudo gem update
```

特定の Gem パッケージを更新するには以下のようにします。

```console
$ gem update rak
```

#### Gem パッケージを探す

パッケージ名から Gem パッケージを探すことができます。
'active' という文字列をパッケージ名に含むパッケージを探すには以下のようにします。

```console
$ gem search active       # デフォルトではリポジトリから検索します
$ gem search active -a    # -a オプションをつけると全てのバージョンを表示します
```

より詳細な条件で検索したい場合は query を使用してください。

```console
$ gem query -n ^rails$ -r # rails にちょうど一致するものを検索する
$ gem query -n ^rails -r  # rails で始まるものを検索する
```

パッケージの詳細からキーワード検索することはできません。

#### Gem パッケージを作成する

作成した gemspec ファイルを元にして Gem パッケージを簡単に作成できます。

```console
$ gem build <gemspec filename>
```

最小の gemspec は以下のようになります。ビルドするために必要な最小の gemspec なので出来上がるのはメタデータのみを含む Gem パッケージです。また、いくつかの警告が表示されます。

```ruby title="gemspec"
Gem::Specification.new do |s|
  s.name    = 'hello'
  s.version = '0.0.0'
  s.summary = 'hello summary'
end
```

実用的なライブラリを作成するための gemspec の例を示します。
警告メッセージが出力されないようにいくつか設定を追加しています。

```ruby title="gemspec"
Gem::Specification.new do |s|
  s.name              = 'hello'
  s.version           = '0.0.0'
  s.summary           = 'hello summary'
  s.files             = ['lib/hello.rb']
  s.authors           = ['Hello Author']
  s.email             = 'hello_author@example.com'
  s.homepage          = 'http://example.com/hello/'
  s.description       = 'hello description'
end
```

- **`name`**:
  この Gem の名前を指定します。
- **`version`**:
  この Gem のバージョンを指定します。
- **`summary`**:
  この Gem の短い説明を指定します。
- **`files`**:
  この Gem に含むファイルのリストを指定します。
- **`authors`**:
  この Gem の作者のリストを指定します。
- **`email`**:
  この Gem の作者の連絡先メールアドレスを指定します。
- **`homepage`**:
  この Gem のウェブサイトの URI を指定します。
- **`description`**:
  この Gem の長い説明を指定します。

実行可能なファイル (コマンド) を含む場合の gemspec は以下のようになります。

```ruby title="gemspec"
Gem::Specification.new do |s|
  s.name              = 'hello'
  s.version           = '0.0.0'
  s.summary           = 'hello summary'
  s.files             = ['bin/hello', 'lib/hello.rb']
  s.executables       = ['hello']
  s.authors           = ['Hello Author']
  s.email             = 'hello@example.com'
  s.homepage          = 'http://example.com/hello'
  s.description       = 'hello description'
end
```

ライブラリの例に加えて executables を追加しています。

また、以下のように Rakefile にタスクを追加することもできます。

```ruby title="gemspec"
require 'rake/gempackagetask'

PKG_FILES = FileList[
  'lib/hello.rb',
  'spec/*'
]
spec = Gem::Specification.new do |s|
  s.name             = 'hello'
  s.version          = '0.0.1'
  s.author           = 'Hello Author'
  s.email            = 'hello@example.com'
  s.homepage         = 'http://example.com/hello'
  s.platform         = Gem::Platform::RUBY
  s.summary          = 'Hello Gem'
  s.files            = PKG_FILES.to_a
  s.require_path     = 'lib'
  s.has_rdoc         = false
  s.extra_rdoc_files = ['README']
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end
```

- **SEE** [c:Gem::Specification], [lib:rake]

### gem コマンドの設定

  - GEM_HOME Gem のホームディレクトリ
  - GEM_PATH Gem のサーチパス
  - $HOME/.gemrc

環境変数 GEM_HOME, GEM_PATH を設定する事によって Gem コマンドの動作を変更できます。
また、ホームディレクトリに .gemrc という YAML フォーマットで書かれたファイルを置くことでも動作を変更できます。

```yaml title="例"
--- 
:backtrace: false
:benchmark: false
:bulk_threshold: 1000
:sources:
- https://rubygems.org
:update_sources: true
:verbose: true
gemhome: /home/hoge/.gems
gempath: 
- /usr/local/lib/ruby/gems/1.9
gem: --no-rdoc --no-ri
```

### 参考

- **Rubyist Magazine - シリーズ パッケージマネジメント 【第 1 回】 RubyGems (1)**:
  <https://magazine.rubyist.net/articles/0006/0006-PackageManagement.html>
- **Rubyist Magazine - シリーズ パッケージマネジメント 【第 2 回】 RubyGems (2)**:
  <https://magazine.rubyist.net/articles/0010/0010-PackageManagement.html>

# reopen Kernel

## Private Instance Methods

### def gem(gem_name, *version_requirements) -> bool

[m:$LOAD_PATH] に Ruby Gem を追加します。

指定された Gem をロードする前にその Gem が必要とする Gem をロードします。
バージョン情報を省略した場合は、最も高いバージョンの Gem をロードします。
指定された Gem やその Gem が必要とする Gem が見つからなかった場合は
[c:Gem::LoadError] が発生します。

バージョンの指定方法に関しては [c:Gem::Version] を参照してください。

rubygems ライブラリがライブラリバージョンの衝突を検出しない限り、
gem メソッドは全ての require メソッドよりも前に実行されます。

### 環境変数 GEM_SKIP

特定の Gem をロードしないようにするために環境変数 GEM_SKIP を定義できます。
特定の Gem がまだインストールされていないという状況を試すために使用できます。

```console title="例"
GEM_SKIP=libA:libB ruby-I../libA -I../libB ./mycode.rb
```

- **param** `gem` -- Gem の名前の文字列か、Gem の依存関係を [c:Gem::Dependency] のインスタンスで指定します。

- **param** `version_requirements` -- 必要とする gem のバージョンを指定します。

- **return** -- Gem がロードできた場合は true を返します。ロードできなかった場合は false を返します。

- **raise** `Gem::LoadError` -- 指定された Gem やその Gem が必要とする Gem が見つからなかった場合に発生します。
                      ただし、環境変数 GEM_SKIP に指定されている Gem に関してはこの例外は発生しません。

- **SEE** [c:Gem::Version]

# module Gem

## Module Functions

### module_function def clear_paths -> nil

[m:Gem?.dir], [m:Gem?.path] の値をリセットします。

次に [m:Gem?.dir], [m:Gem?.path] が呼ばれた時は、値を最初から計算します。
このメソッドは主にユニットテストの独立性を提供するために使用します。

### module_function def marshal_version -> String

[c:Marshal] のバージョンを表す文字列を返します。

### module_function def prefix -> String

このライブラリがインストールされているディレクトリの親ディレクトリを返します。

### module_function def win_platform? -> bool

Windows プラットフォームであれば真を返します。そうでなければ偽を返します。

- **SEE** [m:Object::RUBY_PLATFORM]

### module_function def dir -> String

Gem のインストールされているディレクトリを返します。

### module_function def ensure_gem_subdirectories

Gem をインストールするために必要なサブディレクトリを適切に作成します。

ディレクトリを作成する権限が無い場合もこのメソッドからは例外は発生しません。

### module_function def path -> Array

Gem を検索するパスの配列を返します。

### module_function def ruby -> String

実行中のRubyインタプリタのパスを返します。

### module_function def bin_path(name, exec_name = nil, *requirements) -> String
{: since="1.9.2"}

Gem `name` に含まれる実行可能ファイル `exec_name` のフルパスを返します。

`exec_name` を省略した場合は例外が発生します。`requirements` で特定のバージョンを指定できます。Gem を有効化(activate)する副作用はありません。

- **param** `name` -- 実行可能ファイルを含む Gem の名前です。
- **param** `exec_name` -- 実行可能ファイルの名前です。省略すると例外が発生します。
- **param** `requirements` -- 使用する Gem のバージョンを指定します。[c:Gem::Requirement] が解釈できる形式で複数指定できます。
- **return** -- 実行可能ファイルのフルパスです。
- **raise** `ArgumentError` -- `exec_name` を指定しなかった場合に発生します。
- **raise** `Gem::GemNotFoundException` -- 条件に一致する Gem や実行可能ファイルが見つからなかった場合に発生します。

### module_function def bindir(install_dir = Gem.dir) -> String
{: since="1.9.2"}

Gem の実行可能ファイルをインストールするディレクトリのパスを返します。

`install_dir` にデフォルトのインストール先([m:Gem?.dir])を指定した場合は [m:Gem.default_bindir] を返します。それ以外の場合は `install_dir` の下の `bin` ディレクトリを返します。

- **param** `install_dir` -- Gem をインストールするディレクトリです。省略した場合は [m:Gem?.dir] になります。
- **return** -- 実行可能ファイルをインストールするディレクトリのパスです。
- **SEE** [m:Gem?.plugindir]

### module_function def configuration -> Gem::ConfigFile
{: since="1.9.2"}
### module_function def configuration=(config)
{: since="1.9.2"}

Gem の標準の設定オブジェクトを返します。

`configuration=` で明示的に設定していない場合は、[c:Gem::ConfigFile] の新しいインスタンスを生成して使用します。

- **param** `config` -- 標準の設定オブジェクトとして使うオブジェクトを指定します。[c:Gem::ConfigFile] と同じプロトコルを実装している必要があります。
- **return** -- 標準の設定オブジェクトです。
- **SEE** [c:Gem::ConfigFile]

#%until 3.3
### module_function def datadir(gem_name) -> String | nil
{: since="1.9.2"}

Gem `gem_name` のデータディレクトリのパスを返します。

`gem_name` が Gem として読み込まれていない場合は `nil` を返します。

- **param** `gem_name` -- データディレクトリを調べたい Gem の名前です。
- **return** -- データディレクトリのパスです。`gem_name` が Gem として利用できない場合は `nil` です。

#%end

#%since 3.3
### module_function def discover_gems_on_require -> bool
### module_function def discover_gems_on_require=(flag)

組み込みの `require` を拡張して、要求されたパスがインストール済みの Gem に含まれていないか自動的に確認し、含まれていれば自動的に有効化して `$LOAD_PATH` に追加するかどうかを表します。

- **param** `flag` -- 自動確認・自動有効化を行うかどうかを真偽値で指定します。
- **return** -- 現在の設定です。

```ruby title="例"
p Gem.discover_gems_on_require # => true
```

#%end

### module_function def done_installing {|installer, specs| ... } -> [Proc]
{: since="2.0.0"}

[c:Gem::DependencyInstaller] によるインストールが完了した後に呼び出すフックを登録します。

ブロックには、インストールを行った [c:Gem::DependencyInstaller] のインスタンスと、インストールされた [c:Gem::Specification] の配列が渡されます。

- **param** `installer` -- インストールを行った [c:Gem::DependencyInstaller] のインスタンスです。
- **param** `specs` -- インストールされた [c:Gem::Specification] の配列です。
- **return** -- 登録済みのフック(`Proc`)の配列です。
- **SEE** [m:Gem::DependencyInstaller#install], [m:Gem?.done_installing_hooks]

### module_function def done_installing_hooks -> [Proc]
{: since="2.0.0"}

[m:Gem?.done_installing] で登録された、インストール完了後に呼び出されるフックの配列を返します。

- **SEE** [m:Gem?.done_installing]

### module_function def find_files(glob, check_load_path = true) -> [String]
{: since="1.9.2"}

`glob` にマッチするパスの一覧を、Gem や `$LOAD_PATH` から探して返します。

他の Gem が提供する機能を取り込むために使います。異なるバージョンの同じ Gem のファイルであってもすべて返します。最新バージョンの Gem のファイルだけがほしい場合は [m:Gem?.find_latest_files] を使ってください。

- **param** `glob` -- 検索するファイルパスのパターンです。
- **param** `check_load_path` -- 真の場合、`$LOAD_PATH` からも検索します。省略した場合は真になります。
- **return** -- 見つかったファイルパスの配列です。

```ruby title="例"
Gem.find_files("rdoc/discover").each {|path| load path }
```

- **SEE** [m:Gem?.find_latest_files]

### module_function def find_latest_files(glob, check_load_path = true) -> [String]
{: since="2.1.0"}

`glob` にマッチするパスを、最新バージョンの Gem や `$LOAD_PATH` から探して返します。

[m:Gem?.find_files] と異なり、同じ Gem については最新バージョンのファイルだけを返します。

- **param** `glob` -- 検索するファイルパスのパターンです。
- **param** `check_load_path` -- 真の場合、`$LOAD_PATH` からも検索します。省略した場合は真になります。
- **return** -- 見つかったファイルパスの配列です。
- **SEE** [m:Gem?.find_files]

#%since 3.4
### module_function def freebsd_platform? -> bool

実行中のプラットフォームが FreeBSD であれば真を返します。そうでなければ偽を返します。

- **SEE** [m:Object::RUBY_PLATFORM], [m:Gem?.java_platform?], [m:Gem?.solaris_platform?]

#%end

### module_function def host -> String
{: since="1.9.3"}
### module_function def host=(host)
{: since="1.9.3"}

デフォルトの RubyGems API のホストを返します。通常は `https://rubygems.org` です。

- **param** `host` -- デフォルトの RubyGems API のホストとして設定する URL です。
- **return** -- デフォルトの RubyGems API のホストです。

```ruby title="例"
p Gem.host # => "https://rubygems.org"
```

### module_function def install(name, version = Gem::Requirement.default, *options) -> [Gem::Specification]
{: since="2.0.0"}

Gem `name` をインストールします。

irb などから対話的に Gem をインストールするためのヘルパーメソッドです。内部で [c:Gem::DependencyInstaller] のインスタンスを生成し、[m:Gem::DependencyInstaller#install] を呼び出します。

- **param** `name` -- インストールする Gem の名前です。
- **param** `version` -- インストールする Gem のバージョンの要求です。省略した場合は [m:Gem::Requirement.default] になります。
- **param** `options` -- [m:Gem::DependencyInstaller.new] に渡すオプションのハッシュです。
- **return** -- インストールされた [c:Gem::Specification] の配列です。
- **SEE** [m:Gem::DependencyInstaller.new], [m:Gem::DependencyInstaller#install]

### module_function def java_platform? -> bool
{: since="2.7.0"}

実行中の Ruby 処理系が Java プラットフォーム(JRuby)であれば真を返します。そうでなければ偽を返します。

- **SEE** [m:Object::RUBY_PLATFORM]

### module_function def latest_spec_for(name) -> Gem::Specification | nil
{: since="1.9.3"}

Gem `name` の、最新のリリースバージョンの [c:Gem::Specification] を返します。

- **param** `name` -- 調べたい Gem の名前です。
- **return** -- Gem `name` の最新のリリースバージョンの [c:Gem::Specification] です。見つからない場合は `nil` です。
- **SEE** [m:Gem?.latest_version_for]

### module_function def latest_version_for(name) -> Gem::Version | nil
{: since="1.9.3"}

Gem `name` の、最新のリリースバージョンを返します。

- **param** `name` -- 調べたい Gem の名前です。
- **return** -- Gem `name` の最新のリリースバージョンです。見つからない場合は `nil` です。
- **SEE** [m:Gem?.latest_spec_for]

### module_function def loaded_specs -> {String => Gem::Specification}
{: since="1.9.2"}

読み込み済みの [c:Gem::Specification] を、Gem 名をキーにしたハッシュで返します。

- **return** -- Gem 名をキー、読み込み済みの [c:Gem::Specification] を値とするハッシュです。

### module_function def needs {|request_set| ... } -> ()
{: since="2.0.0"}

ブロックに渡した `Gem::RequestSet` で宣言した Gem を解決し、有効化(activate)します。

ブロック引数として新しい `Gem::RequestSet` のインスタンスを受け取ります。ブロックの中で `RequestSet#gem` を呼び出して必要な Gem とバージョンを宣言すると、このメソッドがそれらを解決して有効化します。

- **param** `request_set` -- 必要な Gem を宣言するための `Gem::RequestSet` のインスタンスです。

```ruby title="例"
Gem.needs do |req|
  req.gem "rake"
end
```

### module_function def paths -> Gem::PathSupport
{: since="1.9.3"}
### module_function def paths=(env)
{: since="1.9.3"}

RubyGems がファイルを検索するために使う `Gem::PathSupport` のインスタンスを返します。

`paths=` に `env` を渡すと、それをもとに Gem の検索パスを再設定します。

- **param** `env` -- `GEM_HOME`・`GEM_PATH`・`GEM_SPEC_CACHE` を問い合わせるハッシュ相当のオブジェクトです(通常は `ENV`)。キーは文字列、値は文字列または `nil` を指定します。
- **return** -- RubyGems がファイルを検索するために使う `Gem::PathSupport` のインスタンスです。

### module_function def platforms -> [Gem::Platform]
{: since="1.9.2"}
### module_function def platforms=(platforms)
{: since="1.9.2"}

この RubyGems がサポートするプラットフォームの配列を返します。

明示的に設定していない場合は `[Gem::Platform::RUBY, Gem::Platform.local]` になります。`platforms=` は主にテストのために、この配列を明示的に設定するために使います。

- **param** `platforms` -- 設定する [c:Gem::Platform] の配列です。
- **return** -- この RubyGems がサポートするプラットフォームの配列です。
- **SEE** [m:Gem::Platform.local], [c:Gem::Platform]

### module_function def plugindir(install_dir = Gem.dir) -> String

RubyGems のプラグインをインストールするディレクトリのパスを返します。

- **param** `install_dir` -- Gem をインストールするディレクトリです。省略した場合は [m:Gem?.dir] になります。
- **return** -- `install_dir` の下の `plugins` ディレクトリのパスです。
- **SEE** [m:Gem?.bindir]

### module_function def post_build {|installer| ... } -> [Proc]
{: since="1.9.3"}

[m:Gem::Installer#install] でファイルの展開と拡張ライブラリのビルドが終わった後、実行可能ファイルや gemspec を書き込む前に呼び出すフックを登録します。

ブロックが偽を返した場合、インストールされたファイルは削除され、インストールは中止されます。

- **param** `installer` -- インストールを行っている [c:Gem::Installer] のインスタンスです。
- **return** -- 登録済みのフック(`Proc`)の配列です。
- **SEE** [m:Gem::Installer#install], [m:Gem?.post_build_hooks]

### module_function def post_build_hooks -> [Proc]
{: since="1.9.3"}

[m:Gem?.post_build] で登録された、インストール中に呼び出されるフックの配列を返します。

- **SEE** [m:Gem?.post_build]

### module_function def post_install {|installer| ... } -> [Proc]
{: since="1.9.1"}

[m:Gem::Installer#install] が完了した後に呼び出すフックを登録します。

- **param** `installer` -- インストールを行った [c:Gem::Installer] のインスタンスです。
- **return** -- 登録済みのフック(`Proc`)の配列です。
- **SEE** [m:Gem::Installer#install], [m:Gem?.post_install_hooks]

### module_function def post_install_hooks -> [Proc]
{: since="1.9.2"}

[m:Gem?.post_install] で登録された、インストール完了後に呼び出されるフックの配列を返します。

- **SEE** [m:Gem?.post_install]

### module_function def post_reset { ... } -> [Proc]
{: since="1.9.3"}

`Gem::Specification.reset` の実行後に呼び出すフックを登録します。

ブロックに引数は渡されません。

- **return** -- 登録済みのフック(`Proc`)の配列です。
- **SEE** [m:Gem?.post_reset_hooks], [m:Gem?.pre_reset]

### module_function def post_reset_hooks -> [Proc]
{: since="1.9.3"}

[m:Gem?.post_reset] で登録された、`Gem::Specification.reset` の実行後に呼び出されるフックの配列を返します。

- **SEE** [m:Gem?.post_reset]

### module_function def post_uninstall {|uninstaller| ... } -> [Proc]
{: since="1.9.1"}

[m:Gem::Uninstaller#uninstall] が完了した後に呼び出すフックを登録します。

ブロックには [c:Gem::Uninstaller] のインスタンスが渡されます。アンインストールされた [c:Gem::Specification] は、そのインスタンスの `spec` から取得できます。

- **param** `uninstaller` -- アンインストールを行った [c:Gem::Uninstaller] のインスタンスです。
- **return** -- 登録済みのフック(`Proc`)の配列です。
- **SEE** [m:Gem::Uninstaller#uninstall], [m:Gem?.post_uninstall_hooks]

### module_function def post_uninstall_hooks -> [Proc]
{: since="1.9.2"}

[m:Gem?.post_uninstall] で登録された、アンインストール完了後に呼び出されるフックの配列を返します。

- **SEE** [m:Gem?.post_uninstall]

### module_function def pre_install {|installer| ... } -> [Proc]
{: since="1.9.1"}

[m:Gem::Installer#install] が処理を始める前に呼び出すフックを登録します。

ブロックが偽を返した場合、インストールは中止されます。

- **param** `installer` -- インストールを行おうとしている [c:Gem::Installer] のインスタンスです。
- **return** -- 登録済みのフック(`Proc`)の配列です。
- **SEE** [m:Gem::Installer#install], [m:Gem?.pre_install_hooks]

### module_function def pre_install_hooks -> [Proc]
{: since="1.9.2"}

[m:Gem?.pre_install] で登録された、インストールを始める前に呼び出されるフックの配列を返します。

- **SEE** [m:Gem?.pre_install]

### module_function def pre_reset { ... } -> [Proc]
{: since="1.9.3"}

`Gem::Specification.reset` の実行前に呼び出すフックを登録します。

ブロックに引数は渡されません。

- **return** -- 登録済みのフック(`Proc`)の配列です。
- **SEE** [m:Gem?.pre_reset_hooks], [m:Gem?.post_reset]

### module_function def pre_reset_hooks -> [Proc]
{: since="1.9.3"}

[m:Gem?.pre_reset] で登録された、`Gem::Specification.reset` の実行前に呼び出されるフックの配列を返します。

- **SEE** [m:Gem?.pre_reset]

### module_function def pre_uninstall {|uninstaller| ... } -> [Proc]
{: since="1.9.1"}

[m:Gem::Uninstaller#uninstall] が処理を始める前に呼び出すフックを登録します。

ブロックには [c:Gem::Uninstaller] のインスタンスが渡されます。アンインストールされる予定の [c:Gem::Specification] は、そのインスタンスの `spec` から取得できます。

- **param** `uninstaller` -- アンインストールを行おうとしている [c:Gem::Uninstaller] のインスタンスです。
- **return** -- 登録済みのフック(`Proc`)の配列です。
- **SEE** [m:Gem::Uninstaller#uninstall], [m:Gem?.pre_uninstall_hooks]

### module_function def pre_uninstall_hooks -> [Proc]
{: since="1.9.2"}

[m:Gem?.pre_uninstall] で登録された、アンインストールを始める前に呼び出されるフックの配列を返します。

- **SEE** [m:Gem?.pre_uninstall]

### module_function def refresh -> ()
{: since="1.9.2"}

ディスク上の Gem の一覧をもとに、読み込み済みの Gem の情報を最新の状態に更新します。

内部で `Gem::Specification.reset` を呼び出します。これに伴い、[m:Gem?.pre_reset] と [m:Gem?.post_reset] で登録したフックも実行されます。

- **SEE** [m:Gem?.pre_reset], [m:Gem?.post_reset]

### module_function def ruby_api_version -> String
{: since="2.1.0"}

実行中の Ruby の API 互換性を表すバージョン文字列を返します。

- **return** -- Ruby の API 互換性を表すバージョン文字列です。

### module_function def ruby_version -> Gem::Version
{: since="1.9.2"}

実行中の Ruby のバージョンを表す [c:Gem::Version] を返します。

- **return** -- 実行中の Ruby のバージョンを表す [c:Gem::Version] です。

### module_function def rubygems_version -> Gem::Version
{: since="2.0.0"}

実行中の RubyGems のバージョンを表す [c:Gem::Version] を返します。

- **return** -- 実行中の RubyGems のバージョンを表す [c:Gem::Version] です。

#%since 3.1
### module_function def solaris_platform? -> bool

実行中のプラットフォームが Solaris であれば真を返します。そうでなければ偽を返します。

- **SEE** [m:Object::RUBY_PLATFORM], [m:Gem?.java_platform?]

#%end

### module_function def source_date_epoch -> Time
{: since="2.7.0"}

ビルドを再現可能にするための基準時刻を返します。

環境変数 `SOURCE_DATE_EPOCH` が設定されていればその値を、設定されていなければ 1980-01-02 00:00:00 UTC を返します。

- **return** -- ビルドを再現可能にするための基準時刻です。

```ruby title="例(環境変数 SOURCE_DATE_EPOCH が未設定の場合)"
p Gem.source_date_epoch # => 1980-01-02 00:00:00 UTC
```

### module_function def sources -> Gem::SourceList
{: since="1.9.2"}
### module_function def sources=(new_sources)
{: since="1.9.2"}

リモートから Gem を取得する際のソースの一覧を返します。

`sources=` で明示的に設定していない場合は、設定ファイルに指定されたソース、それも無ければ [m:Gem.default_sources] を使います。`sources=` に偽を渡すと設定がリセットされ、次に [m:Gem?.sources] を呼んだときに再計算されます。

- **param** `new_sources` -- 設定するソースの一覧です。偽を渡すとリセットされます。
- **return** -- リモートから Gem を取得する際のソースの一覧です。
- **SEE** [c:Gem::ConfigFile], [m:Gem.default_sources]

### module_function def spec_cache_dir -> String
{: since="2.1.0"}

Gem の仕様(spec)のキャッシュを保存するディレクトリのパスを返します。

- **return** -- Gem の仕様のキャッシュを保存するディレクトリのパスです。

### module_function def suffixes -> [String]
{: since="1.9.2"}

require 可能なパスの末尾に付きうるサフィックスの配列を返します。

空文字列・`".rb"`・実行環境の共有ライブラリの拡張子が含まれます。

- **return** -- require 可能なパスのサフィックスの配列です。

### module_function def ui -> Gem::ConsoleUI
{: since="1.9.2"}

RubyGems が既定で使う UI(ユーザーとの対話)オブジェクトを返します。

遅延読み込みされる `Gem::DefaultUserInteraction` 経由で取得します。既定では [c:Gem::ConsoleUI] のインスタンスですが、`Gem::DefaultUserInteraction.use_ui` で別の UI オブジェクトに切り替えられている場合はそちらを返します。

- **return** -- RubyGems が既定で使う UI オブジェクトです。
- **SEE** [c:Gem::ConsoleUI]

### module_function def use_gemdeps(path = nil) -> ()
{: since="2.1.0"}

`path` で指定した Gem の依存関係ファイルを探し、見つかった場合はそこに書かれている Gem を有効化します。

`path` を省略した場合は環境変数 `RUBYGEMS_GEMDEPS` の値を使います。それも無い場合は何もしません。`path` に `"-"` を指定すると、カレントディレクトリから親ディレクトリの方向に `gem.deps.rb`・`Gemfile`・`Isolate` を探し、最初に見つかったファイルの内容を有効化します。

複数ユーザーが使うシステムでこの自動探索を有効にすると、権限の及ばないディレクトリにある依存関係ファイルの内容が実行されてしまう可能性があるため注意してください。

- **param** `path` -- Gem の依存関係ファイルのパスです。省略した場合は環境変数 `RUBYGEMS_GEMDEPS` を使います。
- **raise** `ArgumentError` -- `path` を明示的に指定したにもかかわらず、そのファイルが見つからなかった場合に発生します。

## Constants

#%until 4.0
### const ConfigMap -> Hash

[m:RbConfig::CONFIG] の中からこのライブラリで使用するものを抽出して定義したハッシュ。

#%end
#%until 4.0
### const RubyGemsVersion -> String

このライブラリのバージョンを表す文字列。
#%end

### const WIN_PATTERNS -> Array

Windows 上で動いている Ruby を識別するための正規表現の配列。

# class Gem::LoadError < LoadError

Gem をロードできなかった場合に発生するエラーです。

## Public Instance Methods

### def name -> String

ロードに失敗した Gem の名前を返します。

### def name=(gem_name)

ロードに失敗した Gem の名前をセットします。

- **param** `gem_name` -- Gem の名前を指定します。

