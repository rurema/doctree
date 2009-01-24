require rubygems

選択した Gem のインストールを実行できるプラットフォームのリストを扱うライブラリです。

= class Gem::Platform

選択した Gem のインストールを実行できるプラットフォームのリストを扱うクラスです。

== Public Instance Methods

--- ==(other) -> bool
#@todo

自身と other が同じプラットフォームである場合に真を返します。
そうでない場合は偽を返します。

同じプラットフォームであるとは、二つのプラットフォームの
CPU, OS, バージョンが同じであるということです。

@param other 比較対象のオブジェクトです。

--- ===(other) -> bool
#@todo

自身と other のプラットフォームが一致する場合に真を返します。
そうでない場合は、偽を返します。

プラットフォームが一致するとは、以下の条件を満たすことです。

  * 同じ CPU であること、または、どちらか一方が 'universal' であること
  * 同じ OS であること
  * 同じバージョンであること、または、どちらか一方がバージョンを持たないこと

@param other 比較対象のオブジェクトです。

--- =~(other) -> bool
#@todo

自身と other のプラットフォームが一致する場合に真を返します。
そうでない場合は、偽を返します。

other が文字列の場合は、まず [[c:Gem::Platform]] に変換してから比較を行います。
other が文字列でも [[c:Gem::Platform]] でもない場合は nil を返します。

@param other 比較対象のオブジェクトです。

@see [[m:Gem::Platform#===]]

--- cpu -> String
#@todo

CPU のアーキテクチャを返します。

--- cpu=(cpu)
#@todo

CPU のアーキテクチャをセットします。

@param cpu CPU のアーキテクチャを指定します。

--- os -> String
#@todo

OS の種類を返します。

--- os=(os)
#@todo

OS の種類をセットします。


@param os OS の種類を指定します。

--- to_a -> Array
#@todo

自身にセットされている CPU, OS, バージョンを配列として返します。

--- to_s -> String
#@todo

自身にセットされている CPU, OS, バージョンを文字列として返します。

--- version -> String
#@todo

プラットフォームのバージョンを返します。

--- version=(verson)
#@todo

プラットフォームのバージョンをセットします。

@param version プラットフォームのバージョンを指定します。

== Singleton Methods

--- local -> Gem::Platform
#@todo

--- match -> bool
#@todo

--- new(arch)
#@todo

自身を初期化します。

@param arch アーキテクチャを指定します。

== Constants

--- CURRENT -> String
#@todo

特定のプラットフォーム向けの Gem をビルドするときに使用します。

--- RUBY -> String
#@todo

Pure Ruby の Gem はバイナリファイルをビルドするために [[m:Gem::Specification#extensions]]
を使用する可能性があります。
