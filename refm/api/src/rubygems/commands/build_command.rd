require rubygems/command
require rubygems/builder

Gem パッケージをビルドするためのライブラリです。


  Usage: gem build GEMSPEC_FILE [options]
    Common Options:
      -h, --help                       このコマンドのヘルプを表示します
      -V, --[no-]verbose               表示を詳細にします
      -q, --quiet                      静かに実行します
          --config-file FILE           指定された設定ファイルを使用します
          --backtrace                  バックトレースを表示します
          --debug                      Ruby 自体のデバッグオプションを有効にします
    Arguments:
      GEMSPEC_FILE  Gem パッケージをビルドするのに必要な gemspec ファイル名を指定します
    Summary:
      gemspec ファイルから Gem パッケージをビルドします


= class Gem::Commands::BuildCommand < Gem::Command

Gem パッケージをビルドするためのクラスです。

== Public Instance Methods

--- load_gemspecs(filename) -> Array
#@todo

gemspec ファイルをロードします。

@param filename ファイル名を指定します。

--- usage -> String
#@todo

使用方法を表す文字列を返します。

--- yaml?(filename) -> bool
#@todo

引数が yaml ファイルである場合に真を返します。

@param filename ファイル名を指定します。
