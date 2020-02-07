#@since 1.9.1
require rubygems/defaults
require rubygems/exceptions
require rubygems/version
require rubygems/requirement
require rubygems/dependency
require rubygems/gem_path_searcher
require rubygems/source_index
require rubygems/platform
require rubygems/builder
#@# 確かに require されているが、ファイルが存在しないためコメントアウト。
#@# require rubygems/defaults/operating_system

sublibrary rubygems/gem_runner

RubyGems を扱うためのクラスやモジュールが定義されているライブラリです。

#@# _builtin/ 以下に移動する予定だったが形式が違いすぎるため保留

===[a:gem_command] gem コマンドの使い方

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
        http://rubygems.rubyforge.org

==== Gem パッケージをインストールする

例えば rak ( [[url:https://rubygems.org/gems/rak]] ) をインストールするには、以下のいずれかを実行します。

  $ gem install rak
  $ sudo gem install rak

特定のバージョンの Gem パッケージをインストールするには以下のようにします。

  $ gem install rak --version 0.8.1    # バージョン 0.8.1 をインストールする
  $ gem install rak --version '>= 0.5' # バージョン 0.5 以上のものをインストールする

Proxy サーバ経由で Gem パッケージをインストールするには以下のようにします。

  $ gem install rak -p http://user:pasword@proxy.example.com/

==== Gem パッケージをアンインストールする

例えば rak をアンインストールするには、以下のいずれかを実行します。

  $ gem uninstall rak
  $ sudo gem uninstall rak

特定のバージョンの Gem パッケージをアンインストールするには以下のようにします。

  $ gem uninstall rak --version 0.8.1

==== Gem パッケージを更新する

インストールされている Gem パッケージを更新するには以下のようにします。

  $ gem update
  $ sudo gem update

特定の Gem パッケージを更新するには以下のようにします。

  $ gem update rak

==== Gem パッケージを探す

パッケージ名から Gem パッケージを探すことができます。
'active' という文字列をパッケージ名に含むパッケージを探すには以下のようにします。

#@since 2.0.0
  $ gem search active       # デフォルトではリポジトリから検索します
  $ gem search active -a    # -a オプションをつけると全てのバージョンを表示します
#@else
  $ gem search active       # デフォルトではローカルにインストールされているものから検索します
  $ gem search active -r    # -r オプションをつけるをリポジトリから検索します
  $ gem search active -r -a # -a オプションをつけると全てのバージョンを表示します
#@end

より詳細な条件で検索したい場合は query を使用してください。

  $ gem query -n ^rails$ -r # rails にちょうど一致するものを検索する
  $ gem query -n ^rails -r  # rails で始まるものを検索する

パッケージの詳細からキーワード検索することはできません。

==== Gem パッケージを作成する

作成した gemspec ファイルを元にして Gem パッケージを簡単に作成することができます。

  $ gem build <gemspec filename>

最小の gemspec は以下のようになります。ビルドするために必要な最小の gemspec なので出来上がるのは
メタデータのみを含む Gem パッケージです。また、いくつかの警告が表示されます。

  Gem::Specification.new do |s|
    s.name    = 'hello'
    s.version = '0.0.0'
    s.summary = 'hello summary'
  end

実用的なライブラリを作成するための gemspec の例を示します。
警告メッセージが出力されないようにいくつか設定を追加しています。

  Gem::Specification.new do |s|
    s.name              = 'hello'
    s.version           = '0.0.0'
    s.summary           = 'hello summary'
    s.files             = ['lib/hello.rb']
    s.authors           = ['Hello Author']
    s.email             = 'hello_author@example.com'
    s.homepage          = 'http://example.com/hello/'
    s.description       = 'hello description'
    s.rubyforge_project = 'hello'
  end

: name
  この Gem の名前を指定します。
: version
  この Gem のバージョンを指定します。
: summary
  この Gem の短い説明を指定します。
: files
  この Gem に含むファイルのリストを指定します。
: authors
  この Gem の作者のリストを指定します。
: email
  この Gem の作者の連絡先メールアドレスを指定します。
: homepage
  この Gem のウェブサイトの URI を指定します。
: description
  この Gem の長い説明を指定します。
: rubyforge_project
  Rubyforge にプロジェクトがある場合、そのプロジェクト名を指定します。

実行可能なファイル (コマンド) を含む場合の gemspec は以下のようになります。

  Gem::Specification.new do |s|
    s.name              = 'hello'
    s.version           = '0.0.0'
    s.summary           = 'hello summary'
    s.files             = ['bin/hello', 'lib/hello.rb']
    s.executables       = ['hello']
    s.authors           = ['Hello Author']
    s.email             = 'hello@example.com'
    s.homepage          = 'http://example.com/hello'
    s.rubyforge_project = 'hello'
    s.description       = 'hello description'
  end

ライブラリの例に加えて executables を追加しています。

また、以下のように Rakefile にタスクを追加することもできます。

  require 'rake/gempackagetask'
  
  PKG_FILES = FileList[
    'lib/hello.rb',
    'spec/*'
  ]
  spec = Gem::Specification.new do |s|
    s.name             = 'hello'
    s.version          = '0.0.1'
    s.author           = 'Hello Author'
    s.email            = 'hello@example.com
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


@see [[c:Gem::Specification]], [[lib:rake]]

=== gem コマンドの設定
  * GEM_HOME Gem のホームディレクトリ
  * GEM_PATH Gem のサーチパス
  * $HOME/.gemrc

環境変数 GEM_HOME, GEM_PATH を設定する事によって Gem コマンドの動作を変更することができます。
また、ホームディレクトリに .gemrc という YAML フォーマットで書かれたファイルを置くことでも
動作を変更することができます。

例:

  --- 
  :backtrace: false
  :benchmark: false
  :bulk_threshold: 1000
  :sources: 
  - http://gems.rubyforge.org
  :update_sources: true
  :verbose: true
  gemhome: /home/hoge/.gems
  gempath: 
  - /usr/local/lib/ruby/gems/1.9
  gem: --no-rdoc --no-ri


=== 参考
: Rubyist Magazine - シリーズ パッケージマネジメント 【第 1 回】 RubyGems (1)
  [[url:https://magazine.rubyist.net/articles/0006/0006-PackageManagement.html]]
: Rubyist Magazine - シリーズ パッケージマネジメント 【第 2 回】 RubyGems (2)
  [[url:https://magazine.rubyist.net/articles/0010/0010-PackageManagement.html]]


= reopen Kernel

== Private Instance Methods

--- gem(gem_name, *version_requirements) -> bool
[[m:$LOAD_PATH]] に Ruby Gem を追加します。

指定された Gem をロードする前にその Gem が必要とする Gem をロードします。
バージョン情報を省略した場合は、最も高いバージョンの Gem をロードします。
指定された Gem やその Gem が必要とする Gem が見つからなかった場合は
[[c:Gem::LoadError]] が発生します。

バージョンの指定方法に関しては [[c:Gem::Version]] を参照してください。

rubygems ライブラリがライブラリバージョンの衝突を検出しない限り、
gem メソッドは全ての require メソッドよりも前に実行されます。

=== 環境変数 GEM_SKIP

特定の Gem をロードしないようにするために環境変数 GEM_SKIP を定義することができます。
特定の Gem がまだインストールされていないという状況を試すために使用できます。

例:

  GEM_SKIP=libA:libB ruby-I../libA -I../libB ./mycode.rb

@param gem Gem の名前の文字列か、Gem の依存関係を [[c:Gem::Dependency]] のインスタンスで指定します。

@param version_requirements 必要とする gem のバージョンを指定します。

@return Gem がロードできた場合は true を返します。ロードできなかった場合は false を返します。

@raise Gem::LoadError 指定された Gem やその Gem が必要とする Gem が見つからなかった場合に発生します。
                      ただし、環境変数 GEM_SKIP に指定されている Gem に関してはこの例外は発生しません。

@see [[c:Gem::Version]]

= module Gem

== Module Functions

--- clear_paths -> nil

[[m:Gem.#dir]], [[m:Gem.#path]] の値をリセットします。

次に [[m:Gem.#dir]], [[m:Gem.#path]] が呼ばれた時は、値を最初から計算します。
このメソッドは主にユニットテストの独立性を提供するために使用します。

--- marshal_version -> String

[[c:Marshal]] のバージョンを表す文字列を返します。

--- prefix -> String

このライブラリがインストールされているディレクトリの親ディレクトリを返します。

--- source_index -> Gem::SourceIndex

[[m:Gem.#path]] にある [[c:Gem::Specification]] のキャッシュを返します。
インストールされている [[c:Gem::Specification]] のインデックスを返します

@see [[c:Gem::SourceIndex]], [[c:Gem::Specification]]

--- win_platform? -> bool

Windows プラットフォームであれば真を返します。そうでなければ偽を返します。

@see [[m:Object::RUBY_PLATFORM]]

--- dir -> String

Gem のインストールされているディレクトリを返します。

--- ensure_gem_subdirectories

Gem をインストールするために必要なサブディレクトリを適切に作成します。

ディレクトリを作成する権限が無い場合もこのメソッドからは例外は発生しません。

@see [[m:Gem::DIRECTORIES]]

--- path -> Array

Gem を検索するパスの配列を返します。

--- set_home

Gem のホームディレクトリをセットします。

@see [[m:Gem.#set_home]]

--- set_paths

Gem を検索するパスをセットします。

@see [[m:Gem.#path]]

== Constants

--- ConfigMap -> Hash

[[m:RbConfig::CONFIG]] の中からこのライブラリで使用するものを抽出して定義したハッシュ。

--- DIRECTORIES -> Array

Gem のホームディレクトリ以下に作成されるサブディレクトリの配列。

--- RubyGemsVersion        -> String
--- RubyGemsPackageVersion -> String

このライブラリのバージョンを表す文字列。

--- WIN_PATTERNS -> Array

Windows 上で動いている Ruby を識別するための正規表現の配列。


= class Gem::LoadError < LoadError

Gem をロードできなかった場合に発生するエラーです。

== Public Instance Methods

--- name -> String

ロードに失敗した Gem の名前を返します。

--- name=(gem_name)

ロードに失敗した Gem の名前をセットします。

@param gem_name Gem の名前を指定します。

--- version_requirement -> Get::Requirement

ロードに失敗した Gem の必要条件を返します。

@see [[c:Gem::Requirement]], [[m:Gem::Dependency#version_requirements]]

--- version_requirement=(version_requirement)

ロードに失敗した Gem の必要条件をセットします。

@param version_requirement [[c:Gem::Requirement]] のインスタンスをセットします。

@see [[c:Gem::Requirement]], [[m:Gem::Dependency#version_requirements]]


= module Gem::QuickLoader

prelude.c で定義されている内部用のモジュールです。

== Public Instance Methods

--- calculate_integers_for_gem_version

prelude.c で定義されている内部用のメソッドです。

--- const_missing

prelude.c で定義されている内部用のメソッドです。

--- method_missing

prelude.c で定義されている内部用のメソッドです。

--- push_all_highest_version_gems_on_load_path

prelude.c で定義されている内部用のメソッドです。

--- push_gem_version_on_load_path

prelude.c で定義されている内部用のメソッドです。

== Singleton Methods

--- load_full_rubygems_library
prelude.c で定義されている内部用のメソッドです。

== Constants

--- GemPaths -> Hash

prelude.c で定義されている内部用の定数です。

--- GemVersions -> Hash

prelude.c で定義されている内部用の定数です。

#@end
