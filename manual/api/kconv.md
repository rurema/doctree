---
type: library
category: CharacterEncoding
require:
  - nkf
---
日本語文字コードの変換を手軽に行うためのライブラリです。

kconv を require すると [c:String] クラスに変換用のメソッドが定義されます。
[c:Kconv] にも同等のメソッドが定義されます。 [c:Kconv] には
エンコーディングを表す定数も定義されています。

#@since 1.9.1
1.9.1 以降では、Ruby の m17n 機能を用いてエンコーディングの変換を
行うことができます。1.8 との互換性が問題でないのならば、
m17n 機能を使うほうがよいでしょう。MIMEのデコード等面倒な問題を
避けることができます。
#@end

### 使用例

```ruby
require 'kconv'
newstring = Kconv.kconv(string, Kconv::JIS, Kconv::AUTO)
newstring = Kconv.tojis(string)
newstring = Kconv.toeuc(string)
newstring = Kconv.tosjis(string)
guessed_code = Kconv.guess(string)
```

または

```ruby
require 'kconv'
newstring = string.kconv(Kconv::JIS, Kconv::AUTO)
newstring = string.tojis
newstring = string.toeuc
newstring = string.tosjis
```


# reopen String

## Instance Methods

### def kconv(out_code, in_code = Kconv::AUTO) -> String

self のエンコーディングを out_code に変換した文字列を
返します。
out_code in_code は [c:Kconv] の定数で指定します。

このメソッドは MIME エンコードされた文字列を展開し、
いわゆる半角カナを全角に変換します。
これらを変換したくない場合は、 [m:NKF?.nkf] を使ってください。

- **param** `out_code` -- 変換後のエンコーディングを [c:Kconv] の定数で指定します。
- **param** `in_code` -- 変換する文字列のエンコーディングを [c:Kconv] の定数で指定します。

- **SEE** [m:Kconv?.kconv]

### def tojis -> String

self のエンコーディングを iso-2022-jp に変換した文字列を
返します。変換元のエンコーディングは文字列の内容から推測します。

このメソッドは MIME エンコードされた文字列を展開し、
いわゆる半角カナを全角に変換します。
これらを変換したくない場合は、 [m:NKF?.nkf]('-jxm0', str)
を使ってください。

- **SEE** [m:Kconv?.tojis]
### def toeuc -> String

self のエンコーディングを EUC-JP に変換した文字列を
返します。変換元のエンコーディングは文字列の内容から推測します。

このメソッドは MIME エンコードされた文字列を展開し、
いわゆる半角カナを全角に変換します。
これらを変換したくない場合は、 [m:NKF?.nkf]('-exm0', str)
を使ってください。

- **SEE** [m:Kconv?.toeuc]
### def tosjis -> String

self のエンコーディングを shift_jis に変換した文字列を
返します。変換元のエンコーディングは文字列の内容から推測します。

このメソッドは MIME エンコードされた文字列を展開し、
いわゆる半角カナを全角に変換します。
これらを変換したくない場合は、 [m:NKF?.nkf]('-sxm0', str)
を使ってください。

- **SEE** [m:Kconv?.tosjis]

### def toutf8 -> String

self のエンコーディングを UTF-8 に変換した文字列を
返します。変換元のエンコーディングは文字列の内容から推測します。

このメソッドは MIME エンコードされた文字列を展開し、
いわゆる半角カナを全角に変換します。
これらを変換したくない場合は、 [m:NKF?.nkf]('-wxm0', str)
を使ってください。

- **SEE** [m:Kconv?.toutf8]

### def toutf16 -> String

self のエンコーディングを UTF-16BE に変換した文字列を
返します。変換元のエンコーディングは文字列の内容から推測します。

このメソッドは MIME エンコードされた文字列を展開し、
いわゆる半角カナを全角に変換します。
これらを変換したくない場合は、 [m:NKF?.nkf]('-w16xm0', str)
を使ってください。

- **SEE** [m:Kconv?.toutf16]


#@since 1.9.1
### def toutf32 -> String

self のエンコーディングを UTF-32 に変換した文字列を
返します。変換元のエンコーディングは文字列の内容から推測します。

このメソッドは MIME エンコードされた文字列を展開し、
いわゆる半角カナを全角に変換します。
これらを変換したくない場合は、 [m:NKF?.nkf]('-w32xm0', str)
を使ってください。

- **SEE** [m:Kconv?.toutf32]

### def tolocale -> String
self のエンコーディングをロケールエンコーディングに変換した文字列を
返します。変換元のエンコーディングは文字列の内容から推測します。

ロケールエンコーディングについては [m:Encoding.locale_charmap] を見てください。

このメソッドは MIME エンコードされた文字列を展開し、
いわゆる半角カナを全角に変換します。
これらを変換したくない場合は、 [m:String#encode]
を使ってください。

- **SEE** [m:Kconv?.tolocale]


#@end

### def iseuc -> bool

self が EUC-JP なバイト列として正当であるかどうかを判定します。

[m:Kconv?.iseuc](self) と同じです。

```ruby title="例"
require 'kconv'

euc_str = "\
\xa5\xaa\xa5\xd6\xa5\xb8\xa5\xa7\xa5\xaf\xa5\xc8\xbb\xd8\xb8\xfe\
\xa5\xd7\xa5\xed\xa5\xb0\xa5\xe9\xa5\xdf\xa5\xf3\xa5\xb0\xb8\xc0\xb8\xec\
\x52\x75\x62\x79".force_encoding('EUC-JP')

sjis_str = "\
\x83\x49\x83\x75\x83\x57\x83\x46\x83\x4e\x83\x67\x8e\x77\x8c\xfc\
\x83\x76\x83\x8d\x83\x4f\x83\x89\x83\x7e\x83\x93\x83\x4f\x8c\xbe\x8c\xea\
\x52\x75\x62\x79".force_encoding('Shift_JIS')

p euc_str.iseuc  # => true
p sjis_str.iseuc # => false
```


### def issjis -> bool

self が Shift_JIS なバイト列として正当であるかどうかを判定します。


[m:Kconv?.issjis] と同じです。


### def isutf8 -> bool

self が UTF-8 なバイト列として正当であるかどうかを判定します。

[m:Kconv?.isutf8](self) と同じです。

#@since 1.9.1
### def isjis -> bool

self が ISO-2022-JP なバイト列として正当であるかどうかを判定します。

Kconv.isjis(self) と同じです。

#@end
# module Kconv

文字コードエンコーディングを変換するためのモジュール。
[c:Kconv] は [lib:nkf] のラッパーです。

#@#[[trap:Kconv]]

## Module Functions

### module_function def kconv(str, out_code, in_code = Kconv::AUTO) -> String

文字列 str のエンコーディングを out_code に変換したものを
返します。in_code も指定されていたら str のエンコーディングが
in_code だとして動作します。

このメソッドはMIME エンコードされた文字列を展開し、
いわゆる半角カナを全角に変換します。
これらを変換したくない場合は、 [m:NKF?.nkf] を使ってください。

- **param** `str` -- 変換元の文字列
- **param** `out_code` -- 変換後のエンコーディング
- **param** `in_code` -- strのエンコーディング

- **SEE** [m:String#kconv]

### module_function def tojis(str) -> String

文字列 str のエンコーディングを iso-2022-jp に変換して返します。

Kconv.kconv(str, Kconv::JIS) と同じです。

このメソッドは MIME エンコードされた文字列を展開し、
いわゆる半角カナを全角に変換します。
これらを変換したくない場合は、 [m:NKF?.nkf]('-jxm0', str)
を使ってください。

- **param** `str` -- 変換元の文字列

- **SEE** [m:Kconv?.kconv], [m:String#tojis]
### module_function def toeuc(str) -> String

文字列 str のエンコーディングを EUC-JP に変換して返します。

Kconv.kconv(str, Kconv::EUC)と同じです。

このメソッドは MIME エンコードされた文字列を展開し、
いわゆる半角カナを全角に変換します。
これらを変換したくない場合は、 [m:NKF?.nkf]('-exm0', str)
を使ってください。

- **param** `str` -- 変換元の文字列

- **SEE** [m:Kconv?.kconv], [m:String#toeuc]

### module_function def tosjis(str) -> String

文字列 str のエンコーディングを shift_jis に変換して返します。

このメソッドは MIME エンコードされた文字列を展開し、
いわゆる半角カナを全角に変換します。
これらを変換したくない場合は、 [m:NKF?.nkf]('-sxm0', str)
を使ってください。

Kconv.kconv(str, Kconv::SJIS)と同じです。

- **param** `str` -- 変換元の文字列

- **SEE** [m:Kconv?.kconv], [m:String#tosjis]

#@until 1.9.1
### module_function def guess(str) -> Integer
#@else
### module_function def guess(str) -> Encoding
#@end

文字列 str のエンコーディングを判定します。戻り値は
Kconv の定数です。

このモジュール関数で判定できるのは、
  - ISO-2022-JP ([m:Kconv::JIS])
  - Shift_JIS ([m:Kconv::SJIS])
  - EUC-JP ([m:Kconv::EUC])
  - ASCII ([m:Kconv::ASCII])
  - UTF-8 ([m:Kconv::UTF8])
  - UTF-16BE ([m:Kconv::UTF16])
  - 不明 ([m:Kconv::UNKNOWN])
  - 以上のどれでもない ([m:Kconv::BINARY])
のいずれかです。

- **param** `str` -- エンコーディング判定対象の文字列

#@until 1.9.1
### module_function def guess_old(str) -> Integer
文字列 str のエンコーディングを判定します。戻り値は
Kconv の定数です。

このモジュール関数で判定できるのは、
  - ISO-2022-JP ([m:Kconv::JIS])
  - Shift_JIS ([m:Kconv::SJIS])
  - EUC-JP ([m:Kconv::EUC])
  - 不明 ([m:Kconv::UNKNOWN])
  - 以上のどれでもない ([m:Kconv::BINARY])
のいずれかです。

- **param** `str` -- エンコーディング判定対象の文字列
- **SEE** [m:Kconv?.guess]
#@end

### module_function def toutf8(str) -> String

文字列 str のエンコーディングを UTF-8 に変換して返します。

このメソッドは MIME エンコードされた文字列を展開し、
いわゆる半角カナを全角に変換します。
これらを変換したくない場合は、 [m:NKF?.nkf]('-wxm0', str)
を使ってください。

Kconv.kconv(str, Kconv::UTF8)と同じです。

- **param** `str` -- 変換元の文字列
- **SEE** [m:String#toutf8]


### module_function def toutf16(str) -> String

文字列 str のエンコーディングを UTF-16BE に変換して返します。

このメソッドは MIME エンコードされた文字列を展開し、
いわゆる半角カナを全角に変換します。
これらを変換したくない場合は、 [m:NKF?.nkf]('-w16xm0', str)
を使ってください。

Kconv.kconv(str, Kconv::UTF16)と同じです。

- **param** `str` -- 変換元の文字列
- **SEE** [m:String#toutf16]


#@since 1.9.1
### module_function def toutf32(str) -> String

文字列 str のエンコーディングを UTF-32 に変換して返します。

このメソッドは MIME エンコードされた文字列を展開し、
いわゆる半角カナを全角に変換します。
これらを変換したくない場合は、 [m:NKF?.nkf]('-w32xm0', str)
を使ってください。

Kconv.kconv(str, Kconv::UTF32)と同じです。

- **param** `str` -- 変換元の文字列
- **SEE** [m:String#toutf32]

#@end

#@since 1.9.1
### module_function def tolocale(str) -> String

文字列 str のエンコーディングをロケールエンコーディングに変換して返します。

ロケールエンコーディングについては [m:Encoding.locale_charmap] を見てください。

このメソッドは MIME エンコードされた文字列を展開し、
いわゆる半角カナを全角に変換します。
これらを変換したくない場合は、 [m:String#encode]
を使ってください。

Kconv.kconv(str, Encoding.locale_charmap)と同じです。

- **param** `str` -- 変換元の文字列
- **SEE** [m:String#tolocale]

#@end

### module_function def iseuc(str) -> bool
文字列 str が EUC-JP なバイト列として正当であるかどうかを判定します。

- **param** `str` -- 判定対象の文字列
- **SEE** [m:String#iseuc]


### module_function def issjis(str) -> bool
文字列 str が Shift_JIS なバイト列として正当であるかどうかを判定します。

- **param** `str` -- 判定対象の文字列
- **SEE** [m:String#issjis]


### module_function def isutf8(str) -> bool
文字列 str が UTF-8 なバイト列として正当であるかどうかを判定します。

- **param** `str` -- 判定対象の文字列
- **SEE** [m:String#isutf8]

#@since 1.9.1
### module_function def isjis(str) -> bool
文字列 str が ISO-2022-JP なバイト列として正当であるかどうかを判定します。

- **param** `str` -- 判定対象の文字列
- **SEE** [m:String#isjis]

```ruby title="例"
require 'kconv'

euc_str = "\
\xa5\xaa\xa5\xd6\xa5\xb8\xa5\xa7\xa5\xaf\xa5\xc8\xbb\xd8\xb8\xfe\
\xa5\xd7\xa5\xed\xa5\xb0\xa5\xe9\xa5\xdf\xa5\xf3\xa5\xb0\xb8\xc0\xb8\xec\
\x52\x75\x62\x79".force_encoding('EUC-JP')

jis_str = "\
\x1b\x24\x42\x25\x2a\x25\x56\x25\x38\x25\x27\x25\x2f\x25\x48\x3b\x58\x38\x7e\
\x25\x57\x25\x6d\x25\x30\x25\x69\x25\x5f\x25\x73\x25\x30\x38\x40\x38\x6c\x1b\x28\x42\
\x52\x75\x62\x79".force_encoding('ISO-2022-JP')

p euc_str.isjis  # => false
p jis_str.isjis  # => true
```

#@end
## Constants

#@until 1.9.1
### const AUTO -> Integer
#@else
### const AUTO -> nil
#@end

エンコーディングを自動検出します。
入力の指定でのみ有効です。

#@until 1.9.1
### const JIS -> Integer
#@else
### const JIS -> Encoding
#@end

ISO-2022-JP を表します。

#@until 1.9.1
### const EUC -> Integer
#@else
### const EUC -> Encoding
#@end

EUC-JP を表します。

#@until 1.9.1
### const SJIS -> Integer
#@else
### const SJIS -> Encoding
#@end

Shift_JIS を表します。
cp932ではないことに注意してください。

#@until 1.9.1
### const BINARY -> Integer
#@else
### const BINARY -> Encoding
#@end

JIS EUC SJIS 以外を表します。
この値は[m:Kconv?.guess]の返り値としてのみ用いられます。

#@until 1.9.1
### const UNKNOWN -> Integer
#@else
### const UNKNOWN -> nil
#@end

出力においては「エンコーディングを判定できなかった」
入力においては AUTO と同様に「自動検出」を表します。

#@until 1.9.1
### const NOCONV -> Integer
#@else
### const NOCONV -> nil
#@end

変換されないことを表します。
出力エンコーディングの指定にのみ用います。

#@until 1.9.1
### const ASCII -> Integer
#@else
### const ASCII -> Encoding
#@end

ASCII を表します。

#@until 1.9.1
### const UTF8 -> Integer
#@else
### const UTF8 -> Encoding
#@end

UTF8 を表します。

#@until 1.9.1
### const UTF16 -> Integer
#@else
### const UTF16 -> Encoding
#@end

UTF16 を表します。

#@until 1.9.1
### const UTF32 -> Integer
#@else
### const UTF32 -> Encoding
#@end

UTF32 を表します。

#@until 1.9.1
### const RegexpShiftjis -> Regexp
この定数は使うべきではありません。

### const RegexpEucjp -> Regexp
この定数は使うべきではありません。

### const RegexpUtf8 -> Regexp
この定数は使うべきではありません。
#@end

#@until 1.9.1
### const REVISION -> String
この定数は使うべきではありません。
#@end
