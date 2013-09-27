category I/O

IOが読み込み可能になるまで待つ機能を提供するライブラリです。

Windowsではこのライブラリで定義されているメソッドは
Socketに対してしか利用できません。

= reopen IO

== Instance Methods

#@since 1.9.1
--- nread -> Integer
ブロックせずに読み込み可能なバイト数を返します。
ブロックする場合は0を返します。

判別が不可能な場合は0を返します。
#@end



#@until 1.9.1
--- ready? -> Integer | false | nil

ブロックせずに読み込み可能なら真を、
不可能であれば偽を返します。

より正確には、
ブロックせずに読み込み可能ならそのバイト数を返します。
内部のバッファにデータがある場合にはtrueを返します。
self が EOF に達していれば false を返します。
判定不可能な場合には false を返します。
ブロックせずに読み込み可能な
データが存在しない場合には nil を返します。
#@else
--- ready? -> bool | nil
ブロックせずに読み込み可能ならtrueを、
ブロックしてしまう可能性があるならfalseを返します。

判定不可能な場合は nil を返します。
#@end

--- wait(timeout = nil)          -> bool | self | nil
#@since 2.0.0
--- wait_readable(timeout = nil) -> bool | self | nil
#@end

self が読み込み可能になるまでブロックし、読み込み可能になったら
真値を返します。タイムアウト、もしくはEOFで
それ以上読みこめない場合は偽の値を返します。

より詳しくは、一度ブロックしてから読み込み可能になった場合には
selfを返します。
内部のバッファにデータがある場合には
ブロックせずに true を返します。
#@until 1.9.1
内部のバッファとはCランタイムのFILE構造体内部の
バッファのことです。
#@else
内部のバッファとはRubyの処理系が保持管理している
バッファのことです。
#@end

つまり、読み込み可能である場合にはtrueを返す場合と
selfを返す場合があることに注意してください。

timeout を指定した場合は、指定秒数経過するまでブロックし、タ
イムアウトした場合は nil を返します。

self が EOF に達していれば false を返します。

@param timeout タイムアウトまでの秒数を指定します。

#@since 2.0.0

@see [[m:IO#wait_writable]]

--- wait_writable          -> self
--- wait_writable(timeout) -> self | nil

self が書き込み可能になるまでブロックし、書き込み可能になったら self を
返します。

timeout を指定した場合は、指定秒数経過するまでブロックし、タイムアウト
した場合は nil を返します。

@param timeout タイムアウトまでの秒数を指定します。

@see [[m:IO#wait_readable]]
#@end
