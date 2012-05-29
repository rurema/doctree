require rubygems

Gem パッケージの RDoc, RI を生成するためのクラスを扱うライブラリです。

= class Gem::DocManager
include Gem::UserInteraction

Gem パッケージの RDoc, RI を生成するためのクラスです。

== Public Instance Methods

--- generate_rdoc
#@# -> discard

自身にセットされている [[c:Gem::Specification]] の情報をもとに RDoc のドキュメントを生成します。

--- generate_ri
#@# -> discard

自身にセットされている [[c:Gem::Specification]] の情報をもとに RI 用のデータを生成します。

--- install_rdoc
#@# -> discard

RDoc を生成してインストールします。

--- install_ri
#@# -> discard

RI のデータを生成してインストールします。

--- rdoc_installed? -> bool

RDoc がインストール済みの場合は、真を返します。
そうでない場合は偽を返します。

--- run_rdoc(*args)
#@# -> discard

与えられた引数を使用して RDoc を実行します。

@param args RDoc に与える引数を指定します。

@raise Gem::FilePermissionError RDoc でドキュメント生成中にファイルにアクセス出来なかった場合に発生します。

--- setup_rdoc
#@# -> discard

RDoc を実行するための準備を行います。

@raise Gem::FilePermissionError RDoc を保存するディレクトリにアクセスする権限がない場合に発生します。

--- uninstall_doc
#@# -> discard

RDoc と RI 用のデータを削除します。

== Singleton Methods

--- new(spec, rdoc_args = "") -> Gem::DocManager

自身を初期化します。

@param spec ドキュメントを生成する対象の [[c:Gem::Specification]] のインスタンスを指定します。

@param rdoc_args RDoc に渡すオプションを指定します。

--- configured_args -> Array

RDoc に渡す引数を返します。

--- configured_args=(args)

RDoc に渡す引数をセットします。

@param args 文字列の配列か空白区切りの文字列を指定します。

--- load_rdoc
#@# -> discard

Gem の RDoc が使用可能な場合は使用します。
そうでない場合は、標準添付の RDoc を使用します。

@raise Gem::DocumentError RDoc が使用できない場合に発生します。

--- update_ri_cache
#@# -> discard

RDoc 2 がインストールされている場合は RI のキャッシュを更新します。
そうでない場合は何もしません。
