category Text

#@since 1.8.7
UNIX Bourne シェルの単語分割規則に従った文字列分割機能と文字列エスケープ
機能を提供します。

Shellwords モジュールは、空白区切りの単語分割を行う shellsplit、
文字列をエスケープする shellescape、文字列エスケープを文字列リストに
対して適用する shelljoin の3つのモジュール関数を提供します。

また、shellwords ライブラリを require すると、組み込みクラス String
と Array が拡張され、これらのモジュール関数と同じ機能が
String#shellsplit, String#shellescape, Array#shelljoin として使える
ようになります。

#@else
UNIX シェルのコマンドライン解析に似た空白区切りの単語分割を行う
ライブラリです。
#@end

= module Shellwords

#@since 1.8.7
UNIX Bourne シェルの単語分割規則に従った文字列分割と文字列エスケープ
を行うモジュールです。

Shellwords モジュールは、空白区切りの単語分割を行う shellsplit、文字列を
エスケープする shellescape、文字列エスケープを文字列リストに対して適用
する shelljoin の3つのモジュール関数を提供します。

これらのメソッドの別名として、Shellwords.split, Shellwords.escape,
Shellwords.join も使用可能です。
ただし、これらの短縮形式のメソッドはクラスメソッドとしてのみ定義される
ため、関数形式の呼び出しはできません。

#@else
UNIX シェルのコマンドライン解析に似た空白区切りの単語分割を行うモジュールです。
#@end

== Module Functions

#@since 1.8.7
--- shellsplit(line) -> [String]
#@end
--- shellwords(line) -> [String]

#@since 1.8.7
Bourne シェルの単語分割規則に従った空白区切りの単語分割を行い、
単語 (文字列) の配列を返します。
#@else
UNIX シェルのコマンドライン解析に似た空白区切りの単語分割を行い、
単語 (文字列) の配列を返します。
#@end

空白、シングルクォート (')、ダブルクォート (")、バックスラッシュ (\)
を解釈します。

@param line 分割の対象となる文字列を指定します。
@return 分割結果の各文字列を要素とする配列を返します。
#@since 1.8.7
@raise ArgumentError 引数の中に対でないシングルクォートまたはダブル
       クォートが現れた場合に発生します。
#@else
@raise ArgumentError 引数が文字列でない場合か、引数の中に対でない
       シングルクォートまたはダブルクォートが現れた場合に発生します。
#@end

例:
    require 'shellwords'
    
    p Shellwords.shellwords(%q{  foo bar "foo bar"\ baz 'foo bar'  })
    # => ["foo", "bar", "foo bar baz", "foo bar"]
     
    p Shellwords.shellwords(%q{  A B C "D E F" "G","H I"  })
    # => ["A", "B", "C", "D E F", "G,H I"]

#@since 1.8.7
--- shellescape(str) -> String

文字列を Bourne シェルのコマンドライン中で安全に使えるようにエスケープします。

@param str エスケープの対象となる文字列を指定します。
@return エスケープされた文字列を返します。

例:
    require 'shellwords'
    
    pattern = 'Jan 15'
    puts "grep #{Shellwords.shellescape(pattern)} file"
    # => grep Jan\ 15 file

--- shelljoin(array) -> String

配列の各要素である文字列に対して、Bourne シェルのコマンドライン中で安全に
使えるためのエスケープを適用し、空白文字を介してそれらを連結したコマンド
ライン文字列を生成します。

個々の配列要素に対するエスケープには、[[m:Shellwords.#shellescape]] と
同じ規則が適用されます。

@param array エスケープ対象の文字列を要素とする配列を指定します。
@return エスケープ結果を連結した文字列を返します。

例:
    require 'shellwords'
    
    pattern = 'Jan 15'
    file = 'file name with spaces'
    puts Shellwords.shelljoin(['grep', pattern, file])
    # => grep Jan\ 15 file\ name\ with\ spaces
#@end

#@since 1.8.7
== Singleton Methods

--- split(line) -> [String]
Bourne シェルの単語分割規則に従った空白区切りの単語分割を行い、
単語 (文字列) の配列を返します。

このメソッドは、[[m:Shellwords.#shellsplit]] の別名です。

@param line 分割の対象となる文字列を指定します。
@return 分割結果の各文字列を要素とする配列を返します。
@raise ArgumentError 引数の中に対でないシングルクォートまたはダブル
       クォートが現れた場合に発生します。

--- escape(str) -> String
文字列を Bourne シェルのコマンドライン中で安全に使えるようにエスケープします。

このメソッドは、[[m:Shellwords.#shellescape]] の別名です。

@param str エスケープの対象となる文字列を指定します。
@return エスケープされた文字列を返します。

--- join(array) -> String
配列の各要素である文字列に対して、Bourne シェルのコマンドライン中で安全に
使えるためのエスケープを適用し、空白文字を介してそれらを連結したコマンド
ライン文字列を生成します。

このメソッドは、[[m:Shellwords.#shelljoin]] の別名です。

@param array エスケープ対象の文字列を要素とする配列を指定します。
@return エスケープ結果を連結した文字列を返します。
#@end

#@since 1.8.7
= reopen String

== Instance Methods

--- shellsplit -> [String]
Bourne シェルの単語分割規則に従った空白区切りの単語分割を行い、
単語 (文字列) の配列を返します。

string.shellsplit は、Shellwords.shellsplit(string) と等価です。

@return 分割結果の各文字列を要素とする配列を返します。
@raise ArgumentError 引数の中に対でないシングルクォートまたはダブル
       クォートが現れた場合に発生します。
@see [[m:Shellwords.#shellsplit]]

--- shellescape -> String
文字列を Bourne シェルのコマンドライン中で安全に使えるようにエスケープします。

string.shellescape は、Shellwords.escape(string) と等価です。

@return エスケープされた文字列を返します。
@see [[m:Shellwords.#shellescape]]

= reopen Array

== Instance Methods

--- shelljoin -> String
配列の各要素である文字列に対して、Bourne シェルのコマンドライン中で安全に
使えるためのエスケープを適用し、空白文字を介してそれらを連結したコマンド
ライン文字列を生成します。

array.shelljoin は、Shellwords.shelljoin(array) と等価です。

@return エスケープ結果を連結した文字列を返します。
@see [[m:Shellwords.#shelljoin]]
#@end
