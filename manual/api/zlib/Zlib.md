---
library: zlib
---
# module Zlib

zlib ライブラリに含まれている雑多な機能を提供するモジュール。
各モジュール関数の詳細は zlib.h を参照して下さい。

- **SEE** [man:zlib(3)]

## Module Functions

### module_function def zlib_version -> String

zlib ライブラリのバージョンを表す文字列を返します。

### module_function def adler32(string = nil, adler = nil) -> Integer
### module_function def adler32(io, adler = nil) -> Integer

string の Adler-32 チェックサムを計算し、adler を
更新した値を返します。string が省略された場合は
Adler-32 チェックサムの初期値を返します。adler が
省略された場合は adler に初期値が与えらたものとして
計算します。

- **param** `string` -- string の Adler-32 チェックサムが計算されます。
- **param** `io` -- IO が指定された場合は [m:IO#read] で nil を返すまで
       読み込んで、読み込んだデータ全体の Adler-32 チェックサムが
       計算されます。
- **param** `adler` --  adler を整数で指定します。

### module_function def crc32(string = nil, crc = nil) -> Integer
### module_function def crc32(io, crc = nil) -> Integer

string の CRC チェックサムを計算し、crc を
更新した値を返します。string が省略された場合は
CRC チェックサムの初期値を返します。crc が
省略された場合は crc に初期値が与えらたものとして
計算します。

- **param** `string` -- string の CRC チェックサムが計算されます。
- **param** `io` -- IO が指定された場合は [m:IO#read] で nil を返すまで
       読み込んで、読み込んだデータ全体の CRC チェックサムが
       計算されます。
- **param** `crc` --  crc を整数で指定します。

### module_function def crc_table -> Array

CRC チェックサムの計算に用いるテーブルを配列で返します。

#@since 1.9.2
### module_function def adler32_combine(adler1, adler2, length) -> Integer

与えられた二つの Adler-32 チェックサムを一つにつなげます。

- **param** `adler1` -- Adler-32 チェックサムを指定します。

- **param** `adler2` -- Adler-32 チェックサムを指定します。

- **param** `length` -- adler2 を生成するのに使用した文字列の長さを指定します。

### module_function def crc32_combine(crc1, crc2, length) -> Integer

与えられた二つの CRC-32 チェックサムを一つにつなげます。

- **param** `crc1` -- CRC-32 チェックサムを指定します。

- **param** `crc2` -- CRC-32 チェックサムを指定します。

- **param** `length` -- crc2 を生成するのに使用した文字列の長さを指定します。
#@end

#@since 1.9.3
### module_function def deflate(string, level = Zlib::DEFAULT_COMPRESSION ) -> String

引数 string を圧縮します。[m:Zlib::Deflate.deflate] と同じです。

- **param** `string` -- 圧縮する文字列を指定します。
- **param** `level` -- 圧縮の水準を詳細に指定します。
             有効な値は [m:Zlib::NO_COMPRESSION],
             [m:Zlib::BEST_SPEED], [m:Zlib::BEST_COMPRESSION],
             [m:Zlib::DEFAULT_COMPRESSION] 及び 0 から 9 の整数です。

- **SEE** [m:Zlib::Deflate.deflate]

### module_function def inflate(string) -> String

引数 string を展開します。[m:Zlib::Inflate.inflate] と同じです。

- **param** `string` -- 展開する文字列を指定します。

- **raise** `Zlib::NeedDict` -- 展開に辞書が必要な場合に発生します。

- **SEE** [m:Zlib::Inflate.inflate]
#@end

## Constants

### const VERSION -> String

Ruby/zlib のバージョンを表す文字列です。

### const ZLIB_VERSION -> String

zlib.h のバージョンを表す文字列です。

### const BINARY -> Integer

[m:Zlib::ZStream#data_type] の返す、データタイプを表す整数です。

### const ASCII -> Integer

[m:Zlib::ZStream#data_type] の返す、データタイプを表す整数です。

### const UNKNOWN -> Integer

[m:Zlib::ZStream#data_type] の返す、データタイプを表す整数です。

### const NO_COMPRESSION -> Integer

[m:Zlib::Deflate.new] や [m:Zlib::Deflate#deflate] 等に渡す、
圧縮レベルを表す整数です。

### const BEST_SPEED -> Integer

[m:Zlib::Deflate.new] や [m:Zlib::Deflate#deflate] 等に渡す、
圧縮レベルを表す整数です。

### const BEST_COMPRESSION -> Integer

[m:Zlib::Deflate.new] や [m:Zlib::Deflate#deflate] 等に渡す、
圧縮レベルを表す整数です。

### const DEFAULT_COMPRESSION -> Integer

[m:Zlib::Deflate.new] や [m:Zlib::Deflate#deflate] 等に渡す、
圧縮レベルを表す整数です。

### const FILTERED -> Integer

[m:Zlib::Deflate.new] や [m:Zlib::Deflate#params] に渡す、
圧縮方法を表す整数です。

### const HUFFMAN_ONLY -> Integer

[m:Zlib::Deflate.new] や [m:Zlib::Deflate#params] に渡す、
圧縮方法を表す整数です。

### const DEFAULT_STRATEGY -> Integer

[m:Zlib::Deflate.new] や [m:Zlib::Deflate#params] に渡す、
圧縮方法を表す整数です。

### const DEF_MEM_LEVEL -> Integer

[m:Zlib::Deflate.new] 等に渡す、memory level を表す整数です。

### const MAX_MEM_LEVEL -> Integer

[m:Zlib::Deflate.new] 等に渡す、memory level を表す整数です。

### const MAX_WBITS

[m:Zlib::Deflate.new] や [m:Zlib::Inflate.new] での
windowBits のデフォルト値です。

### const NO_FLUSH -> Integer

[m:Zlib::Deflate#deflate] 等に渡す、ストリームの出力を
制御するための整数です。

### const SYNC_FLUSH -> Integer

[m:Zlib::Deflate#deflate] 等に渡す、ストリームの出力を
制御するための整数です。

### const FULL_FLUSH -> Integer

[m:Zlib::Deflate#deflate] 等に渡す、ストリームの出力を
制御するための整数です。

### const FINISH -> Integer

[m:Zlib::Deflate#deflate] 等に渡す、ストリームの出力を
制御するための整数です。

### const OS_CODE -> Integer

[m:Zlib::GzipFile#os_code] メソッドの返す値です。

### const OS_MSDOS -> Integer

OS の種類を表す定数です。

### const OS_AMIGA -> Integer

OS の種類を表す定数です。

### const OS_VMS -> Integer

OS の種類を表す定数です。

### const OS_UNIX -> Integer

OS の種類を表す定数です。

### const OS_VMCMS -> Integer

OS の種類を表す定数です。

### const OS_ATARI -> Integer

OS の種類を表す定数です。

### const OS_OS2 -> Integer

OS の種類を表す定数です。

### const OS_MACOS -> Integer

OS の種類を表す定数です。

### const OS_ZSYSTEM -> Integer

OS の種類を表す定数です。

### const OS_CPM -> Integer

OS の種類を表す定数です。

### const OS_TOPS20 -> Integer

OS の種類を表す定数です。

### const OS_WIN32 -> Integer

OS の種類を表す定数です。

### const OS_QDOS -> Integer

OS の種類を表す定数です。

### const OS_RISCOS -> Integer

OS の種類を表す定数です。

### const OS_UNKNOWN -> Integer

OS の種類を表す定数です。

