ファイルディスクリプタを扱う Unix のシステムコール [[m:IO#fcntl]] (つまり
[[man:fcntl(2)]]) で使用できる定数 を集めたモジュールです。
定義される定数は以下の通りです

= module Fcntl

ファイルディスクリプタを扱う Unix のシステムコール [[m:IO#fcntl]] (つまり
 [[man:fcntl(2)]]) で使用できる定数 を集めたモジュールです。
定義される定数は以下の通りです

== Constants

--- F_DUPFD
#@todo
duplicate a close-on-exec file handle to a non-close-on-exec
file handle.

--- F_GETFD
#@todo
read the close-on-exec flag of a file handle.

--- F_GETLK
#@todo
determine whether a given region of a file is locked.

--- F_SETFD
#@todo
set the close-on-exec flag of a file handle.

--- F_GETFL
#@todo
get file descriptor flags.

--- F_SETFL
#@todo
set file descriptor flags.

--- F_SETLK
#@todo
acquire a lock on a region of a file.

--- F_SETLKW
#@todo
acquire a lock on a region of a file, waiting if necessary.

--- FD_CLOEXEC
#@todo
the value of the close-on-exec flag.

--- F_RDLCK
#@todo

--- F_UNLCK
#@todo

--- F_WRLCK
#@todo

--- O_CREAT
#@todo
create file if it doesn't exist.

--- O_EXCL
#@todo
used with O_CREAT, fail if file exists.

--- O_NOCTTY
#@todo
open tty without it becoming controlling tty.

--- O_TRUNC
#@todo
truncate file on open.

--- O_APPEND
#@todo
open file in append mode.

--- O_NONBLOCK
--- O_NDELAY
#@todo
open in non-blocking mode.

--- O_RDONLY
#@todo
open read-only.

--- O_RDWR
#@todo
open read-write.

--- O_WRONLY
#@todo
open write-only.

#@since 1.8.1
--- O_ACCMODE
#@todo
mask to extract read/write flags.
#@end

