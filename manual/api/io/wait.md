---
type: library
category: I/O
---
IOが読み込み可能になるまで待つ機能を提供するライブラリです。

#%until 4.0
Windowsではこのライブラリで定義されているメソッドは
Socketに対してしか利用できません。

#%end
#%since 3.2
[m:IO#wait]・[m:IO#wait_readable]・[m:IO#wait_writable]・[m:IO#wait_priority] は Ruby 3.2 で
[c:IO] 本体に移動したため、このライブラリを require しなくても使えます。
#%end
#%since 4.0
`IO#nread` と `IO#ready?` は io-wait 0.4.0(Ruby 4.0)で削除されました。
Ruby 4.0 以降ではこのライブラリは何も定義せず、互換性のために require できるだけです。
#%end
#%since 4.1
io-wait 1.0.0(Ruby 4.1)ではライブラリ自体が非推奨になり、require すると警告が出ます。
#%end

#%until 4.0
# reopen IO

## Instance Methods

### def nread -> Integer

ブロックせずに読み込み可能なバイト数を返します。
ブロックする場合は0を返します。

判別が不可能な場合は0を返します。

#%version 3.0
### def ready? -> IO | false | nil

ブロックせずに読み込み可能なら真を、
#%else
### def ready? -> bool | nil

ブロックせずに読み込み可能ならtrueを、
#%end
ブロックしてしまう可能性があるならfalseを返します。

判定不可能な場合は nil を返します。

#%until 3.2
### def wait(timeout = nil)          -> bool | self | nil
### def wait_readable(timeout = nil) -> bool | self | nil

self が読み込み可能になるまでブロックし、読み込み可能になったら真値を返します。タイムアウト、もしくはEOFでそれ以上読みこめない場合は偽の値を返します。

より詳しくは、一度ブロックしてから読み込み可能になった場合には
selfを返します。
内部のバッファにデータがある場合にはブロックせずに true を返します。
内部のバッファとはRubyの処理系が保持管理しているバッファのことです。

つまり、読み込み可能である場合にはtrueを返す場合と
selfを返す場合があることに注意してください。

timeout を指定した場合は、指定秒数経過するまでブロックし、タイムアウトした場合は nil を返します。

self が EOF に達していれば false を返します。

- **param** `timeout` -- タイムアウトまでの秒数を指定します。

- **SEE** [m:IO#wait_writable]

### def wait_writable          -> self
### def wait_writable(timeout) -> self | nil

self が書き込み可能になるまでブロックし、書き込み可能になったら self を返します。

timeout を指定した場合は、指定秒数経過するまでブロックし、タイムアウトした場合は nil を返します。

- **param** `timeout` -- タイムアウトまでの秒数を指定します。

- **SEE** [m:IO#wait_readable]

### def wait_priority(timeout = nil) -> bool | self | nil

self が優先データを受信して読み込み可能になるまでブロックし、読み込み可能になったら真値を返します。

優先データ(緊急データ)は [m:Socket::Constants::MSG_OOB] フラグを用いて送受信され、通常はストリーム型のソケットに限られます。

より詳しくは、一度ブロックしてから読み込み可能になった場合には
self を返します。
内部のバッファにデータがある場合にはブロックせずに true を返します。

timeout を指定した場合は、指定秒数経過するまでブロックし、タイムアウトした場合は nil を返します。

- **param** `timeout` -- タイムアウトまでの秒数を指定します。
             nil を指定すると読み込み可能になるまで待ち続けます。

- **SEE** [m:IO#wait_readable], [m:IO#wait_writable]
#%end
#%end
