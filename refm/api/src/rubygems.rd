#@since 1.9.0
require rubygems/rubygems_version
require rubygems/defaults
require rubygems/exceptions
require rubygems/version
require rubygems/requirement
require rubygems/dependency
require rubygems/gem_path_searcher
require rubygems/source_index
require rubygems/platform
require rubygems/builder
require rubygems/defaults/operating_system

sublibrary rubygems/gem_runner

RubyGems を扱うためのクラスやモジュールが定義されているライブラリです。

#@# _builtin/ 以下に移動する予定だったが形式が違いすぎるため保留

=== gem コマンドの使い方

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

例えば rak ( [[url:http://rak.rubyforge.org/]] ) をインストールするには、以下のいずれかを実行します。

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

  $ gem search active       # デフォルトではローカルにインストールされているものから検索します
  $ gem search active -r    # -r オプションをつけるをリポジトリから検索します
  $ gem search active -r -a # -a オプションをつけると全てのバージョンを表示します

パッケージの詳細からキーワード検索することはできません。

==== Gem パッケージを作成する

執筆中

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


=== 参考
: Rubyist Magazine - シリーズ パッケージマネジメント 【第 1 回】 RubyGems (1)
  [[url:http://jp.rubyist.net/magazine/?0006-PackageManagement]]
: Rubyist Magazine - シリーズ パッケージマネジメント 【第 2 回】 RubyGems (2)
  [[url:http://jp.rubyist.net/magazine/?0010-PackageManagement]]


= reopen Kernel

== Private Instance Methods

--- gem(gem_name, *version_requirements) -> bool
#@todo
[[m:$LOAD_PATH]] に Ruby Gem を追加します。

指定された Gem をロードする前にその Gem が必要とする Gem をロードします。
バージョン情報を省略した場合は、最も高いバージョンの Gem をロードします。
指定された Gem やその Gem が必要とする Gem が見つからなかった場合は
[[c:Gem::LoadError]] が発生します。

バージョンの指定方法に関しては [[c:Gem::Version]] を参照してください。

rubygems ライブラリがライブラリバージョンの衝突を検出しない限り、
gem メソッドは全ての require メソッドよりも前に実行されます。

==== 環境変数 GEM_SKIP

特定の Gem をロードしないようにするために環境変数 GEM_SKIP を定義することができます。
特定の Gem がまだインストールされていないという状況を試すために使用できます。

例:

  GEM_SKIP=libA:libB ruby-I../libA -I../libB ./mycode.rb

@param gem Gem の名前の文字列か、Gem の依存関係を [[c:Gem::Dependency]] のインスタンスで指定します。

@param version_requirement 必要とする gem のバージョンを指定します。

@return Gem がロードできた場合は true を返します。ロードできなかった場合は false を返します。

@raise Gem::LoadError 指定された Gem やその Gem が必要とする Gem が見つからなかった場合に発生します。
                      ただし、環境変数 GEM_SKIP に指定されている Gem に関してはこの例外は発生しません。

@see [[c:Gem::Version]]

#@# #@include 'rubygems/Gem'

#@end
