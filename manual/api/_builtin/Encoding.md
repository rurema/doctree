---
library: _builtin
since: "1.9.1"
---
# class Encoding
文字エンコーディング(文字符号化方式)のクラスです。Rubyの多言語対応(M17N)機能において利用されます。

例えば文字列オブジェクトは、文字列のバイト表現の他にそのバイト表現がどのエンコーディングによるものであるかも併せて保持しています。この情報は [m:String#encoding] により取得できます。 Encoding オブジェクトを返すメソッドにはこの他に [m:IO#internal_encoding], [m:IO#external_encoding] などがあります。

- **SEE** [d:spec/m17n]

## Class Methods

### def aliases    -> Hash
エンコーディングの別名に対して元の名前を対応づけるハッシュを返します。

```ruby title="例"
p Encoding.aliases
#=> {"BINARY"=>"ASCII-8BIT", "ASCII"=>"US-ASCII", "ANSI_X3.4-1968"=>"US-ASCII",
#   "SJIS"=>"Windows-31J", "eucJP"=>"EUC-JP", "CP932"=>"Windows-31J"}
```

### def compatible?(obj1, obj2) -> Encoding | nil
2つのオブジェクトのエンコーディングに関する互換性をチェックします。
互換性がある場合はそのエンコーディングを、
ない場合は nil を返します。

引数が両方とも文字列である場合、互換性があるならば
その文字列を結合できます。この場合返り値のエンコーディングは
結合した文字列が取るであろう Encoding オブジェクトを返します。

```ruby title="例"
p Encoding.compatible?("\xa1".force_encoding("iso-8859-1"), "b")
#=> #<Encoding:ISO-8859-1>

Encoding.compatible?(
  "\xa1".force_encoding("iso-8859-1"),
  "\xa1\xa1".force_encoding("euc-jp"))
#=> nil
```

引数が文字列でない場合でも、両方のオブジェクトが encoding を持つ場合には
互換性を判定できます。
```ruby title="例"
p Encoding.compatible?(Encoding::UTF_8, Encoding::CP932)
# => nil
p Encoding.compatible?(Encoding::UTF_8, Encoding::US_ASCII)
# => #<Encoding:UTF-8>
```
- **param** `obj1` -- チェック対象のオブジェクト
- **param** `obj2` -- チェック対象のオブジェクト

### def find(name) -> Encoding
指定された name という名前を持つ Encoding オブジェクトを返します。

- **param** `name` -- エンコーディング名を表す [c:String] を指定します。
- **return** -- 発見された Encoding オブジェクトを返します。
- **raise** `ArgumentError` -- 指定した名前のエンコーディングが発見できないと発生します。

特殊なエンコーディング名として、ロケールエンコーディングを表す locale、default_external を表す external、default_internal を表す internal、ファイルシステムエンコーディングを表す filesystem があります。

```ruby title="例"
p Encoding.find("utf-8")       #=> #<Encoding:UTF-8>
```


### def list -> [Encoding]
現在ロードされているエンコーディングのリストを返します。

```ruby title="例"
p Encoding.list
# => [#<Encoding:ASCII-8BIT>, #<Encoding:EUC-JP>,
#     #<Encoding:Shift_JIS>, #<Encoding:UTF-8>,
#     #<Encoding:ISO-2022-JP (dummy)>]

p Encoding.find("US-ASCII")
# => #<Encoding:US-ASCII>

p Encoding.list
# => [#<Encoding:ASCII-8BIT>, #<Encoding:EUC-JP>,
#     #<Encoding:Shift_JIS>, #<Encoding:UTF-8>,
#     #<Encoding:US-ASCII>, #<Encoding:ISO-2022-JP (dummy)>]
```

### def name_list    -> [String]
利用可能なエンコーディングの名前を文字列の配列で返します。

```ruby title="例"
p Encoding.name_list
#=> ["US-ASCII", "ASCII-8BIT", "UTF-8",
#    "ISO-8859-1", "Shift_JIS", "EUC-JP",
#    "Windows-31J",
#    "BINARY", "CP932", "eucJP", ...]
```

### def default_external -> Encoding
既定の外部エンコーディングを返します。

標準入出力、コマンドライン引数、open で開くファイルなどで、外部エンコーディングが指定されていない場合の既定値として利用されます。

Rubyはロケールまたは -E オプションに従って default_external を決定します。ロケールの確認・設定方法については各システムのマニュアルを参照してください。

-E オプションを指定していない場合は、WindowsではUTF-8、その他のOSではロケールに従って default_external を決定します。

default_external は必ず設定されます。[m:Encoding.locale_charmap] が nil を返す場合には US-ASCII が、
ロケールにRubyが扱えないエンコーディングが指定されている場合には ASCII-8BIT が、default_external に設定されます。

- **SEE** [d:spec/rubycmd] [man:locale(1)], [m:Encoding.locale_charmap] [m:Encoding.default_internal]

### def default_external=(encoding)
既定の外部エンコーディングを設定します。

default_external を変更する前に作成した文字列と、default_external を変更した後に作成した文字列とではエンコーディングが異なる可能性があるため、Ruby スクリプト内で Encoding.default_external を設定してはいけません。代わりに、ruby -E を使用して、正しい default_external で Ruby を起動してください。

デフォルトの外部エンコーディングがどのように使われるかについては [m:Encoding.default_external] を参照してください。

- **SEE** [d:spec/rubycmd] [m:Encoding.default_external]

### def default_internal -> Encoding | nil
既定の内部エンコーディングを返します。デフォルトでは nil です。

標準入出力、コマンドライン引数、open で開くファイルなどで、内部エンコーディングが指定されていない場合の既定値として利用されます。

[m:String#encode] と [m:String#encode!] は、引数に Encoding が与えられていない場合、 default_internal を使用します。

文字列リテラルを作成した場合、エンコーディングには default_internal ではなく `__ENCODING__` 特殊変数で参照できるスクリプトエンコーディングが使用されます。

default_internal は、ソースファイルの [m:IO.internal_encoding] または -E オプションで初期化されます。

- **SEE** [d:spec/rubycmd] [m:Encoding.default_external]

### def default_internal=(encoding)

既定の内部エンコーディングを設定します。

default_internal を変更する前に作成した文字列と、default_internal を変更した後に作成した文字列とではエンコーディングが異なる可能性があるため、Ruby スクリプト内で Encoding.default_internal を設定してはいけません。代わりに、ruby -E を使用して、正しい default_internal で Ruby を起動してください。

デフォルトの内部エンコーディングがどのように使われるかについては [m:Encoding.default_internal] を参照してください。

- **SEE** [d:spec/rubycmd] [m:Encoding.default_internal]

### def locale_charmap -> String | nil
ロケールエンコーディングを決定するために用いる、locale charmap 名を返します。nl_langinfo 等がない環境では nil を、miniruby では ASCII_8BIT を返します。

```ruby title="Debian GNU/Linux + LANG=C"
p Encoding.locale_charmap #=> "ANSI_X3.4-1968"
```

```ruby title="LANG=ja_JP.EUC-JP"
p Encoding.locale_charmap #=> "EUC-JP"
```

```ruby title="SunOS 5 + LANG=C"
p Encoding.locale_charmap #=> "646"
```

```ruby title="SunOS 5 + LANG=ja"
p Encoding.locale_charmap #=> "eucJP"
```

- **SEE** [man:charmap(5)]

## Instance Methods

### def inspect -> String
プログラマにわかりやすい表現の文字列を返します。

```ruby title="例"
p Encoding::UTF_8.inspect     #=> "#<Encoding:UTF-8>"
p Encoding::ISO_2022_JP.inspect #=> "#<Encoding:ISO-2022-JP (dummy)>"
```

### def name -> String
### def to_s -> String
エンコーディングの名前を返します。

```ruby title="例"
p Encoding::UTF_8.name     #=> "UTF-8"
```

### def names -> String
エンコーディングの名前とエイリアス名の配列を返します。

```ruby title="例"
p Encoding::UTF_8.names    #=> ["UTF-8", "CP65001"]
```

### def dummy? -> bool
自身がダミーエンコーディングである場合に true を返します。
そうでない場合に false を返します。

ダミーエンコーディングとは Ruby が名前を知っているものの実質的には対応していないエンコーディングのことです。例えば、ダミーエンコーディングで符号化された文字列の場合、 [m:String#length] はマルチバイト文字を考慮せずにバイト列の長さを返します。

ダミーエンコーディングも [c:IO] の外部エンコーディングに指定できます。また
Ruby はサポートしていないが拡張ライブラリがサポートしているエンコーディングを扱う場合にも
用います。

```ruby title="例"
p Encoding::ISO_2022_JP.dummy?     #=> true
p Encoding::UTF_8.dummy?           #=> false
```

### def ascii_compatible? -> bool

自身が ASCII 互換のエンコーディングである場合真返します。
そうでない場合は偽を返します。


```ruby title="例"
p Encoding::UTF_8.ascii_compatible?   #=> true
p Encoding::UTF_16BE.ascii_compatible?  #=> false
```

#@until 3.3
### def replicate(name) -> Encoding

レシーバのエンコーディングを複製(replicate)します。
複製されたエンコーディングは元のエンコーディングと同じバイト構造を持たなければなりません。
name という名前のエンコーディングが既に存在する場合は [c:ArgumentError] を発生します。

#@since 3.2
このメソッドは Ruby 3.2 から deprecated であり、Ruby 3.3 で削除されました。
#@end

```ruby
encoding = Encoding::UTF_8.replicate("REPLICATED_UTF-8")     #=> #<Encoding:REPLICATED_UTF-8>
p encoding.name                                              #=> "REPLICATED_UTF-8"
p "\u3042".force_encoding(Encoding::UTF_8).valid_encoding?   #=> true
p "\u3042".force_encoding(encoding).valid_encoding?          #=> true
p "\u3042".force_encoding(Encoding::SHIFT_JIS).valid_encoding? #=> false
```
#@end

## Constants

### const ASCII_8BIT -> Encoding
### const BINARY -> Encoding
ASCII-8BIT、ASCII互換オクテット列用のエンコーディングです。

もっぱら文字エンコーディングを持たないデータ、文字を符号化したのではない単なるバイトの列を表現するために用いますが、このエンコーディングは ASCII 互換であることがポイントです。

### const CESU_8 -> Encoding

CESU-8 エンコーディングです。

UTF-8 の亜種です。Unicode コンソーシアムは使用を推奨していません。

- **SEE** <https://bugs.ruby-lang.org/issues/15931>, <https://www.unicode.org/reports/tr26/tr26-4.html>

### const EUC_JP -> Encoding
### const EucJP -> Encoding
### const EUCJP -> Encoding
IANA Character Sets にある EUC-JP のことです。

日本語 EUC 亜種で、G0 が US-ASCII、G1 が JIS X 0201 片仮名図形文字集合、G2 が JIS X 0208、G3 が JIS X 0212 となっています。
EUC-JP を指定する場合は、それが実際には CP51932 のことである可能性を考えなければなりません。

### const ISO_2022_JP -> Encoding
### const ISO2022_JP -> Encoding
ISO 2022-JP エンコーディングです。

- **SEE** <http://tools.ietf.org/html/rfc1468>

### const Shift_JIS -> Encoding
### const SHIFT_JIS -> Encoding
IANA Character Sets にある Shift_JIS のことです。

基本的にはJIS X 0208:1997の付属書1にある「シフト符号化表現」のことですが、
Ruby M17N では 7bit 部分が US-ASCII になっています。

### const US_ASCII -> Encoding
### const ASCII -> Encoding
### const ANSI_X3_4_1968 -> Encoding
US-ASCII、いわゆる ASCII のことで、ISO 646 IRV と一致します。

7bit の範囲のみを含み、8bit 目の立っている文字 (たとえば \x80 など) が含まれる場合は正しいエンコーディングであるとみなしません。

### const UTF_16 -> Encoding
UTF-16 (BOMを含む) です。

ダミーエンコーディングです。

### const UTF_32 -> Encoding
UTF-32 (BOMを含む) です。

ダミーエンコーディングです。

### const UTF_16BE -> Encoding
### const UCS_2BE -> Encoding
UTF-16BE (ビッグエンディアン) です。

BOM を含みません。

### const UTF_16LE -> Encoding
UTF-16LE (リトルエンディアン) です。

BOM を含みません。

### const UTF_32BE -> Encoding
### const UCS_4BE -> Encoding
UTF-32BE (ビッグエンディアン) です。

BOM を含みません。

### const UTF_32LE -> Encoding
### const UCS_4LE -> Encoding
UTF-32LE (リトルエンディアン) です。

BOM を含みません。

### const UTF_8 -> Encoding
### const CP65001 -> Encoding
UTF-8。Unicode や ISO 10646 を ASCII 互換な形で符号化するための方式です。

BOM を含みません。

- **SEE** <https://tools.ietf.org/html/rfc3629>


### const UTF8_MAC -> Encoding
### const UTF_8_MAC -> Encoding
### const UTF_8_HFS -> Encoding
UTF8-MAC、アップルによって修正された Normalization Form D（分解済み）という形式のUTF-8です。

- **SEE** <http://developer.apple.com/jp/technotes/tn1150.html>,
     <http://developer.apple.com/jp/technotes/tn2078.html>

### const UTF_7 -> Encoding
### const CP65000 -> Encoding

UTF-7 です。

7ビットの範囲内で表現される、Unicode のエンコーディングの一種です。
ダミーエンコーディングです。


### const Big5 -> Encoding
### const BIG5 -> Encoding

Big5 エンコーディングです。

台湾で使われている繁体字中国語のエンコーディングです。

- **SEE** <https://en.wikipedia.org/wiki/Big5>

### const CP950 -> Encoding

CP950 エンコーディングです。

Windows で使われる Big5 の亜種です。

- **SEE** <http://msdn.microsoft.com/en-us/goglobal/cc305155.aspx>

### const Big5_HKSCS -> Encoding
### const BIG5_HKSCS -> Encoding
### const BIG5_HKSCS_2008 -> Encoding
### const Big5_HKSCS_2008 -> Encoding

Big5-HKSCS エンコーディングです。

香港で使われている Big5 の亜種です。

- **SEE** <http://www.iana.org/assignments/charset-reg/Big5-HKSCS>,
     <http://www.ogcio.gov.hk/en/business/tech_promotion/ccli/hkscs/>


### const CP951 -> Encoding
CP951 エンコーディングです。

Windows で使われる Big5-HKSCS の亜種です。

- **SEE** <http://www.microsoft.com/hk/hkscs/default.aspx>,
     <http://www.microsoft.com/downloads/en/details.aspx?FamilyID=0e6f5ac8-7baa-4571-b8e8-78b3b776afd7&DisplayLang=en>,
     <http://blogs.msdn.com/b/shawnste/archive/2007/03/12/cp-951-hkscs.aspx>


### const BIG5_UAO -> Encoding
### const Big5_UAO -> Encoding
Big5_UAO エンコーディングです。

Big5 の亜種(非公式的拡張)です。

Unicodeとの対応表が
<http://moztw.org/docs/big5/table/big5_2003-b2u.txt>
にあります。


### const CP51932 -> Encoding
Windows で用いられる、日本語 EUC 亜種です。

G0 が US-ASCII、G1 が JIS X 0201 片仮名図形文字集合、G2 が JIS X 0208 + Windows の機種依存文字となっており、G3 は未割り当てになっています。

- **SEE** <https://web.archive.org/web/20140805164552/http://legacy-encoding.sourceforge.jp/wiki/index.php?cp51932>

### const CP50220 -> Encoding
CP50220 エンコーディング、
Windows で用いられる ISO-2022-JP 亜種です。

CP50221 とほぼ同様のエンコーディングですが、
他のエンコーディングへの変換テーブルが少し異なります。

- **SEE** <https://web.archive.org/web/20121217203947/http://legacy-encoding.sourceforge.jp/wiki/index.php?cp50220>


### const CP50221 -> Encoding
Windows で用いられる、ISO-2022-JP 亜種です。

ISO-2022-JP に加え、ESC ( I でいわゆる半角カナを許し、Windows の機種依存文字を扱うことができます。

- **SEE** <https://web.archive.org/web/20120708210705/http://legacy-encoding.sourceforge.jp/wiki/index.php?cp50221>


### const EUC_CN -> Encoding
### const EUCCN -> Encoding
### const EucCN -> Encoding
ENC-CN エンコーディングです。

中国で用いられる簡体字中国語 EUCのエンコーディングです。
GB2312 と呼ばれることも多いです。

### const EUC_KR -> Encoding
### const EUCKR -> Encoding
### const EucKR -> Encoding

EUC-KR エンコーディングです。

韓国語 EUC のエンコーディングです。

### const EUC_TW -> Encoding
### const EUCTW -> Encoding
### const EucTW -> Encoding

EUC-TW エンコーディングです。

台湾で用いられる繁体字中国語 EUCのエンコーディングです。

### const GB18030 -> Encoding
GBK エンコーディング

中国で用いられる中国語のエンコーディングです。

- **SEE** <http://www.iana.org/assignments/charset-reg/GB18030>

### const GB1988 -> Encoding

GB1988 エンコーディング。

ISO/IEC 646 の中国版です。

### const GBK -> Encoding
### const CP936 -> Encoding

GBK エンコーディング

中国で用いられる簡体字中国語のエンコーディングです。

- **SEE** <http://www.iana.org/assignments/character-sets>,
     <http://www.iana.org/assignments/charset-reg/GBK>,
     <https://web.archive.org/web/20090204133959/http://www.microsoft.com/globaldev/reference/dbcs/936.mspx>


#@# --- WINDOWS_936
#@# --- Windows_936

### const GB12345 -> Encoding

GB 12345 エンコーディング。

GB 2312 から派生したもので、繁体字中国語を取り扱うエンコーディングです。

### const IBM037       -> Encoding
### const EBCDIC_CP_US -> Encoding

IBM037 エンコーディング。

ダミーエンコーディングです。

- **SEE** <https://web.archive.org/web/20200728074824/https://en.wikipedia.org/wiki/EBCDIC_037>

### const IBM437 -> Encoding
### const CP437 -> Encoding

CP437 エンコーディング。

- **SEE** <https://en.wikipedia.org/wiki/Code_page_437>,
     [m:Encoding::CP869]

### const IBM720 -> Encoding
### const CP720 -> Encoding

CP720 エンコーディング。

アラビア語を取り扱う 8bit single-byteエンコーディングです。

- **SEE** <https://web.archive.org/web/20241210142608/https://en.wikipedia.org/wiki/Code_page_720>


### const IBM737 -> Encoding
### const CP737 -> Encoding

CP437 エンコーディング。

ギリシャ語を取り扱う 8bit single-byteエンコーディングです。

- **SEE** <https://en.wikipedia.org/wiki/Code_page_737>


### const IBM775 -> Encoding
### const CP775 -> Encoding
CP775 エンコーディング。

バルト語派の言語を扱うための 8bit single-byteエンコーディングです。

- **SEE** <https://web.archive.org/web/20241211190706/https://en.wikipedia.org/wiki/Code_page_775>

### const CP850 -> Encoding
### const IBM850 -> Encoding

CP850 エンコーディング。

- **SEE** <https://en.wikipedia.org/wiki/Code_page_850>

### const IBM852 -> Encoding
### const CP852 -> Encoding

CP852 エンコーディング。

ラテンアルファベットを用いる中欧の言語のための
8bit single-byte エンコーディングです。

- **SEE** <https://web.archive.org/web/20241211183546/https://en.wikipedia.org/wiki/Code_page_852>

### const IBM855 -> Encoding
### const CP855 -> Encoding

CP855 エンコーディング。

キリル文字を用いる言語のための
8bit single-byte エンコーディングです。

- **SEE** <https://web.archive.org/web/20241212170459/https://en.wikipedia.org/wiki/Code_page_855>

### const IBM857 -> Encoding
### const CP857 -> Encoding

CP857 エンコーディング。

トルコ語に用いられる、
8bit single-byte エンコーディングです。

- **SEE** <https://web.archive.org/web/20241211191514/https://en.wikipedia.org/wiki/Code_page_857>

### const IBM860 -> Encoding
### const CP860 -> Encoding

CP860 エンコーディング。

ポルトガル語に用いられる、
8bit single-byte エンコーディングです。

- **SEE** <https://web.archive.org/web/20241211183924/https://en.wikipedia.org/wiki/Code_page_860>


### const IBM861 -> Encoding
### const CP861 -> Encoding
CP861 エンコーディング。

アイスランド語に用いられる、
8bit single-byte エンコーディングです。

- **SEE** <https://en.wikipedia.org/wiki/Code_page_861>


### const IBM862 -> Encoding
### const CP862 -> Encoding
CP862 エンコーディング。

ヘブライ語に用いられる、
8bit single-byte エンコーディングです。

- **SEE** <https://en.wikipedia.org/wiki/Code_page_862>

### const IBM863 -> Encoding
### const CP863 -> Encoding
CP863 エンコーディング。

フランス語に用いられる、
8bit single-byte エンコーディングです。

- **SEE** <https://en.wikipedia.org/wiki/Code_page_863>

### const IBM864 -> Encoding
### const CP864 -> Encoding
CP864 エンコーディング。

アラビア語に用いられる、
8bit single-byte エンコーディングです。

- **SEE** <https://en.wikipedia.org/wiki/Code_page_864>


### const IBM865 -> Encoding
### const CP865 -> Encoding
CP865 エンコーディング。

北欧の諸言語に用いられる、
8bit single-byte エンコーディングです。

- **SEE** <https://en.wikipedia.org/wiki/Code_page_865>

### const IBM866 -> Encoding
### const CP866 -> Encoding
CP866 エンコーディング。

キリル文字を使う諸言語に用いられる、
8bit single-byte エンコーディングです。

- **SEE** <https://en.wikipedia.org/wiki/Code_page_866>

### const IBM869 -> Encoding
### const CP869 -> Encoding

CP869 エンコーディング。

ギリシャ語を取り扱う 8bit single-byteエンコーディングです。

- **SEE** <https://en.wikipedia.org/wiki/Code_page_869>,
     [m:Encoding::CP737]

### const CP949 -> Encoding

CP949 エンコーディング。

EUC-KR に近い、韓国語を取り扱う multi-byte エンコーディングです。

- **SEE** [m:Encoding::EUC_KR],
     <https://web.archive.org/web/20051112215943/http://www.microsoft.com/globaldev/reference/dbcs/949.mspx>,
     <https://en.wikipedia.org/wiki/EUC-KR#EUC-KR>

### const ISO_2022_JP_2 -> Encoding
### const ISO2022_JP2 -> Encoding

ISO-2022-JP-2 エンコーディングです。

ISO-2022-JP の拡張版です。

- **SEE** [m:Encoding::ISO_2022_JP]

### const ISO_8859_1 -> Encoding
### const ISO8859_1 -> Encoding

ISO-8859-1 エンコーディングです。

多くの西欧言語を含むさまざまなラテン文字言語を表現するための
8bitエンコーディングです。

Latin-1 とも呼ばれます。



### const ISO_8859_2 -> Encoding
### const ISO8859_2 -> Encoding

ISO8859-2 エンコーディング。

中東欧の言語を扱う 8bit single-byte エンコーディングです。



### const ISO_8859_3 -> Encoding
### const ISO8859_3 -> Encoding
ISO8859-3 エンコーディング。

トルコ語、マルタ語、エスペラントを扱う 8bit single-byte エンコーディングです。



### const ISO_8859_4 -> Encoding
### const ISO8859_4 -> Encoding

ISO 8859-4 エンコーディング。

北欧の言語を扱う 8bit single-byte エンコーディングです。



### const ISO_8859_5 -> Encoding
### const ISO8859_5 -> Encoding

ISO 8859-5 エンコーディング。

キリル文字を用いる言語を扱う 8bit single-byte エンコーディングです。



### const ISO_8859_6 -> Encoding
### const ISO8859_6 -> Encoding

ISO8859-6 エンコーディング。

アラビア文字を扱う 8bit single-byte エンコーディングです。

- **SEE** [m:Encoding::Windows_1256]



### const ISO_8859_7 -> Encoding
### const ISO8859_7 -> Encoding

ISO8859-7 エンコーディング。

ギリシャ語を扱う 8bit single-byte エンコーディングです。

- **SEE** [m:Encoding::Windows_1253]



### const ISO_8859_8 -> Encoding
### const ISO8859_8 -> Encoding
ISO8859-8 エンコーディング。

ヘブライ語を扱う 8bit single-byte エンコーディングです。

- **SEE** [m:Encoding::Windows_1255]



### const ISO_8859_9 -> Encoding
### const ISO8859_9 -> Encoding

ISO8859-9 エンコーディング。

ISO8859-1 に近い、
トルコ語を扱うことができる8bit single-byteエンコーディングです。

- **SEE** [m:Encoding::Windows_1254]



### const ISO_8859_10 -> Encoding
### const ISO8859_10 -> Encoding

ISO 8859-10 エンコーディング。

北欧の言語を扱う 8bit single-byte エンコーディングです。



### const ISO_8859_11 -> Encoding
### const ISO8859_11 -> Encoding

ISO8859-11 エンコーディング。

タイ語を扱う 8bit single-byte エンコーディングです。

- **SEE** [m:Encoding::TIS_620]



### const ISO_8859_13 -> Encoding
### const ISO8859_13 -> Encoding

ISO8859-13 エンコーディング。

バルト語派の言語を扱う8bit single-byteエンコーディングです。

- **SEE** [m:Encoding::Windows_1257]



### const ISO_8859_14 -> Encoding
### const ISO8859_14 -> Encoding

ISO8859-14 エンコーディング。

ケルト語派の言語を扱う8bit single-byteエンコーディングです。

- **SEE** [m:Encoding::Windows_1257]



### const ISO_8859_15 -> Encoding
### const ISO8859_15 -> Encoding

ISO 8859-15 エンコーディング。

ISO 8859-1 の改訂版です。


### const ISO_8859_16 -> Encoding
### const ISO8859_16 -> Encoding

ISO 8859-16 エンコーディング。

東欧を中心とした地域の諸語を扱う 8bit single-byte エンコーディングです。

### const KOI8_R -> Encoding
### const CP878 -> Encoding

KOI8-R エンコーディング。

ロシア語のキリル文字で使われる8bit single-byteエンコーディングです。

- **SEE** <https://en.wikipedia.org/wiki/KOI8-R>



### const KOI8_U -> Encoding

KOI8-U エンコーディング。

ウクライナ語のキリル文字で使われる8bit single-byteエンコーディングです。

- **SEE** <https://en.wikipedia.org/wiki/KOI8-U>



### const MacJapanese -> Encoding
### const MACJAPAN -> Encoding
### const MACJAPANESE -> Encoding
### const MacJapan -> Encoding

MacJapanese エンコーディング。

Mac OS の 9.x までで用いられていた Shift_JIS 亜種です。

- **SEE** <https://unicode.org/Public/MAPPINGS/VENDORS/APPLE/JAPANESE.TXT>,
     <https://ja.wikipedia.org/wiki/MacJapanese>


### const SJIS_DOCOMO -> Encoding
### const SJIS_DoCoMo -> Encoding

SJIS-DoCoMo エンコーディングです。

Shift_JIS, CP932 の亜種です。
DoCoMo の携帯電話で使われる絵文字が含まれています。

- **SEE** <https://www.nttdocomo.co.jp/english/service/developer/make/content/pictograph/basic/index.html>,
     <https://www.nttdocomo.co.jp/english/service/developer/make/content/pictograph/extention/index.html>


### const SJIS_KDDI -> Encoding

SJIS-KDDI エンコーディングです。

Shift_JIS, CP932 の亜種です。
KDDI の携帯電話で使われる絵文字が含まれています。

- **SEE** <https://web.archive.org/web/20251213064652/https://www.au.com/ezfactory/tec/spec/img/typeD.pdf>



### const SJIS_SOFTBANK -> Encoding
### const SJIS_SoftBank -> Encoding
SJIS-SoftBank エンコーディングです。

Shift_JIS, CP932 の亜種です。
SoftBank の携帯電話で使われる絵文字が含まれています。

- **SEE** <http://creation.mb.softbank.jp/mc/tech/tech_pic/pic_index.html>

### const UTF8_DOCOMO -> Encoding
### const UTF8_DoCoMo -> Encoding
UTF8-DoCoMo エンコーディングです。

UTF-8 の亜種です。
DoCoMo の携帯電話で使われる絵文字が含まれています。


- **SEE** <https://www.nttdocomo.co.jp/english/service/developer/make/content/pictograph/basic/index.html>,
     <https://www.nttdocomo.co.jp/english/service/developer/make/content/pictograph/extention/index.html>

### const UTF8_KDDI -> Encoding

UTF8-KDDI エンコーディングです。

UTF8 の亜種です。
KDDI の携帯電話で使われる絵文字が含まれています。

- **SEE** <https://web.archive.org/web/20251213064652/https://www.au.com/ezfactory/tec/spec/img/typeD.pdf>

### const UTF8_SOFTBANK -> Encoding
### const UTF8_SoftBank -> Encoding
UTF8-SoftBank エンコーディングです。

UTF-8 の亜種です。
SoftBank の携帯電話で使われる絵文字が含まれています。

- **SEE** <http://creation.mb.softbank.jp/mc/tech/tech_pic/pic_index.html>


### const STATELESS_ISO_2022_JP -> Encoding
### const Stateless_ISO_2022_JP -> Encoding
stateless-ISO-2022-JP エンコーディングです。

ISO-2022-JPをステートレスに扱うための方式です。
Emacs-Mule エンコーディングを元にしています。

### const ISO_2022_JP_KDDI -> Encoding
ISO-2022-JP-KDDI エンコーディングです。

ISO-2022-JP の亜種です。
KDDI の携帯電話で使われる絵文字が含まれています。


- **SEE** <https://web.archive.org/web/20251213064652/https://www.au.com/ezfactory/tec/spec/img/typeD.pdf>



### const STATELESS_ISO_2022_JP_KDDI -> Encoding
### const Stateless_ISO_2022_JP_KDDI -> Encoding
stateless-ISO-2022-JP-KDDI エンコーディングです。

stateless-ISO-2022-JP の亜種です。
KDDI の携帯電話で使われる絵文字が含まれています。


- **SEE** <https://web.archive.org/web/20251213064652/https://www.au.com/ezfactory/tec/spec/img/typeD.pdf>



### const TIS_620 -> Encoding
TIS-620 エンコーディング。

タイ語を扱うためのエンコーディングで、 ISO8859-11 とほぼ
同一のエンコーディングです。

- **SEE** <https://en.wikipedia.org/wiki/Thai_Industrial_Standard_620-2533>



### const Windows_1250 -> Encoding
### const CP1250 -> Encoding
### const WINDOWS_1250 -> Encoding

Windows-1250 エンコーディング。

ISO8859-2 の亜種です。

- **SEE** <https://web.archive.org/web/20060207020926/http://www.microsoft.com/globaldev/reference/sbcs/1250.mspx>,
     <https://en.wikipedia.org/wiki/Windows-1250>

### const Windows_1251 -> Encoding
### const CP1251 -> Encoding
### const WINDOWS_1251 -> Encoding

Windows-1251 エンコーディング。

キリル文字を用いる言語を取り扱う8bit single-byteエンコーディングです。

- **SEE** <http://www.iana.org/assignments/character-sets>,
     <https://web.archive.org/web/20090202093440/http://www.microsoft.com/globaldev/reference/sbcs/1251.mspx>,
     <https://en.wikipedia.org/wiki/Windows-1251>

### const Windows_1252 -> Encoding
### const CP1252 -> Encoding
### const WINDOWS_1252 -> Encoding

Windows-1252 エンコーディングです。

ISO8859-1 の亜種です。

- **SEE** [m:Encoding::ISO_8859_1]
     <http://www.iana.org/assignments/character-sets>,
     <https://web.archive.org/web/20090207073615/http://www.microsoft.com/globaldev/reference/sbcs/1252.mspx>,
     <https://en.wikipedia.org/wiki/Windows-1252>


### const Windows_1253 -> Encoding
### const CP1253 -> Encoding
### const WINDOWS_1253 -> Encoding

Windows-1253 エンコーディング。

ISO8859-7 の亜種です。

- **SEE** [m:Encoding::ISO_8859_7],
     <http://www.iana.org/assignments/character-sets>,
     <https://web.archive.org/web/20090203211641/http://www.microsoft.com/globaldev/reference/sbcs/1253.mspx>,
     <https://en.wikipedia.org/wiki/Windows-1253>

### const Windows_1254 -> Encoding
### const CP1254 -> Encoding
### const WINDOWS_1254 -> Encoding

Windows-1254 エンコーディング。

ISO8859-9 の亜種です。

- **SEE** [m:Encoding::ISO_8859_9],
     <http://www.iana.org/assignments/character-sets>,
     <https://web.archive.org/web/20060112032743/http://www.microsoft.com/globaldev/reference/sbcs/1254.mspx>,
     <https://en.wikipedia.org/wiki/Windows-1254>

### const Windows_1255 -> Encoding
### const CP1255 -> Encoding
### const WINDOWS_1255 -> Encoding

Windows-1255 エンコーディング。

ISO8859-8 の亜種です。

- **SEE** [m:Encoding::ISO_8859_8],
     <http://www.iana.org/assignments/character-sets>,
     <https://web.archive.org/web/20080103013634/http://www.microsoft.com/globaldev/reference/sbcs/1255.mspx>,
     <https://en.wikipedia.org/wiki/Windows-1255>


### const Windows_1256 -> Encoding
### const CP1256 -> Encoding
### const WINDOWS_1256 -> Encoding
Windows-1256 エンコーディング。

Windowsで用いられる、アラビア文字を扱う 8bit single-byte エンコーディングです。

- **SEE** [m:Encoding::ISO_8859_6],
     <http://www.iana.org/assignments/character-sets>,
     <https://web.archive.org/web/20050617022947/http://www.microsoft.com/globaldev/reference/sbcs/1256.mspx>,
     <https://en.wikipedia.org/wiki/Windows-1256>


### const Windows_1257 -> Encoding
### const CP1257 -> Encoding
### const WINDOWS_1257 -> Encoding
Windows-1257 エンコーディング。

ISO8859-13 の亜種です。

- **SEE** [m:Encoding::ISO8859_13],
     <http://www.iana.org/assignments/character-sets>,
     <https://web.archive.org/web/20081227100635/http://www.microsoft.com/globaldev/reference/sbcs/1257.mspx>,
     <https://en.wikipedia.org/wiki/Windows-1257>


### const Windows_1258 -> Encoding
### const CP1258 -> Encoding
### const WINDOWS_1258 -> Encoding

WINDOWS-1258 エンコーディング。

ベトナム語を扱う 8bit single-byteエンコーディングです。

- **SEE** <https://en.wikipedia.org/wiki/Windows-1258>

### const Windows_31J -> Encoding
### const CP932 -> Encoding
### const CSWINDOWS31J -> Encoding
### const CsWindows31J -> Encoding
### const WINDOWS_31J -> Encoding
### const PCK -> Encoding
### const SJIS -> Encoding

Windows-31J、Windows で用いられる、シフトJIS亜種で、CP932とも言います。

7bit 部分が論理的には US-ASCIIであり、また Windows の機種依存文字を扱うことができます。

- **SEE** <http://www2d.biglobe.ne.jp/~msyk/charcode/cp932/index.html>,
     <https://web.archive.org/web/20150327013846/http://legacy-encoding.sourceforge.jp/wiki/index.php?cp932>

### const Windows_874 -> Encoding
### const CP874 -> Encoding
### const WINDOWS_874 -> Encoding

Windows-874 エンコーディング。

タイ語を扱うエンコーディングで、ISO8859-11の亜種です。


- **SEE** [m:Encoding::TIS_620], [m:Encoding::ISO_8859_11],
     <https://web.archive.org/web/20050628002518/http://www.microsoft.com/globaldev/reference/sbcs/874.mspx>


### const EUCJP_MS -> Encoding
### const EucJP_ms -> Encoding
### const EUC_JP_MS -> Encoding
eucJP-ms、Unix 系で用いられる、日本語 EUC 亜種です。

EUC-JPに加え、Windowsの機種依存文字とユーザ定義文字を扱うことができます。
- **SEE** <http://www2d.biglobe.ne.jp/~msyk/charcode/cp932/eucJP-ms.html>,
     <https://web.archive.org/web/20150327034235/http://legacy-encoding.sourceforge.jp/wiki/index.php?eucJP-ms>,
     <http://blog.livedoor.jp/numa2666/archives/50980727.html>

### const MacCentEuro -> Encoding
### const MACCENTEURO -> Encoding
MacCentEuro エンコーディング。

Mac OSで使われる
8bit single-byteエンコーディングで、
中欧および南東欧の言語を取り扱うものです。

- **SEE** <https://en.wikipedia.org/wiki/Macintosh_Central_European_encoding>

### const MacCroatian -> Encoding
### const MACCROATIAN -> Encoding
MacCroatian エンコーディング。

Mac OS で使われる
8bit single-byteエンコーディングで、
クロアチア語、スベロニア語を取り扱うものです。

- **SEE** <https://www.unicode.org/Public/MAPPINGS/VENDORS/APPLE/CROATIAN.TXT>

### const MacCyrillic -> Encoding
### const MACCYRILLIC -> Encoding

MacCyrillic エンコーディング。

Mac OS で使われる 8bit single-byte エンコーディングで、
キリル文字を取り扱うものです。

- **SEE** <https://en.wikipedia.org/wiki/Macintosh_Cyrillic_encoding>

### const MacGreek -> Encoding
### const MACGREEK -> Encoding
MacGreek エンコーディング。

Mac OSで使われる
8bit single-byte エンコーディングで、
ギリシャ語のために使われます。

- **SEE** <https://www.unicode.org/Public/MAPPINGS/VENDORS/APPLE/GREEK.TXT>

### const MacIceland -> Encoding
### const MACICELAND -> Encoding

MacIceland エンコーディング。

Mac OSで使われる
8bit single-byte エンコーディングで、
アイスランド語のために使われます

- **SEE** <https://en.wikipedia.org/wiki/Mac_Icelandic_encoding>

### const MacRoman -> Encoding
### const MACROMAN -> Encoding
MacRoman エンコーディング。

Mac OSで使われる
8bit single-byte エンコーディングで、
西欧を中心としたラテン文字を用いる諸語を取り扱うためのものです。

IANA character-sets で "macintosh" で表現されるものです。

- **SEE** <https://en.wikipedia.org/wiki/Mac_OS_Roman>

### const MacRomania -> Encoding
### const MACROMANIA -> Encoding
MacRoman エンコーディング。

Mac OSで使われる
8bit single-byte エンコーディングで、
ルーマニア語のために使われます。

- **SEE** <https://www.unicode.org/Public/MAPPINGS/VENDORS/APPLE/ROMANIAN.TXT>

### const MacThai -> Encoding
### const MACTHAI -> Encoding
MacThai エンコーディング。

タイ語を扱うエンコーディングで、ISO8859-11の亜種です。

- **SEE** [m:Encoding::TIS_620], [m:Encoding::ISO_8859_11]

### const MacTurkish -> Encoding
### const MACTURKISH -> Encoding
MacTurkish エンコーディング。

Mac OSで使われる
8bit single-byte エンコーディングで、
トルコ語のために使われます。

- **SEE** <https://www.unicode.org/Public/MAPPINGS/VENDORS/APPLE/TURKISH.TXT>

### const MacUkraine -> Encoding
### const MACUKRAINE -> Encoding
MacUkraine エンコーディング。

Mac OS で使われる、ウクライナ語キリル文字を取り扱うエンコーディング。
MacCyrillic の亜種です。

- **SEE** <https://en.wikipedia.org/wiki/Macintosh_Ukrainian_encoding>

### const EMACS_MULE -> Encoding
### const Emacs_Mule -> Encoding

Emacs-Mule エンコーディングです。

Emacsの多言語化(Mule)で使われているステートレスのエンコーディングです。

- **SEE** <http://web.archive.org/web/20100714080650/http://www.m17n.org/mule/pricai96/mule.en.html>


# class EncodingError < StandardError
エンコーディング関連の例外の基底クラス。

# class Encoding::CompatibilityError < EncodingError
2つのエンコーディング間に互換性がない場合に発生する例外。

エンコーディングの異なる文字列を連結しようとした場合などに発生します。

```ruby title="例"
"あ".encode("EUC-JP") + "あ".encode("UTF-8")
# ~> Encoding::CompatibilityError: incompatible character encodings: EUC-JP and UTF-8
```

# class Encoding::UndefinedConversionError < EncodingError
エンコーディング変換後の文字が存在しない場合に発生する例外。

UTF-8 にしかない文字を EUC-JP に変換しようとした場合などに発生します。

```ruby title="例"
"\u2603".encode(Encoding::EUC_JP)
# ~> Encoding::UndefinedConversionError: U+2603 from UTF-8 to EUC-JP
```


変換が多段階でなされ、その途中で例外が生じた場合は、
例外オブジェクトが保持するエラー情報はその中間のものになります。

```ruby title="例"
ec = Encoding::Converter.new("ISO-8859-1", "EUC-JP")
# ISO-8859-1 -> UTF-8 -> EUC-JP
begin
  ec.convert("\xa0")
  # NO-BREAK SPACE, which is available in UTF-8 but not in EUC-JP.
rescue Encoding::UndefinedConversionError
  p $!.source_encoding              #=> #<Encoding:UTF-8>
  p $!.destination_encoding         #=> #<Encoding:EUC-JP>
  p $!.source_encoding_name         #=> "UTF-8"
  p $!.destination_encoding_name    #=> "EUC-JP"
  puts $!.error_char.dump   #=> "\u{a0}"
  p $!.error_char.encoding  #=> #<Encoding:UTF-8>
end
```


## Instance Methods
### def destination_encoding -> Encoding
エラーを発生させた変換の変換先のエンコーディングを [c:Encoding]
オブジェクトで返します。

- **SEE** [m:Encoding::UndefinedConversionError#source_encoding]

### def destination_encoding_name -> String
エラーを発生させた変換の変換先のエンコーディングを文字列で返します。

- **SEE** [m:Encoding::UndefinedConversionError#destination_encoding]

### def error_char -> String
エラーを発生させた1文字を文字列で返します。

```ruby title="例"
ec = Encoding::Converter.new("UTF-8", "EUC-JP")
begin
  ec.convert("\u{a0}")
rescue Encoding::UndefinedConversionError
  puts $!.error_char.dump   #=> "\u{a0}"
end
```

### def source_encoding -> Encoding
エラーを発生させた変換の変換元のエンコーディングを [c:Encoding]
オブジェクトで返します。

変換が多段階になされる場合は元の文字列のものではない
エンコーディングが返される場合があることに注意してください。

- **SEE** [m:Encoding::UndefinedConversionError#destination_encoding]

### def source_encoding_name -> Encoding
エラーを発生させた変換の変換元のエンコーディングを文字列で返します。

- **SEE** [m:Encoding::UndefinedConversionError#source_encoding]

# class Encoding::InvalidByteSequenceError < EncodingError
文字列がそのエンコーディングにおいて不正なバイト列である場合に発生
する例外。

通常エンコーディング変換時に発生します。

```ruby title="例"
p "\x82\xa0".force_encoding("cp932").encode("UTF-8")
#=> "あ"
"\x82\xa0".force_encoding("EUC-JP").encode("UTF-8")
# ~> Encoding::InvalidByteSequenceError: "\x82" on EUC-JP
```

## Instance Methods
### def destination_encoding -> Encoding
エラーを発生させた変換の変換先のエンコーディングを [c:Encoding]
オブジェクトで返します。

- **SEE** [m:Encoding::InvalidByteSequenceError#source_encoding],
     [m:Encoding::UndefinedConversionError#destination_encoding]

### def destination_encoding_name -> String
エラーを発生させた変換の変換先のエンコーディングを文字列で返します。

- **SEE** [m:Encoding::InvalidByteSequenceError#destination_encoding]

### def source_encoding -> Encoding
エラーを発生させた変換の変換元のエンコーディングを [c:Encoding]
オブジェクトで返します。

- **SEE** [m:Encoding::InvalidByteSequenceError#destination_encoding],
     [m:Encoding::UndefinedConversionError#source_encoding]

### def source_encoding_name -> Encoding
エラーを発生させた変換の変換元のエンコーディングを文字列で返します。

- **SEE** [m:Encoding::InvalidByteSequenceError#source_encoding]

### def error_bytes -> String
エラー発生時に捨てられたバイト列を返します。


```ruby title="例"
ec = Encoding::Converter.new("EUC-JP", "ISO-8859-1")
begin
  ec.convert("abc\xA1\xFFdef")
rescue Encoding::InvalidByteSequenceError
  p $!
  #=> #<Encoding::InvalidByteSequenceError: "\xA1" followed by "\xFF" on EUC-JP>
  puts $!.error_bytes.dump          #=> "\xA1"
  puts $!.readagain_bytes.dump      #=> "\xFF"
end
```

- **SEE** [m:Encoding::InvalidByteSequenceError#readagain_bytes]

### def readagain_bytes -> String
エラー発生時に読み直さなければならないバイト列を返します。

- **SEE** [m:Encoding::InvalidByteSequenceError#error_bytes]

### def incomplete_input? -> bool
エラー発生時に入力文字列が不足している場合に真を返します。

つまり、マルチバイト文字列の途中で文字列が終わっている場合に
真を返します。これは後続の入力を追加することでエラーが
解消する可能性があることを意味します。

```ruby title="例"
ec = Encoding::Converter.new("EUC-JP", "ISO-8859-1")

begin
  ec.convert("abc\xA1z")
rescue Encoding::InvalidByteSequenceError
  p $!
  #=> #<Encoding::InvalidByteSequenceError: "\xA1" followed by "z" on EUC-JP>
  p $!.incomplete_input?    #=> false
end

begin
  ec.convert("abc\xA1")
  ec.finish
rescue Encoding::InvalidByteSequenceError
  p $! #=> #<Encoding::InvalidByteSequenceError: incomplete "\xA1" on EUC-JP>
  p $!.incomplete_input?    #=> true
end
```

# class Encoding::ConverterNotFoundError < EncodingError
指定した名前のエンコーディング変換をする変換器が
存在しない場合に発生する例外。

```ruby title="例"
"あ".encode("Foo")
# ~> Encoding::ConverterNotFoundError: code converter not found (UTF-8 to Foo)
```

