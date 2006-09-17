= class SystemCallError < StandardError

システムコールが失敗した時に発生する例外です。
実際には SystemCallError そのものではなく、
サブクラスである [[c:Errno]] モジュールの内部クラス
(各 errno と同じ名前) です。

システムに定義されていれば Errno には以下の例外クラスが定義されています。
個々の例外の意味はシステム依存です。
システムのマニュアル [[man:errno(3)]] を参照してください。

以下の一覧にはないシステムエラーが発生した場合は、
Errno::Exxx (xxx は、エラー番号を表す 3 桁の数字)
という名の例外クラスが作成されます。

: ERROR
    この例外クラスは ((<BeOS>)) の場合に限ります。
: EPERM
: ENOENT
: ESRCH
: EINTR
: EIO
: ENXIO
: E2BIG
: ENOEXEC
: EBADF
: ECHILD
: EAGAIN
: ENOMEM
: EACCES
: EFAULT
: ENOTBLK
: EBUSY
: EEXIST
: EXDEV
: ENODEV
: ENOTDIR
: EISDIR
: EINVAL
: ENFILE
: EMFILE
: ENOTTY
: ETXTBSY
: EFBIG
: ENOSPC
: ESPIPE
: EROFS
: EMLINK
: EPIPE
: EDOM
: ERANGE
: EDEADLK
: ENAMETOOLONG
: ENOLCK
: ENOSYS
: ENOTEMPTY
: ELOOP
: EWOULDBLOCK
: ENOMSG
: EIDRM
: ECHRNG
: EL2NSYNC
: EL3HLT
: EL3RST
: ELNRNG
: EUNATCH
: ENOCSI
: EL2HLT
: EBADE
: EBADR
: EXFULL
: ENOANO
: EBADRQC
: EBADSLT
: EDEADLOCK
: EBFONT
: ENOSTR
: ENODATA
: ETIME
: ENOSR
: ENONET
: ENOPKG
: EREMOTE
: ENOLINK
: EADV
: ESRMNT
: ECOMM
: EPROTO
: EMULTIHOP
: EDOTDOT
: EBADMSG
: EOVERFLOW
: ENOTUNIQ
: EBADFD
: EREMCHG
: ELIBACC
: ELIBBAD
: ELIBSCN
: ELIBMAX
: ELIBEXEC
: EILSEQ
: ERESTART
: ESTRPIPE
: EUSERS
: ENOTSOCK
: EDESTADDRREQ
: EMSGSIZE
: EPROTOTYPE
: ENOPROTOOPT
: EPROTONOSUPPORT
: ESOCKTNOSUPPORT
: EOPNOTSUPP
: EPFNOSUPPORT
: EAFNOSUPPORT
: EADDRINUSE
: EADDRNOTAVAIL
: ENETDOWN
: ENETUNREACH
: ENETRESET
: ECONNABORTED
: ECONNRESET
: ENOBUFS
: EISCONN
: ENOTCONN
: ESHUTDOWN
: ETOOMANYREFS
: ETIMEDOUT
: ECONNREFUSED
: EHOSTDOWN
: EHOSTUNREACH
: EALREADY
: EINPROGRESS
: ESTALE
: EUCLEAN
: ENOTNAM
: ENAVAIL
: EISNAM
: EREMOTEIO
: EDQUOT

== Class Methods

--- new(error_message)
#@if (version >= "1.8.0")
--- new(error_message, errno)
--- new(errno)

errno を指定しない一番目の形式では、SystemCallError オ
ブジェクトを生成して返します。それ以外では、整数 errno に該
当する[[c:Errno::EXXX]] オブジェクトを生成して返します。

例:

  p SystemCallError.new("message")
  p SystemCallError.new("message", 2)
  p SystemCallError.new(2)
  p SystemCallError.new(256)
  
  # => #<SystemCallError: unknown error - message>
       #<Errno::ENOENT: No such file or directory - message>
       #<Errno::ENOENT: No such file or directory>
       #<SystemCallError: Unknown error 256>
#@else
SystemCallError オブジェクトを生成して返します。
#@end

#@if (version >= "1.7.0")
--- ===(other)

other が SystemCallError のサブクラスであれば真です。
([[m:Module#===]] と同じ)。

また、左辺が SystemCallError のサブクラスである場合、
other.errno の値(nil ならば そのクラスの
[[unknown:Errno|Errno::EXXX/Errno]] 定数の値)が
self::Errno と同じ場合に真を返します。

このメソッドにより、システムによって errno が同じ値の例外に対して
以下の例のように捕捉できるようになっていました。

  p Errno::EAGAIN::Errno
  p Errno::EWOULDBLOCK::Errno
  begin
    raise Errno::EAGAIN, "pseudo error"
  rescue Errno::EWOULDBLOCK
    p $!
  end
  
  # => 11
       11
       #<Errno::EAGAIN: pseudo error>

現在、 SystemCallError#=== のこの特徴は特に意味がありません。
(以下のように同一のオブジェクトになっているからです)

  p Errno::EAGAIN
  p Errno::EWOULDBLOCK
  p Errno::EWOULDBLOCK.object_id
  p SystemCallError.new(11).class.object_id
  
  => Errno::EAGAIN
     Errno::EAGAIN
     537747360
     537747360
#@end

== Instance Methods

--- errno

システムから返された errno の値を返します。
実際にシステムコールエラーが発生してなければ nil を返します。

例:

二つ目の例のように raiseによって故意にエラーが発生しているかのように
見せかける場合は注意してください。

  begin
    open("nonexistent file")
  rescue Errno::ENOENT
    p Errno::ENOENT::Errno      # => 2
    p $!.errno                  # => 2
  end
  
  begin
    raise Errno::ENOENT
  rescue Errno::ENOENT
    p Errno::ENOENT::Errno      # => 2
    p $!.errno                  # => nil
  end

#@if (version >= "1.8.0")
Errno::EXXX 例外オブジェクトは対応する
errno 値を初期化時に設定するようになりました。

  begin
    raise Errno::ENOENT
  rescue Errno::ENOENT
    p Errno::ENOENT::Errno      # => 2
    p $!.errno                  # => 2
  end

発生してない例外に対応する errno の値を知りたい場合は
[[unknown:Errno::EXXX::Errno|Errno::EXXX/Errno]] 定数を使用してください。
#@end

== Constants

--- Errno

Errno::EXXX の各クラスに対応する errno の値です。

例:

    p Errno::EAGAIN::Errno            # => 11
    p Errno::EWOULDBLOCK::Errno       # => 11

#@if (version >= "1.8.0")
Errno::EXXX では対応する errno 値がオブジェクト生成時に設定されています。
#@else
Errno::EXXX::Errno 定数は、対応する値が常に設定されていますが、
[[m:SystemCallError#errno]] メソッドは実際にエラーが発生してなければ
nil を返します。
#@end

例:

    p Errno::EAGAIN::Errno            # => 11
    p Errno::EWOULDBLOCK::Errno       # => 11

#@if (version >= "1.8.0")
    p Errno::EAGAIN.new.errno         # => 11
    p Errno::EWOULDBLOCK.new.errno    # => 11
#@else
    p Errno::EAGAIN.new.errno         # => nil
    p Errno::EWOULDBLOCK.new.errno    # => nil
#@end



= module Errno

システムコールのエラーに対応する例外を集めたモジュールです。



= class Errno::EXXX < SystemCallError

see [[c:SystemCallError]]
