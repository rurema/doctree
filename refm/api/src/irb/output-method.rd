require e2mmap

irb が出力を扱うためのサブライブラリです。

= class IRB::OutputMethod

抽象的な出力を表すクラスです。ライブラリ内部で使用します。

== Instance Methods

--- print(*opts)

[[c:NotImplementedError]] が発生します。

@param objs 任意のオブジェクトを指定します。

@raise NotImplementedError 必ず発生します。

--- printn(*opts) -> nil

各 obj を self に出力し、最後に改行を出力します。

@param objs 任意のオブジェクトを指定します。

#@# parse_printf_format は  %%%%%I のような format にマッチする?
#@# また、%I を削らないと、printf が ArgumentError を raise するのでは?
#@# --- printf(format, *opts) -> nil
#@# --- parse_printf_format(format, opts) -> [String, Array]

--- puts(*objs) -> object

各 obj を self に出力し、それぞれの後に改行を出力します。

@param objs 任意のオブジェクトを指定します。

--- pp(*objs) -> object

各 obj を inspect した文字列を self に出力し、最後に改行を出力します。

@param objs 任意のオブジェクトを指定します。

--- ppx(prefix, *objs) -> object

引数 prefix + 各 obj を inspect した文字列を self に出力し、最後に改行
を出力します。

@param prefix 各 obj の先頭に追記する文字列を指定します。

@param objs 任意のオブジェクトを指定します。

#@# 使用されていない事、1.9.1 で削除されている事から省略しました。
#@# --- foo(format)

= class IRB::StdioOutputMethod < OutputMethod

標準出力を表すクラスです。ライブラリ内部で使用します。

== Instance Methods

--- print(*opts) -> nil

引数を標準出力に出力します。

@param objs 任意のオブジェクトを指定します。
