= module NKF

[[unknown:nkf(1)|URL:http://www.ie.u-ryukyu.ac.jp/~kono/nkf/]]
(Network Kanji code conversion Filter version 1.7)
を ruby から使うためのモジュールです。

#@if (version >= "1.8.2.")
ruby 1.8.2 以降では
[[unknown:nkf Network Kanji Filter|URL:http://sourceforge.jp/projects/nkf/]]
の 2.0 以降が取り込まれています。
(((<ruby 1.8.2 feature>)))
#@end

=== 使い方
以下は、漢字コード変換コマンドの例です。

  #!/usr/local/bin/ruby
  
  require 'nkf'
  
  opt = ''
  opt = ARGV.shift if ARGV[0][0] == ?-
  
  while line = ARGF.gets
    print NKF.nkf(opt, line)
  end

以下は、漢字コード判別コマンドの例です。
(ruby 1.8.2 以降の NKF.guess では、以下の5種類以外の値になる可能性があります [[trap:NKF]])

  #!/usr/local/bin/ruby
  
  require 'nkf'
  
  CODES = {
    NKF::JIS      => "JIS",
    NKF::EUC      => "EUC",
    NKF::SJIS     => "SJIS",
    NKF::BINARY   => "BINARY",
    NKF::UNKNOWN  => "UNKNOWN(ASCII)",
  }
  
  while file = ARGV.shift
    str = open(file) {|io| io.gets(nil) }
    
    printf "%-10s ", file
    if str.nil?
      puts "EMPTY"
    else
      puts CODES.fetch NKF.guess(str)
    end
  end

=== オプション文字列

#@if (version >= "1.8.2")
==== ruby 1.8.2 以降
((<ruby 1.8.2 feature>))

NKF2.0.5 相当です。

  b,u      Output is buffered (DEFAULT),Output is unbuffered
  j,s,e,w  Outout code is JIS 7 bit (DEFAULT), Shift JIS, AT&T JIS (EUC), UTF-8
           After 'w' you can add more options. (80?|16((B|L)0?)?)
  J,S,E,W  Input assumption is JIS 7 bit , Shift JIS, AT&T JIS (EUC), UTF-8
           After 'W' you can add more options. (8|16(B|L)?)
  t        no conversion
  i_/o_    Output sequence to designate JIS-kanji/ASCII (DEFAULT B)
  r        {de/en}crypt ROT13/47
  h        1 katakana->hiragana, 2 hiragana->katakana, 3 both
  m[BQN0]  MIME decode [B:base64,Q:quoted,N:non-strict,0:no decode]
  M[BQ]    MIME encode [B:base64 Q:quoted]
  l        ISO8859-1 (Latin-1) support
  f/F      Folding: -f60 or -f or -f60-10 (fold margin 10) F preserve nl
  Z[0-3]   Convert X0208 alphabet to ASCII  1: Kankaku to space,2: 2 spaces,
                                            3: Convert HTML Entity
  X,x      Assume X0201 kana in MS-Kanji, -x preserves X0201
  B[0-2]   Broken input  0: missing ESC,1: any X on ESC-[($]-X,2: ASCII on NL
  T        Text mode output
  d,c      Delete \r in line feed and \032, Add \r in line feed
  I        Convert non ISO-2022-JP charactor to GETA
  -L[uwm]  line mode u:LF w:CRLF m:CR (DEFAULT noconversion)
  long name options
   --fj,--unix,--mac,--windows                        convert for the system
   --jis,--euc,--sjis,--utf8,--utf16,--mime,--base64  convert for the code
   --hiragana, --katakana    Hiragana/Katakana Conversion
   --cap-input, --url-input  Convert hex after ':' or ''
   --numchar-input   Convert Unicode Character Reference
   --no-cp932        Don't convert Shift_JIS FAxx-FCxx to equivalnet CP932
   --cp932inv        convert Shift_JIS EDxx-EFxx to equivalnet CP932 FAxx-FCxx
   --ms-ucs-map      Microsoft UCS Mapping Compatible

#@else

==== ruby 1.8.2 より前のバージョン
NKF1.7 相当です((-中には、ruby では無意味なオプションもあるかもしれません-))。

  指定できるオプションは、以下の通り。-mu のように続けることができる。

  -b   バッファリング出力を行う。(デフォルト)
  -u   出力時に、バッファリングしない。
  -t   何もしない。

  -j   JISコードを出力する。(デフォルト)
  -e   EUCコードを出力する。
  -s   シフトJISコードを出力する。

  -i?  JIS漢字を指示するシーケンスとして ESC-'$'-?を使用する。
       (デフォルトは、ESC-'$'-'B')
  -o?  1バイト英数文字セットを指示するシーケンスとして、ESC-
       '('-?を使用する。(デフォルトは、ESC-'('-'B')

  -r   ROT13/47の変換をする。
  -v   バージョンを表示する。
  -T   テキストモードで出力する。(MS-DOS上でのみ効力を持つ)

  -m   MIME を解読する。(defalut on)
       ISO-2022-JP(base64)とISO-8859-1(Q encode)のみを解読する。
       ISO-8859-1 (Latin-1) を解読する時は、-lフラグも必要である。
         -mB  MIME base64 stream を解読する。ヘッダなどは取り除くこと。
         -mQ  MIME quoted stream を解読する。
         -m0  MIME を解読しない。

  -l   0x80-0xfeのコードをISO-8859-1 (Latin-1)として扱う。
       JISコードアウトプットとの組合せみのみ有効。
       -s, -e, -xとは両立しない。

  -f?  一行?文字になるように簡単な整形をおこなう。デフォルトは60文字である。

  -Z   X0208中の英数字と若干の記号をASCIIに変換する。
         -Z1 はX0208間隔をASCII spaceに変換する。
         -Z2 はX0208間隔をASCII space 二つに変換する。

  -J -E -S -X -B
       期待される入力コードの性質を指定する。
         -J   ISO-2022-JPを仮定する。
         -E   日本語EUC(AT&T)を仮定する。
         -S   MS漢字を仮定する。X0201仮名も仮定される。
         -X   MS漢字中にX0201仮名があると仮定する。
         -B   壊れた(Broken)JISコード。ESCがなくなったと仮定する。
         -B1  ESC-(, ESC-$ のあとのコードを問わない
         -B2  改行のあとに強制的にASCIIに戻す

  -x   通常おこなわれるX0201仮名->X0208の仮名変換をしないで、X0201仮名を保存する。
       入力は、MS-Kanjiの1byte仮名、SO/SI、ESC-(-I, SSOを受け付ける。
       出力は、日本語EUC中ではSSO、JISでは ESC-'('-I を使う。

  -O   ファイル out_file に出力が保存されます。
       ファイル名が指定されていない場合は、'nkf.out'又は'wnkf.out'に出力する。

  -c   行末にCRコード(0D)を追加(拡張機能 -T と併用不可)
  -d   行末からCRコード(0D)を削除(拡張機能 -T と併用不可)
#@end

=== 参考

  * [[unknown:Rubyist Magazine|URL:http://jp.rubyist.net/magazine/]]
  * [[unknown:"標準添付ライブラリ紹介【第 3 回】 Kconv/NKF/Iconv"|URL:http://jp.rubyist.net/magazine/?0009-BundledLibraries]]

== Module Functions

--- nkf(opt, str)

文字列 str の文字コードを変換し、変換結果の文字列を返します。

opt には、
[[unknown:nkf(1)|URL:http://www.ie.u-ryukyu.ac.jp/~kono/nkf/]]
と同じコマンドラインオプションを指定します([[unknown:後述|nkf/オプション文字列]])。
複数指定する場合は、NKF.nkf('-Se', str) や
NKF.nkf('-S -e', str) などとします。optは、必ず '-'
で始めなければいけないことに注意してください。

: 注意
このメソッドは(nkf コマンドがそうであるように)、MIME Base64 の
デコード処理がデフォルトでオンになっています。この動作を無効にしたけ
れば opt に '-m0' を含めるようにしてください。

--- guess(str)

文字列 str の漢字コードを判別して返します。
返される値は、NKF モジュールのモジュール定数です(下記参照)。
ruby 1.8.2 より前は現在の NKF.guess1 と同じものです。
ruby 1.8.2 以降では NKF.guess2 と同じものです。

#@if (version >= "1.8.2")
--- guess1(str)

((<ruby 1.8.2 feature>))

ruby 1.8.1 以前の NKF.guess と同じものです。
#@end

#@if (version >= "1.8.2")
--- guess2(str)

((<ruby 1.8.2 feature>))

nkf2の漢字コード自動判定ルーチンを利用したものです。
#@end

== Constants

--- JIS

JIS コードを表します。

--- EUC

EUC コードを表します。

--- SJIS

SJIS コードを表します。

--- BINARY

入力が binary であることを表します。

--- UNKNOWN

コード判定に失敗したことを表します。

#@if (version >= "1.8.2")
--- ASCII

((<ruby 1.8.2 feature>))

ASCII コードを表します。
#@end

#@if (version >= "1.8.2")
--- UTF8

((<ruby 1.8.2 feature>))

UTF-8 コードを表します。
#@end

#@if (version >= "1.8.2")
--- UTF16

((<ruby 1.8.2 feature>))

UTF-16 コードを表します。
#@end
