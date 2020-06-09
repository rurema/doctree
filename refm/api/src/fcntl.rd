category I/O

ファイルディスクリプタを扱う Unix のシステムコール [[m:IO#fcntl]] (つまり
[[man:fcntl(2)]]) で使用できる定数を集めたモジュールです。


例:
    require "fcntl"
    m = s.fcntl(Fcntl::F_GETFL, 0)
    f.fcntl(Fcntl::F_SETFL, Fcntl::O_NONBLOCK|m)
    
    require 'fcntl'
    
    fd = IO::sysopen('/tmp/tempfile', 
         Fcntl::O_WRONLY | Fcntl::O_EXCL | Fcntl::O_CREAT)
    f = IO.open(fd)
    f.syswrite("TEMP DATA")
    
    f.close

= module Fcntl

ファイルディスクリプタを扱う Unix のシステムコール [[m:IO#fcntl]]
(つまり[[man:fcntl(2)]]) で使用できる定数を集めたモジュールです。

@see [[man:fcntl(2)]], [[man:open(2)]], [[m:IO#fcntl]], [[m:IO.open]]

== Constants

--- F_DUPFD -> Integer
ファイルディスクリプタを複製します。

ただし、 close-on-exec はオフになります。

@see [[man:dup(2)]]

--- F_GETFD -> Integer
ファイルディスクリプタから close-on-exec フラグの値を読み出します。

--- F_GETLK -> Integer
与えられたファイルの範囲のロック状態を取得します。

--- F_SETFD -> Integer
ファイルディスクリプタに close-on-exec フラグの値を設定します。

--- F_GETFL -> Integer
ファイル状態フラグを読み出します。

@see [[man:open(2)]]

--- F_SETFL -> Integer
ファイル状態フラグを設定します。

@see [[man:open(2)]]

--- F_SETLK -> Integer
ファイルの範囲のロックを取得します。

--- F_SETLKW -> Integer
ファイルの範囲のロックを取得します。必要があればロックを取得できるまで待ちます。

--- FD_CLOEXEC -> Integer
close-on-exec フラグの値です。

--- F_RDLCK -> Integer
読み出しリースを取得します。

--- F_UNLCK -> Integer
そのファイルからリースを削除します。

--- F_WRLCK -> Integer
書き込みリースを取得します。

--- O_CREAT -> Integer
ファイルが存在しない場合にファイルを作成します。

--- O_EXCL -> Integer
ファイルが存在する場合に失敗します。[[m:Fcntl::O_CREAT]] と一緒に使用します。

--- O_NOCTTY -> Integer
開いたファイルが端末デバイスでも、制御端末にはなりません。

--- O_TRUNC -> Integer
ファイルを開くときに中身を切り捨てます。

--- O_APPEND -> Integer
ファイルを追記モードで開きます。

--- O_NONBLOCK -> Integer
--- O_NDELAY -> Integer
ファイルを non-blocking モードで開きます。

--- O_RDONLY -> Integer
ファイルを読み込み専用で開きます。

--- O_RDWR -> Integer
ファイルを読み書きできるように開きます。

--- O_WRONLY -> Integer
ファイルを書き込み専用で開きます。

--- O_ACCMODE -> Integer
ファイルアクセスモードのマスクです。

