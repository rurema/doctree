require rubygems/command

指定された特定のバージョンの Gem パッケージに依存する Gem を使用するために
必要な [[Kernel.#gem]] メソッドの呼び出し方法を文字列で出力します。

= class Gem::Commands::LockCommand < Gem::Command

指定された特定のバージョンの Gem パッケージに依存する Gem を使用するために
必要な [[Kernel.#gem]] メソッドの呼び出し方法を文字列で出力します。

== Public Instance Methods

--- complain(message) -> ()
#@todo

指定されたメッセージを表示します。--strict が有効な場合は例外が発生します。

@param message 表示するメッセージを指定します。

@raise StandardError コマンドラインオプションに --strict が指定されている場合に発生します。

--- spec_path(gem_full_name) -> String
#@todo

指定されたGem パッケージの gemspec ファイルのフルパスを返します。

@param gem_full_name Gem パッケージの名前を指定します。


