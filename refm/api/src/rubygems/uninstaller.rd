require rubygems
require rubygems/dependency_list
require rubygems/doc_manager
require rubygems/user_interaction

Gem のアンインストールを行うためのライブラリです。

= class Gem::Uninstaller
include Gem::UserInteraction

Gem のアンインストールを行うためのクラスです。

== Public Instance Methods

--- ask_if_ok(spec) -> bool

アンインストール指定された Gem を削除すると依存関係を満たせなくなる場合に呼び出されます。

@param spec アンインストール指定されている Gem の [[c:Gem::Specification]] を指定します。

--- bin_dir -> String

Gem でインストールされたコマンドのあるディレクトリを返します。

--- dependencies_ok?(spec) -> bool

アンインストール指定された Gem を削除しても依存関係を満たすことができるか
どうかチェックします。

@param spec アンインストール指定されている Gem の [[c:Gem::Specification]] を指定します。

--- gem_home -> String

Gem がインストールされているディレクトリを返します。

--- path_ok?(spec) -> bool

アンインストール指定されている Gem がインストールされているパスをチェックします。

@param spec [[c:Gem::Specification]] を指定します。


--- remove(spec, list)
#@# -> discard

指定された Gem を削除します。

@param spec アンインストール指定されている Gem の [[c:Gem::Specification]] を指定します。

@param list アンインストールする Gem のリストを指定します。
            このパラメータは破壊的に変更されます。

@raise Gem::DependencyRemovalException アンインストール指定された Gem を削除すると
                                       依存関係が壊れる場合に発生します。

@raise Gem::GemNotInHomeException アンインストール指定された Gem が所定の
                                  ディレクトリにそんないしない場合に発生します。

--- remove_all(list)
#@# -> discard

list で与えられた Gem を全てアンインストールします。

@param list アンインストールする Gem のリストを指定します。

--- remove_executables(gemspec)
#@# -> discard

与えられた [[c:Gem::Specification]] に対応する実行ファイルを削除します。

@param gemspec アンインストール指定されている Gem の [[c:Gem::Specification]] を指定します。

--- spec -> Gem::Specification

[[m:Gem::Uninstaller#uninstall_gem]] の実行中のみセットされます。

--- uninstall
#@# -> discard

Gem をアンインストールします。

スペックファイルやキャッシュも削除します。

--- uninstall_gem(spec, specs)
#@# -> discard

与えられた spec に対応する Gem をアンインストールします。

@param spec アンインストール指定されている Gem の [[c:Gem::Specification]] を指定します。

@param specs アンインストールする Gem のリストを指定します。
             このパラメータは破壊的に変更されます。


== Singleton Methods

--- new(gem, options = {})

自身を初期化します。

@param gem アンインストールする Gem を指定します。

@param options オプションを指定します。
