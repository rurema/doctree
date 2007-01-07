= class SystemCallError < StandardError

システムコールが失敗した時に発生する例外です。
実際には SystemCallError そのものではなく、
サブクラスである [[c:Errno::EXXX]] (XXX は errno 定数と同じ名前) が発生します。
詳しくは [[c:Errno::EXXX]] を参照してください。



== Class Methods

--- new(error_message)

SystemCallError オブジェクトを生成して返します。

例:

  p SystemCallError.new("message")
      # => #<SystemCallError: unknown error - message>

--- new(error_message, errno)
--- new(errno)

整数 errno に対応する [[c:Errno::EXXX]] オブジェクトを生成して返します。

例:

  p SystemCallError.new("message", 2)
      # => #<Errno::ENOENT: No such file or directory - message>
  p SystemCallError.new(2)
      # => #<Errno::ENOENT: No such file or directory>
  p SystemCallError.new(256)
      # => #<SystemCallError: Unknown error 256>



= module Errno

システムコールのエラーに対応する例外を集めたモジュールです。



= class Errno::EXXX < SystemCallError

システムの errno 値に対応するクラスです。
システムコールが失敗したときに発生します。

実際には「EXXX」というクラスが定義されているわけではなく、
以下に述べる各種の EXXX クラスが定義されます。

Ruby はデフォルトで以下のような Errno::EXXX クラスを定義しようとします。
Errno::EXXX クラスは、対応する errno がシステムに存在する場合のみ定義されます。
また、以下の一覧にはないシステムエラーが発生した場合は、
[[c:Errno::EXXX]] (XXX はエラー番号を表す 3 桁の数字)
という名前の例外クラスが自動的に作成され、発生します。

  * ERROR
  * EPERM
  * ENOENT
  * ESRCH
  * EINTR
  * EIO
  * ENXIO
  * E2BIG
  * ENOEXEC
  * EBADF
  * ECHILD
  * EAGAIN
  * ENOMEM
  * EACCES
  * EFAULT
  * ENOTBLK
  * EBUSY
  * EEXIST
  * EXDEV
  * ENODEV
  * ENOTDIR
  * EISDIR
  * EINVAL
  * ENFILE
  * EMFILE
  * ENOTTY
  * ETXTBSY
  * EFBIG
  * ENOSPC
  * ESPIPE
  * EROFS
  * EMLINK
  * EPIPE
  * EDOM
  * ERANGE
  * EDEADLK
  * ENAMETOOLONG
  * ENOLCK
  * ENOSYS
  * ENOTEMPTY
  * ELOOP
  * EWOULDBLOCK
  * ENOMSG
  * EIDRM
  * ECHRNG
  * EL2NSYNC
  * EL3HLT
  * EL3RST
  * ELNRNG
  * EUNATCH
  * ENOCSI
  * EL2HLT
  * EBADE
  * EBADR
  * EXFULL
  * ENOANO
  * EBADRQC
  * EBADSLT
  * EDEADLOCK
  * EBFONT
  * ENOSTR
  * ENODATA
  * ETIME
  * ENOSR
  * ENONET
  * ENOPKG
  * EREMOTE
  * ENOLINK
  * EADV
  * ESRMNT
  * ECOMM
  * EPROTO
  * EMULTIHOP
  * EDOTDOT
  * EBADMSG
  * EOVERFLOW
  * ENOTUNIQ
  * EBADFD
  * EREMCHG
  * ELIBACC
  * ELIBBAD
  * ELIBSCN
  * ELIBMAX
  * ELIBEXEC
  * EILSEQ
  * ERESTART
  * ESTRPIPE
  * EUSERS
  * ENOTSOCK
  * EDESTADDRREQ
  * EMSGSIZE
  * EPROTOTYPE
  * ENOPROTOOPT
  * EPROTONOSUPPORT
  * ESOCKTNOSUPPORT
  * EOPNOTSUPP
  * EPFNOSUPPORT
  * EAFNOSUPPORT
  * EADDRINUSE
  * EADDRNOTAVAIL
  * ENETDOWN
  * ENETUNREACH
  * ENETRESET
  * ECONNABORTED
  * ECONNRESET
  * ENOBUFS
  * EISCONN
  * ENOTCONN
  * ESHUTDOWN
  * ETOOMANYREFS
  * ETIMEDOUT
  * ECONNREFUSED
  * EHOSTDOWN
  * EHOSTUNREACH
  * EALREADY
  * EINPROGRESS
  * ESTALE
  * EUCLEAN
  * ENOTNAM
  * ENAVAIL
  * EISNAM
  * EREMOTEIO
  * EDQUOT

個々の例外の意味はシステム依存です。
システムのマニュアル [[man:errno(3)]] を参照してください。

== Instance Methods

--- errno

各エラーに対応する errno 値を返します。

  begin
    raise Errno::ENOENT
  rescue Errno::ENOENT => err
    p err.errno                 # => 2
    p Errno::ENOENT::Errno      # => 2
  end

なお、例外を発生させずに errno 値を得るには、
[[m:Errno::EXXX::Errno]] 定数を使います。

#@since 1.8.0
--- ===(other)

other が SystemCallError のサブクラスで、
かつ、other.errno の値が self.errno と同じ場合に真を返します。

現在は同じ errno 値を持つクラスは一つしか作られないようになったので、
このメソッドは意味がありません。
#@end

== Constants

--- Errno

Errno::EXXX の各クラスに対応する errno の値です。

例:

    p Errno::EAGAIN::Errno            # => 11
    p Errno::EWOULDBLOCK::Errno       # => 11

