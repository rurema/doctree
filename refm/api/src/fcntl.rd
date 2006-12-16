ファイルディスクリプタを扱う Unix のシステムコール [[m:IO#fcntl]] (つまり
[[man:fcntl(2)]]) で使用できる定数 を集めたモジュールです。
定義される定数は以下の通りです

= module Fcntl

ファイルディスクリプタを扱う Unix のシステムコール [[m:IO#fcntl]] (つまり
 [[man:fcntl(2)]]) で使用できる定数 を集めたモジュールです。
定義される定数は以下の通りです

== Constants

--- F_DUPFD
duplicate a close-on-exec file handle to a non-close-on-exec
file handle.

--- F_GETFD
read the close-on-exec flag of a file handle.

--- F_GETLK
determine whether a given region of a file is locked.

--- F_SETFD
set the close-on-exec flag of a file handle.

--- F_GETFL
get file descriptor flags.

--- F_SETFL
set file descriptor flags.

--- F_SETLK
acquire a lock on a region of a file.

--- F_SETLKW
acquire a lock on a region of a file, waiting if necessary.

--- FD_CLOEXEC
the value of the close-on-exec flag.

--- F_RDLCK

--- F_UNLCK

--- F_WRLCK

--- O_CREAT
create file if it doesn't exist.

--- O_EXCL
used with O_CREAT, fail if file exists.

--- O_NOCTTY
open tty without it becoming controlling tty.

--- O_TRUNC
truncate file on open.

--- O_APPEND
open file in append mode.

--- O_NONBLOCK
--- O_NDELAY
open in non-blocking mode.

--- O_RDONLY
open read-only.

--- O_RDWR
open read-write.

--- O_WRONLY
open write-only.

#@since 1.8.1
--- O_ACCMODE
mask to extract read/write flags.
#@end

