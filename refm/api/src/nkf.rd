category CharacterEncoding

nkf を Ruby から使うためのライブラリです。

= module NKF

nkf(Network Kanji code conversion Filter, [[url:https://osdn.net/projects/nkf/]]) を
Ruby から使うためのモジュールです。

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

  #!/usr/local/bin/ruby
  
  require 'nkf'
  
  CODES = {
    NKF::JIS      => "JIS",
    NKF::EUC      => "EUC",
    NKF::SJIS     => "SJIS",
    NKF::UTF8     => "UTF8",
    NKF::BINARY   => "BINARY",
    NKF::ASCII    => "ASCII",
    NKF::UNKNOWN  => "UNKNOWN",
  }
  
  while file = ARGV.shift
    str = open(file) {|io| io.gets(nil) }
    
    printf "%-10s ", file
    if str.nil?
      puts "EMPTY"
    else
      puts CODES.fetch(NKF.guess(str))
    end
  end

=== オプション文字列

  -b 入力がバッファリングされる(デフォルト)
  -u 入力がバッファリングされない
  -j -s -e -w -w16 出力するエンコーディングを指定する
    -j ISO-2022-JP (7bit JIS) を出力する(デフォルト)
    -s Shift_JIS を出力する
    -e EUC-JP を出力する
    -w UTF-8 を出力する(BOMなし)
    -w16 UTF-16 LE を出力する 
  -J -S -E -W -W16 入力文字列のエンコーデイングの推定値を指定する。
    -J 入力に JIS を仮定する
    -S 入力に Shift_JIS と X0201片仮名(いわゆる半角片仮名)
       を仮定する。-xを指定しない場合はX0201片仮名(いわゆる半角片仮名)はX0208の
       片仮名(いわゆる全角片仮名)に変換される
    -E 入力に EUC-JP を仮定する
    -W 入力に UTF-8 を仮定する
    -W16 入力に UTF-16LE を仮定する
  -t 変換しない
  -i_ JIS 漢字を指示するシーケンスを指定する。 (デフォルトはB(EUC-$-B))
  -o_ 1 バイト英数文字セットを指示するシーケンスを指定する。 (デフォルトはB(EUC-(-B))
  -r ROT13/47暗号化/復号化をする
  -h1 --hiragana 片仮名を平仮名に変換する
  -h2 --katakana 平仮名を片仮名に変換する
  -h3 --katakana-hiragana 片仮名を平仮名に、平仮名を片仮名に変換する
  -T テキストモードで出力する(MS-DOSでのみ有効)
  -l 0x80-0xfe のコードを ISO-8859-1 (Latin-1) として扱う
  -f[m-[n]] 1行がm文字になるようにnのマージンを取り整形する。デフォルトはmが60、nが10
  -F 整形時に改行を保持する
  -Z[0-3] X0208 のアルファベットといくつかの記号を ASCII に変換する
    -Z -Z0 X0208 アルファベットといくつかの記号を ASCII に変換する
           変換される記号は以下の通り
           ，．：；？！´｀＾＿—／＼｜‘’“”（）［］｛｝〈〉＋−＝＜＞＄％＃＆＊＠
    -Z1 X0208空白(いわゆる全角空白)を ASCII の空白に変換する
    -Z2 X0208空白(いわゆる全角空白)を ASCII の空白2つに変換する
    -Z3 X0208の＞、＜、”、＆、を '&gt;', '&lt;', '&quot;', '&amp;' に変換する
    -Z4 X0208の片仮名(いわゆる全角片仮名)を X0201片仮名(いわゆる半角片仮名)に変換する
  -X X0201片仮名(いわゆる半角片仮名)をX0208の片仮名(いわゆる全角片仮名)に変換する
  -x X0201片仮名(いわゆる半角片仮名)をX0208の片仮名(いわゆる全角片仮名)に変換せずに
     出力する。ISO-2022-JP で出力するときは ESC-(-I を、EUC-JPで出力するときは SSO を使う。
  -B[0-2] 入力に ESC が消えたような壊れた JIS を仮定する。
    -B1 ESC-(, ESC-$ のあとのコードを問わない
    -B2 改行のあとに強制的に ASCII に戻す
  -I ISO-2022-JP 以外の漢字コードを〓に変換する
  -L[uwm] -d -c 改行を変換する。デフォルトでは変換しない。
    -Lu -d 改行として LF を出力する
    -Lw -c 改行として CRLF を出力する
    -Lm 改行として CR を出力する
  -m[BQN0] MIMEを解読する。
    -m (デフォルト) ISO-2022-JP (B encode) と ISO-8859-1 (Q encode) を解読する(デフォルト)
    -mB MIME base64 stream を解読する。ヘッダなどはメソッドに渡す前に取り除く必要がある。
    -mQ MIME quoted stream を解読する。
    -mN MIME のチェックを緩くする。base64の中に改行があっても良い。
    -m0 MIME の解読を一切しない。エンコーディングの変換のみをするならばこれを指定しておくべき
       である。
  -M MIME に変換する。エンコードの変換を行ってから MIME変換する。
    -MB base64 に変換する
    -MQ quoted stream に変換する
  --fj --unix --mac --msdos  --windows これらのシステムに適した変換をします。
  --jis --euc --sjis --mime --base64 対応する変換をします。
  --jis-input --euc-input --sjis-input --mime-input --base64-input 入力を仮定します。
  --ic=input_codeset --oc=output-codeset 入力、出力それぞれのエンコーディングを指定します。
                                         以下のエンコーディングが利用可能です。
                                         ここでの名前の指定には大文字小文字は無視されます。
    ISO-2022-JP
    EUC-JP
    eucJP-ascii
    eucJP-ms
    CP51932
    Shift_JIS
    CP932
    UTF-8 UTF-8Nと同じ
    UTF-8N
    UTF-8-BOM
    UTF-16 UTF-16BE-BOMと同じ
    UTF-16BE 
    UTF-16BE-BOM
    UTF-16LE
    UTF-16LE-BOM
    UTF-32 UTF-32BEと同じ
    UTF-32BE
    UTF-32BE-BOM
    UTF-32LE
    UTF-32LE-BOM
    UTF-8-MAC これは入力側にしか指定できません
  --fb-{skip, html, xml, perl, java, subchar} 変換できなかった文字をどう取り扱うかを
    指定します。デフォルトは --fb-skip です。
  --prefix <escape character><target character>..
    Shift_JIS への変換時に、<target character>に指定した文字が2バイト目に
    現われた場合に<escape character>を付加します。<target character>は複数指定できます。
    例えば、--prefix=\$@ とすると、Shift_JIS の 2 文字目に $ か @ が来たら、
    その前に \ が挿入されます
  --no-cp932ext CP932で拡張された文字を取り扱わないようにします。
  --cap-input --url-input :、%でエスケープされた文字を元の文字に変換します
  --numchar-input "&#..;" 形式の Unicode文字参照を変換します
  --no-best-fit-chars
     Unicode からの変換の際に、round trip safeでない文字の変換を行いません。
     これを -x を併用することで、 Unicode がらみのエンコーディング間での変換
     (UTF-8 から UTF-16LE など)を正しく変換することができます。
     すなわち、これらのオプションを指定しないとそのような変換を正しく行うことはできません。
     
  -- 以降のオプションを無視します。

#@# -Z0 の挙動は JISX0208附属書4,5を参照しているようだが
#@# 違いもある

=== 参考

  * "標準添付ライブラリ紹介【第 3 回】 Kconv/NKF/Iconv" [[url:https://magazine.rubyist.net/articles/0009/0009-BundledLibraries.html#nkf]]

== Module Functions

--- nkf(opt, str) -> String

文字列 str の文字コードを変換し、変換結果の文字列を返します。

opt には、nkf と同じコマンドラインオプションを指定します。
オプション文字列は [[c:NKF]] のオプション文字列の項を
見てください。
#@# ここは「オプション文字列」に直接リンクしたいが
#@# おそらく方法がないので上のように書いておく。
オプションを複数指定する場合は、NKF.nkf('-Se', str) や
NKF.nkf('-S -e', str) などとします。optは、必ず '-'
で始めなければいけないことに注意してください。

@param opt オプション文字列です。
@param str 変換対象の文字列です。

=== 注意

このメソッドは(nkf コマンドがそうであるように)、MIME Base64 の
デコード処理がデフォルトでオンになっています。この動作を無効にしたけ
れば opt に '-m0' を含めてください。

--- guess(str) -> Encoding

文字列 str の漢字コードを推測して返します。

返される値は、NKF モジュールのモジュール定数です。

返される値(すなわち、推測可能なエンコーディング)は以下のいずれかです。
  * NKF::JIS
  * NKF::EUC
  * NKF::SJIS
  * NKF::UNKNOWN
  * NKF::UTF8
  * NKF::UTF16
  * Encoding::EUCJP_MS
  * Encoding::CP51932
  * Encoding::WINDOWS_31J

@param str 推測対象の文字列です。

== Constants

--- JIS -> Encoding

JIS コードを表します。

--- EUC -> Encoding

EUC コードを表します。

--- SJIS -> Encoding

SJIS コードを表します。

--- BINARY -> Encoding

バイナリ列を表します。

--- UNKNOWN -> nil

コード判定に失敗したことを表します。

--- NOCONV -> nil

コードを変換しないことを表します。

NKFモジュール自体からは利用しません。

--- AUTO -> nil

コードを自動判別することを表します。

NKFモジュール自体からは利用しません。

--- ASCII -> Encoding

ASCII コードを表します。

--- UTF8 -> Encoding

UTF-8 コードを表します。

--- UTF16 -> Encoding

UTF-16 (BigEndian) コードを表します。

--- UTF32 -> Encoding

UTF-32 (BigEndian) コードを表します。

--- VERSION -> String

"#{NKF::NKF_VERSION} (#{NKF_RELEASE_DATE})" と
あらわされる文字列です。

--- NKF_VERSION -> String

nkf 自体のバージョンを表す文字列です。

--- NKF_RELEASE_DATE -> String

nkf のリリース日を表す文字列です。
