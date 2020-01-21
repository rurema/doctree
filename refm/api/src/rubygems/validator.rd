require rubygems/digest/md5
require rubygems/format
require rubygems/installer

様々な Gem ファイルや Gem データベースを検証するためのライブラリです。

= class Gem::Validator < Object

様々な Gem ファイルや Gem データベースを検証するためのクラスです。

== Public Instance Methods

--- alien -> [Gem::Validator.ErrorData]

Gem ディレクトリ内に存在するかもしれない以下のような問題を検証します。

 * Gem パッケージのチェックサムが正しいこと
 * それぞれの Gem に含まれるそれぞれのファイルがインストールされたバージョンであることの一貫性
 * Gem ディレクトリに関係の無いファイルが存在しないこと
 * キャッシュ、スペック、ディレクトリがそれぞれ一つずつ存在すること

このメソッドは検証に失敗しても例外を発生させません。


--- remove_leading_dot_dir(path) -> String
#@# should be private ?

与えられたパスの先頭のドットを取り除いた文字列を返します。

--- unit_test(gem_spec)

与えられた Gem スペックにしたがってユニットテストを実行します。

@param gem_spec [[c:Gem::Specification]] のインスタンスを指定します。

--- verify_gem(gem_data) -> ()

与えられた Gem ファイルの内容の MD5 チェックサムを検証します。

@param gem_data Gem ファイルの内容を文字列で指定します。

@raise Gem::VerificationError 空の Gem ファイルを指定した場合に発生します。

@raise Gem::VerificationError MD5 チェックサムが不正である場合に発生します。


--- verify_gem_file(gem_path) -> ()

与えられた Gem ファイルのパスを使用して MD5 チェックサムを検証します。

@param gem_path Gem ファイルのパスを指定します。

@raise Gem::VerificationError Gem ファイルが見つからなかった場合に発生します。


== Constants

--- ErrorData
#@todo

エラー情報を記録するための構造体です。
以下の属性を持っています。

 * path
 * problem
