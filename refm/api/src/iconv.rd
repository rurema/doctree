#@if (version >= "1.7.0")
Iconv は UNIX 95 の iconv() 関数のラッパーで、
さまざまな文字コード体系間で文字列の変換を行ないます。

詳細は[[unknown:Open Group|URL:http://www.opengroup.org/]] のオンラインドキュメントを
参照して下さい。

  * [[unknown:iconv.h]]
  * [[unknown:iconv_open()|URL:http://www.opengroup.org/onlinepubs/007908799/xsh/iconv_open.html]]
  * [[unknown:iconv()|URL:http://www.opengroup.org/onlinepubs/007908799/xsh/iconv.html]]
  * [[unknown:iconv_close()|URL:http://www.opengroup.org/onlinepubs/007908799/xsh/iconv_close.html]]

どの文字コード体系が利用できるかはプラットフォーム依存です。さらにエンコーディング名をあらわす文字列もプラットフォーム依存です。日本語 EUC をあらわす文字列が EUC-JP, euc-jp, eucJP など異なる場合があります。このプラットフォームによる違いを吸収するために、
[[unknown:"ruby-src:ext/iconv/charset_alias.rb"]] が用意されています。
GNU ソフトウェア [[unknown:texinfo|URL:http://www.gnu.org/software/texinfo/]] に含まれるファイル config.charset を以下のミラーサイトから手に入れて

[[url:http:#/ring.pwd.ne.jp/archives/text/CTAN/macros/texinfo/texinfo/intl/config.charset]]

ext/iconv/ に置き、ext/iconv/ で次のように実行すると

  ruby extconf.rb
  make

iconv.rb が生成されます。この iconv.rb がプラットフォームによるエンコーディング名をあらわす文字列の違いを吸収します。

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

  * [[unknown:Rubyist Magazine|URL:http://jp.rubyist.net/magazine/]]
  * [[unknown:"標準添付ライブラリ紹介【第 3 回】 Kconv/NKF/Iconv"|URL:http://jp.rubyist.net/magazine/?0009-BundledLibraries]]

= class Iconv < Data

== Class Methods

--- new(to, from)

from から to への新しい変換器を作り、それを返します。
to と from は変換先と変換前の文字コード体系です。

このメソッドが起こす例外は次の通りです。
  * to や from が String でないとき TypeError。
  * to や from で指定された変換器が見つからないとき
    ArgumentError。
  * iconv_open(3) が失敗したときSystemCallError。

--- open(to, from) {|cd| ...}

ブロックが与えられない場合は [[m:Iconv.new]] と等価です。
ブロックが与えられると、変換器を引数としてブロックを呼び、変換器を閉じて、
ブロックの値を返します。

--- iconv(to, from, *strs)

次の省略形です。

  Iconv.open(to, from) {|cd| (strs + [nil]).collect {|s| cd.iconv(s)}}

to, from の意味は [[m:Iconv.new]] と同じです。

strs は変換される文字列です。

このメソッドは
[[m:Iconv.new]], [[m:Iconv.open]] および [[m:Iconv#iconv]] の例外
を起こします。

--- conv(to, from, str)

次の省略形です。

  Iconv.iconv(to, from, str).join

詳しくは [[m:Iconv.iconv]] を参照してください。

#@if (version >= "1.9.0")
--- list {|*aliases| ... }

((<ruby 1.9 feature>))

各エイリアスセットごとに繰り返すイテレータです。
#@# Iterates each alias sets.
ブロックが指定されていなければエンコーディング名のリストを返します。
Iconv 標準の機能ではないのでサポートされるかはプラットフォームに依存します。
サポートされていない場合は例外 NotImplementedError を投げます。
#@end

== Instance Methods

--- close

変換を終了します。

このメソッドが呼ばれたあとで [[m:Iconv#iconv]] が呼ばれると例外が
起きますが、close 自体は繰返し呼ばれても成功します。

値として、
出力バッファを初期シフト状態に戻すためのバイト列を含む文字列を返します。

例:

  i = Iconv.open("ISO-2022-JP", "EUC-JP")
  i.iconv("\264\301")     #=> "\e$B4A"
  i.iconv("\273\372")     #=> ";z"
  i.close                 #=> "\e(B"

--- iconv(str, [ start = 0, [ length = -1 ] ])

文字列の変換を開始し、変換後の文字列を返します。
str が文字列の場合、str[start, length] を変換し、
変換後の文字列を返します。

str は変換される文字列または nil です。
start は str のうち変換を開始するオフセットを指定します。
length は str のうち変換する長さで、
nil か -1 のときは、start 以降全部を意味します。

str が nil の場合、変換器をその初期シフト状態にし、
出力バッファを初期シフト状態に戻すためのバイト列からなる文字列を返します。

その他の場合は例外を起こします。

このメソッドは起こす例外は
[[m:Iconv::IllegalSequence]]、
[[m:Iconv::InvalidCharacter]]、
および [[m:Iconv::OutOfRange]]
です。

= module Iconv::Failure

[[c:Iconv]] が起こす例外のためのモジュールです。

== Instance Methods

--- success

例外が起こるまでに変換に成功した文字列を返します。

[[m:Iconv.iconv]] でこの例外が起こったときに返される値は、
以前の例外が例外が起こるまでに変換に成功した文字列を要素とする配列です。
最後の要素は変換中の文字列です。

--- failed

[[c:Iconv]] に渡された文字列のうち、
例外が起こった位置からはじまる部分を返します。

--- inspect

#<type: "success", "failed"> のような形をした
文字列を返します。

#@if (version >= "1.8.4")
= class Iconv::BrokenLibrary < RuntimeError

include Iconv::Failure

((<ruby 1.8.4 feature>))

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

= class Iconv::OutOfRange < RuntimeError

include Iconv::Failure

Iconv ライブラリの内部エラーです。この例外は起こらないはずです。
#@end
