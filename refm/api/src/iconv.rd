#@since 1.8.0
Iconv は UNIX 95 の iconv() 関数のラッパーで、
さまざまな文字コード体系間で文字列の変換を行ないます。

詳細は [[url:http://www.opengroup.org/]] のオンラインドキュメントを
参照して下さい。

  * [[man:iconv(3)]]
  * [[man:iconv_open(3)]]
  * [[man:iconv_close(3)]]
  * [[url:http://www.opengroup.org/onlinepubs/009695399/basedefs/iconv.h.html]]

=== 注意

どの文字コード体系が利用できるかはプラットフォーム依存です。さらに文字コード体系をあらわす文字列もプラットフォーム依存です。日本語 EUC をあらわす文字列が EUC-JP, euc-jp, eucJP など異なる場合があります。このプラットフォームによる違いを吸収するために、
「ext/iconv/charset_alias.rb」 が用意されています。
GNU ソフトウェア texinfo ([[url:http://www.gnu.org/software/texinfo/]]) に含まれるファイル config.charset を以下のミラーサイトから手に入れて

#@# * [[url:http://tug.ctan.org/cgi-bin/getFile.py?fn=/macros/texinfo/texinfo/intl/config.charset]]
#@# * [[url:http://ring.riken.go.jp/archives/text/CTAN/macros/texinfo/texinfo/intl/config.charset]]
 * [[url:http://ring.riken.go.jp/archives/text/CTAN/macros/texinfo/texinfo/gnulib/lib/config.charset]]

ext/iconv/ に置き、ext/iconv/ で次のように実行すると

  ruby extconf.rb
  make

iconv.rb が生成されます。この iconv.rb がプラットフォームによる文字コード体系をあらわす文字列の違いを吸収します。

config.charset のライセンスは LGPL なので、生成された iconv.rb にも LGPL が適用されます。
#@# 要調査

=== 例

  require 'iconv'
  euc = ["a4a2a4a4a4a6a4a8a4aa"].pack("H*") # あいうえお
  sjis = ["82a082a282a482a682a8"].pack("H*")
  iconv = Iconv.new('SHIFT_JIS', 'EUC-JP')  # EUC-JP から SHIFT_JIS へ変換
  str = iconv.iconv(euc)
  str << iconv.iconv(nil)
  p( str == sjis )

(1) 新しく [[c:Iconv]] のインスタンスを作り, [[m:Iconv#iconv]] メソッドを使う
      cd = Iconv.new(to, from)
      begin
        input.each {|s| output << cd.iconv(s)}
        output << cd.iconv(nil)      # don't forget this
      ensure
        cd.close
      end
(2) [[m:Iconv.open]] をブロックつきで呼び出す
      Iconv.open(to, from) do |cd|
        input.each {|s| output << cd.iconv(s)}
        output << cd.iconv(nil)
      end
(3) (2) の短縮系
      Iconv.iconv(to, from, *input.to_a)

=== 参考

  * 標準添付ライブラリ紹介【第 3 回】 Kconv/NKF/Iconv ([[url:http://jp.rubyist.net/magazine/?0009-BundledLibraries#l30]])

= class Iconv < Data
iconv 関数のラッパークラスです。

== Class Methods

--- new(to, from)    -> Iconv

文字コード from から to へ変換するIconvオブジェクトを生成します。

@param to 変換先の文字コード体系を表す文字列を指定します。

@param from 変換前の文字コード体系を表す文字列を指定します。

@raise TypeError to や from が String オブジェクトでないとき発生します。

@raise Iconv::InvalidEncoding to や from で指定された文字コード体系が見つからないとき発生します。

@raise SystemCallError [[man:iconv_open(3)]] が失敗したとき発生します。

例:
  require 'iconv'
  # EUC-JP から SHIFT_JIS へ変換するIconvオブジェクトを生成。
  icv = Iconv.new('SHIFT_JIS', 'EUC-JP')
 
--- open(to, from)               -> Iconv
--- open(to, from) {|cd| ...}    -> object

ブロックが与えられない場合は [[m:Iconv.new]] と等価です。
ブロックが与えられると、Iconv オブジェクトを生成し、それを引数としてブロックを実行します。
ブロックの終りに Iconv オブジェクトは close されます。
ブロックの値を返します。

@param to 変換先の文字コード体系を表す文字列を指定します。

@param from 変換前の文字コード体系を表す文字列を指定します。

@raise TypeError to や from が String オブジェクトでないとき発生します。

@raise Iconv::InvalidEncoding to や from で指定された文字コード体系が見つからないとき発生します。

例:
  euc = ["a4a2a4a4a4a6a4a8a4aa"].pack("H*") # あいうえおのEUC-JPコード

  Iconv.open("UTF-8", "EUC-JP") do |i|
    str = i.iconv(euc)
    str << i.iconv(nil)
  end
  puts str #=> あいうえお

--- iconv(to, from, *strs)    -> Array

与えられた文字コードにしたがって strs を変換し、結果を文字列の配列として返します。

次の省略形です。
  Iconv.open(to, from) {|cd| (strs + [nil]).collect {|s| cd.iconv(s)}}

@param to 変換先の文字コード体系を表す文字列を指定します。

@param from 変換前の文字コード体系を表す文字列を指定します。

@param strs 変換したい文字列を指定します。

このメソッドは
[[m:Iconv.new]], [[m:Iconv.open]] および [[m:Iconv#iconv]] の例外
を起こします。

--- conv(to, from, str)     -> String

与えられた文字コードにしたがって str を変換し、結果を文字列として返します。

次の省略形です。
  Iconv.iconv(to, from, str).join

@param to 変換先の文字コード体系を表す文字列を指定します。

@param from 変換前の文字コード体系を表す文字列を指定します。

@param str 変換したい文字列を指定します。

このメソッドは
[[m:Iconv.new]], [[m:Iconv.open]] および [[m:Iconv#iconv]] の例外
を起こします。

#@since 1.9.1
--- list                       -> Array
--- list {|*aliases| ... }     -> Array

各エイリアスセットごとに繰り返すイテレータです。
ブロックが指定されていなければ、その利用可能な文字コード体系の名前を文字列の配列として返します。
Iconv 標準の機能ではないのでサポートされるかはプラットフォームに依存します。

@raise NotImplementedError 実行プラットフォームでサポートされていない場合に発生します。
#@end

--- charset_map -> Hash

#@# Returns the map from canonical name to system dependent name.

文字コードセット名からシステム依存の文字コードセット名への [[c:Hash]] を返します。

#@since 1.9.1
--- ctlmethods -> Array

#@# Returns available iconvctl() method list.
システム上のlibiconvのiconvctl()関数で使用可能なフラグのリストを [[c:Array]] として返します。

#@end

== Instance Methods

--- close    -> String

変換を終了します。出力バッファを初期シフト状態に戻すための文字列を返します。
出力の文字符号化方式が内部状態をも持たない場合、空文字列を返します。

このメソッドが呼ばれたあとで [[m:Iconv#iconv]] が呼ばれると例外が
起きますが、close 自体は繰返し呼ばれても成功します。

例:

  i = Iconv.open("ISO-2022-JP", "EUC-JP")
  i.iconv("\264\301")     #=> "\e$B4A"
  i.iconv("\273\372")     #=> ";z"
  i.close                 #=> "\e(B"

--- iconv(str, start = 0, length = -1)    -> String

文字列の変換を開始し、変換後の文字列を返します。
str が文字列の場合、str[start, length] を変換し、
変換後の文字列を返します。

str が nil の場合、変換器をその初期シフト状態にし、
出力バッファを初期シフト状態に戻すためのバイト列からなる文字列を返します。
出力の文字符号化方式が内部状態をも持たない場合、空文字列を返します。

@param str 変換される文字列または nil を指定します。

@param start str のうち変換を開始するオフセットを指定します。

@param length str のうち変換する長さを指定します。nil か -1 のときは、start 以降全部を意味します。

@raise Iconv::IllegalSequence strに指定された文字列に入力に指示された文字コードに含まれないために変換が停止した場合に発生します。

@raise Iconv::InvalidCharacter 入力の最後が不完全な文字かシフトで終っているために変換が停止した場合に発生します。

@raise Iconv::OutOfRange ライブラリの内部エラーが発生した場合に発生します。

#@since 1.9.1

--- conv(str) -> String

文字列を変換し、変換後の文字列を返します。
str が nil の場合、空文字列""を返します。

@param str 変換される文字列を指定します。

例:
  utf8 = ["E38182E38184E38186E38188E3818A"].pack("H*") # あいうえお

  iconv = Iconv.new('EUC-JP', 'UTF-8') # UTF-8 から EUC へ変換
  str = iconv.conv(utf8)
  puts str #=> "あいうえお"

--- discard_ilseq=
#@todo

Sets discard_ilseq flag.

--- discard_ilseq?
#@todo

Returns discard_ilseq flag

--- transliterate=
#@todo

Sets transliterate flag.

--- transliterate?
#@todo

Returns transliterate flag.

--- trivial?
#@todo

Returns trivial flag.

#@end

= module Iconv::Failure

[[c:Iconv]] が起こす例外のためのモジュールです。

== Instance Methods

--- success    -> String
#@todo

例外が起こるまでに変換に成功した文字列を返します。

[[m:Iconv.iconv]] でこの例外が起こったときに返される値は、
以前の例外が起こるまでに変換に成功した文字列を要素とする配列です。
最後の要素は変換中の文字列です。

--- failed    -> String
#@todo

[[c:Iconv]] に渡された文字列のうち、
例外が起こった位置からはじまる部分を返します。

--- inspect    -> String
#@todo

#<type: "success", "failed"> のような形をした
文字列を返します。


#@since 1.8.4
= class Iconv::BrokenLibrary < RuntimeError
include Iconv::Failure

iconv ライブラリのバグなどにより、[[man:errno]] が設定されなかった場合に発生します。
(Windows で iconv.dll の使用する MSVC runtime DLL のバージョンが、ruby 本体が使用するものと一致していない場合も含みます。)
#@end

= class Iconv::IllegalSequence < ArgumentError
include Iconv::Failure

入力か出力の文字が指示された文字集合に含まれないために変換が停止したこと
を表します。

= class Iconv::InvalidCharacter < ArgumentError
include Iconv::Failure

入力の最後が不完全な文字かシフトで終っているために変換が停止したこと
を表します。

#@since 1.8.3
= class Iconv::InvalidEncoding < ArgumentError
include Iconv::Failure

メソッドの引数等で指定された文字コード体系が見つからない (システム上で有効でない) 場合に発生します。
#@end

= class Iconv::OutOfRange < RuntimeError
include Iconv::Failure

Iconv ライブラリの内部エラーです。この例外は起こらないはずです。
#@end
