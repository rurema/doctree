fcntl

Unix のシステムコール [[man:fcntl(2)]] (つまり
[[m:IO#fcntl]]) で使用できる定数 を集めたモジュールです。
定義される定数は以下の通りです

= module Fcntl

== Constants

--- F_DUPFD

--- F_GETFD

--- F_GETLK

--- F_SETFD

--- F_GETFL

--- F_SETFL

--- F_SETLK

--- F_SETLKW

--- FD_CLOEXEC

--- F_RDLCK

--- F_UNLCK

--- F_WRLCK

--- O_CREAT

--- O_EXCL

--- O_NOCTTY

--- O_TRUNC

--- O_APPEND

--- O_NONBLOCK

--- O_NDELAY

--- O_RDONLY

--- O_RDWR

--- O_WRONLY

#@if (version >= "1.8.1")
--- O_ACCMODE    version 1.8.1 以降

((<ruby 1.8 feature>))
#@end

