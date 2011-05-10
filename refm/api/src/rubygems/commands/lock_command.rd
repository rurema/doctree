require rubygems/command

指定された特定のバージョンの Gem パッケージに依存する Gem を使用するために
必要な [[m:Kernel.#gem]] メソッドの呼び出し方法を文字列で出力します。

  Usage: gem lock GEMNAME-VERSION [GEMNAME-VERSION ...] [options]
    Options:
      -s, --[no-]strict                依存関係を満たせない場合に失敗します
#@include(common_options)
    Arguments:
      GEMNAME       ロックする Gem パッケージの名前を指定します
      VERSION       ロックする Gem パッケージのバージョンを指定します
    Summary:
      特定バージョンの Gem パッケージを使用するために必要な記述を表示します
    Description:
      The lock command will generate a list of +gem+ statements that will lock
      down
      the versions for the gem given in the command line.  It will specify exact
      versions in the requirements list to ensure that the gems loaded will always
      be consistent.  A full recursive search of all effected gems will be
      generated.
      
      Example:
      
        gemlock rails-1.0.0 > lockdown.rb
      
      will produce in lockdown.rb:
      
        require "rubygems"
        gem 'rails', '= 1.0.0'
        gem 'rake', '= 0.7.0.1'
        gem 'activesupport', '= 1.2.5'
        gem 'activerecord', '= 1.13.2'
        gem 'actionpack', '= 1.11.2'
        gem 'actionmailer', '= 1.1.5'
        gem 'actionwebservice', '= 1.0.0'
      
      Just load lockdown.rb from your application to ensure that the current
      versions are loaded.  Make sure that lockdown.rb is loaded *before* any
      other require statements.
      
      Notice that rails 1.0.0 only requires that rake 0.6.2 or better be used.
      Rake-0.7.0.1 is the most recent version installed that satisfies that, so we
      lock it down to the exact version.
    Defaults:
      --no-strict


= class Gem::Commands::LockCommand < Gem::Command

指定された特定のバージョンの Gem パッケージに依存する Gem を使用するために
必要な [[m:Kernel.#gem]] メソッドの呼び出し方法を文字列で出力します。

== Public Instance Methods

--- complain(message) -> ()

指定されたメッセージを表示します。--strict が有効な場合は例外が発生します。

@param message 表示するメッセージを指定します。

@raise Gem::Exception コマンドラインオプションに --strict が指定されている場合に発生します。

--- spec_path(gem_full_name) -> String

指定された Gem パッケージの gemspec ファイルのフルパスを返します。

@param gem_full_name Gem パッケージの名前を指定します。


