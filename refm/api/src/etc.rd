category Unix

/etc に存在するデータベースから情報を得るためのモジュールです。
クラスにインクルードして使うこともできます。

=== 使い方

  require 'etc'
  p Etc.getlogin

= module Etc

/etc に存在するデータベースから情報を得るためのモジュールです。
クラスにインクルードして使うこともできます。

== Module Functions

#@since 1.8.1
--- getgrent -> Struct::Group | nil

/etc/group ファイルから読み込んだエントリを一つ返します。

最初の呼び出しでは、先頭のエントリを返します。それ以降の呼び出しでは、
呼び出す度に次のエントリを順に返します。ファイルの終端に達すると nil を返します。

処理が終了したときは [[m:Etc.#endgrent]] を呼び出すようにしてください。

@see [[man:getgrent(3)]], [[c:Struct::Group]]

--- endgrent -> nil

[[m:Etc.#getgrent]] によって開始された /etc/group ファイルを読む
プロセスを終了させファイルを閉じます。

@see [[man:getgrent(3)]]

--- setgrent -> nil

/etc/group の先頭に戻ります。

このメソッドを呼び出した後 [[m:Etc.#getgrent]] を呼び出すと先頭のエントリを返します。

@see [[man:getgrent(3)]]

--- getpwent -> Struct::Passwd | nil

/etc/passwd から読み込んだエントリを一つ返します。

最初の呼び出しでは、先頭のエントリを返します。それ以降の呼び出しでは、
呼び出す度に次のエントリを順に返します。ファイルの終端に達すると nil を返します。

処理が終了したときは [[m:Etc.#endpwent]] を呼び出すようにしてください。

@see [[man:getpwent(3)]]

--- endpwent -> nil

[[m:Etc.#getpwent]] によって開始された /etc/passwdファイルを読む
プロセスを終了させファイルを閉じます。

@see [[man:getpwent(3)]]

--- setpwent -> nil

/etc/passwd の先頭に戻ります。

このメソッドを呼び出した後 [[m:Etc.#getpwent]] を呼び出すと先頭のエントリを返します。

@see [[man:getpwent(3)]]

#@end

--- getlogin -> String | nil

自分の login 名を返します。得られなかった場合は nil を返します。

getlogin は [[man:su(1)]] などでログイン時のユーザとは異なるユーザになっている場合、
現在ではなくログイン時のユーザを返します。

このメソッドが失敗した場合は [[m:Etc.#getpwuid]] に
フォールバックするとよいでしょう。

たとえば、環境変数 USER などもあわせて、以下のようにフォールバックできます。

  require "etc"
  login_user = ENV['USER'] || ENV['LOGNAME'] || Etc.getlogin || Etc.getpwuid.name


--- getpwnam(name) -> Struct::Passwd

passwd データベースを検索し、
名前が name である passwd エントリを返します。

@param name 検索するユーザ名。

@raise ArgumentError エントリが見つからなかった場合に発生します。

@see [[man:getpwnam(3)]], [[c:Struct::Passwd]]

--- getpwuid(uid = getuid) -> Struct::Passwd

passwd データベースを検索し、
ユーザ ID が uid である passwd エントリを返します。

@param uid 検索する uid 。引数を省略した場合には [[man:getuid(2)]] の値を用います。

@raise ArgumentError エントリが見つからなかった場合に発生します。

@see [[man:getpwuid(3)]], [[c:Struct::Passwd]]

--- getgrgid(gid) -> Struct::Group

group データベースを検索し、グループ ID が gid
であるグループエントリを返します。

@param gid 検索する gid

@raise ArgumentError エントリが見つからなかった場合に発生します。

@see [[man:getgrgid(3)]], [[c:Struct::Group]]

--- getgrnam(name) -> Struct::Group

name という名前のグループエントリを返します。

@param name 検索するグループ名。

@raise ArgumentError エントリが見つからなかった場合に発生します。

@see [[man:getgrnam(3)]], [[c:Struct::Group]]

--- group -> Struct::Group | nil

/etc/group ファイルから読み込んだエントリを一つ返します。

最初の呼び出しでは、先頭のエントリを返します。それ以降の呼び出しでは、
呼び出す度に次のエントリを順に返します。ファイルの終端に達すると nil を返します。

@raise RuntimeError /etc/group ファイルがロックされている場合に発生します。

#@since 1.8.1
@see [[m:Etc.#getgrent]], [[man:getgrent(3)]]
#@else
@see [[man:getgrent(3)]]
#@end

--- group {|gr| ... } -> ()

全てのグループエントリを順にアクセスするためのイテレータです。

--- passwd -> Struct::Passwd | nil

/etc/passwd から読み込んだエントリを一つ返します。

最初の呼び出しでは、先頭のエントリを返します。それ以降の呼び出しでは、
呼び出す度に次のエントリを順に返します。ファイルの終端に達すると nil を返します。

@raise RuntimeError /etc/passwd ファイルがロックされている場合に発生します。

#@since 1.8.1
@see [[m:Etc.#getpwent]], [[man:getpwent(3)]]
#@else
@see [[man:getpwent(3)]]
#@end

--- passwd {|pw| ... } -> ()

全ての passwd エントリを順にアクセスするためのイテレータです。

#@since 1.9.2
--- sysconfdir -> String | nil

システムの設定ディレクトリを返します。

  require 'etc'
  p Etc.sysconfdir # => "/etc"

主に "/etc" を返しますが、Ruby をソースからビルドした場合は異なるディレ
クトリを返す場合があります。例えば、Ruby を /usr/local にインストールし
た場合は、"/usr/local/etc" を返します。
Windows では常にシステムで提供されたディレクトリを返します。

--- systmpdir -> String | nil

システムのテンポラリディレクトリを返します。

  require 'etc'
  p Etc.systmpdir # => "/tmp"

#@end
#@since 2.2.0
--- uname -> {Symbol => String}

[[man:uname(2)]] で取得したシステム情報を [[c:Hash]] で返します。

@return 少なくとも :sysname, :nodename, :release, :version, :machine の
        5 つのキーを持つ [[c:Hash]] を返します。

例:

  require 'etc'
  require 'pp'

  pp Etc.uname
  # => {:sysname=>"Linux",
  #     :nodename=>"boron",
  #     :release=>"2.6.18-6-xen-686",
  #     :version=>"#1 SMP Thu Nov 5 19:54:42 UTC 2009",
  #     :machine=>"i686"}

--- sysconf(name) -> Integer | nil

[[man:sysconf(3)]] で取得したシステム設定変数の値を返します。

引数 name が制限に関する設定値であり、設定が制限がない状態の場合は nil
を返します。([[man:sysconf(3)]] が -1 を返し、errno が設定されていない
場合)

@param name [[c:Etc]] モジュールの SC_ で始まる定数のいずれかを指定します。

  require "etc"
  Etc.sysconf(Etc::SC_ARG_MAX) # => 2097152

  # Number of processors.
  # It is not standardized.
  Etc.sysconf(Etc::SC_NPROCESSORS_ONLN) # => 4

--- confstr(name) -> String | nil

[[man:confstr(3)]] で取得したシステム設定変数の値を返します。

@param name [[c:Etc]] モジュールの CS_ で始まる定数のいずれかを指定します。

引数 name に対応する設定が行われていない状態の場合は nil を返します。
([[man:confstr(3)]] が -1 を返し、errno が設定されていない場合)

  require "etc"
  Etc.confstr(Etc::CS_PATH) # => "/bin:/usr/bin"

  # GNU/Linux
  Etc.confstr(Etc::CS_GNU_LIBC_VERSION) # => "glibc 2.18"
  Etc.confstr(Etc::CS_GNU_LIBPTHREAD_VERSION) # => "NPTL 2.18"

--- nprocessors -> Integer

有効な CPU コア数を返します。

例:

  require 'etc'
  p Etc.nprocessors #=> 4

== Constants

--- SC_AIO_LISTIO_MAX -> Integer
--- SC_AIO_MAX -> Integer
--- SC_AIO_PRIO_DELTA_MAX -> Integer
--- SC_ARG_MAX -> Integer
--- SC_ATEXIT_MAX -> Integer
--- SC_BC_BASE_MAX -> Integer
--- SC_BC_DIM_MAX -> Integer
--- SC_BC_SCALE_MAX -> Integer
--- SC_BC_STRING_MAX -> Integer
--- SC_CHILD_MAX -> Integer
--- SC_CLK_TCK -> Integer
--- SC_COLL_WEIGHTS_MAX -> Integer
--- SC_DELAYTIMER_MAX -> Integer
--- SC_EXPR_NEST_MAX -> Integer
--- SC_HOST_NAME_MAX -> Integer
--- SC_IOV_MAX -> Integer
--- SC_LINE_MAX -> Integer
--- SC_LOGIN_NAME_MAX -> Integer
--- SC_NGROUPS_MAX -> Integer
--- SC_GETGR_R_SIZE_MAX -> Integer
--- SC_GETPW_R_SIZE_MAX -> Integer
--- SC_MQ_OPEN_MAX -> Integer
--- SC_MQ_PRIO_MAX -> Integer
--- SC_OPEN_MAX -> Integer
--- SC_ADVISORY_INFO -> Integer
--- SC_BARRIERS -> Integer
--- SC_ASYNCHRONOUS_IO -> Integer
--- SC_CLOCK_SELECTION -> Integer
--- SC_CPUTIME -> Integer
--- SC_FSYNC -> Integer
--- SC_IPV6 -> Integer
--- SC_JOB_CONTROL -> Integer
--- SC_MAPPED_FILES -> Integer
--- SC_MEMLOCK -> Integer
--- SC_MEMLOCK_RANGE -> Integer
--- SC_MEMORY_PROTECTION -> Integer
--- SC_MESSAGE_PASSING -> Integer
--- SC_MONOTONIC_CLOCK -> Integer
--- SC_PRIORITIZED_IO -> Integer
--- SC_PRIORITY_SCHEDULING -> Integer
--- SC_RAW_SOCKETS -> Integer
--- SC_READER_WRITER_LOCKS -> Integer
--- SC_REALTIME_SIGNALS -> Integer
--- SC_REGEXP -> Integer
--- SC_SAVED_IDS -> Integer
--- SC_SEMAPHORES -> Integer
--- SC_SHARED_MEMORY_OBJECTS -> Integer
--- SC_SHELL -> Integer
--- SC_SPAWN -> Integer
--- SC_SPIN_LOCKS -> Integer
--- SC_SPORADIC_SERVER -> Integer
--- SC_SS_REPL_MAX -> Integer
--- SC_SYNCHRONIZED_IO -> Integer
--- SC_THREAD_ATTR_STACKADDR -> Integer
--- SC_THREAD_ATTR_STACKSIZE -> Integer
--- SC_THREAD_CPUTIME -> Integer
--- SC_THREAD_PRIO_INHERIT -> Integer
--- SC_THREAD_PRIO_PROTECT -> Integer
--- SC_THREAD_PRIORITY_SCHEDULING -> Integer
--- SC_THREAD_PROCESS_SHARED -> Integer
--- SC_THREAD_ROBUST_PRIO_INHERIT -> Integer
--- SC_THREAD_ROBUST_PRIO_PROTECT -> Integer
--- SC_THREAD_SAFE_FUNCTIONS -> Integer
--- SC_THREAD_SPORADIC_SERVER -> Integer
--- SC_THREADS -> Integer
--- SC_TIMEOUTS -> Integer
--- SC_TIMERS -> Integer
--- SC_TRACE -> Integer
--- SC_TRACE_EVENT_FILTER -> Integer
--- SC_TRACE_EVENT_NAME_MAX -> Integer
--- SC_TRACE_INHERIT -> Integer
--- SC_TRACE_LOG -> Integer
--- SC_TRACE_NAME_MAX -> Integer
--- SC_TRACE_SYS_MAX -> Integer
--- SC_TRACE_USER_EVENT_MAX -> Integer
--- SC_TYPED_MEMORY_OBJECTS -> Integer
--- SC_VERSION -> Integer
--- SC_V7_ILP32_OFF32 -> Integer
--- SC_V7_ILP32_OFFBIG -> Integer
--- SC_V7_LP64_OFF64 -> Integer
--- SC_V7_LPBIG_OFFBIG -> Integer
--- SC_V6_ILP32_OFF32 -> Integer
--- SC_V6_ILP32_OFFBIG -> Integer
--- SC_V6_LP64_OFF64 -> Integer
--- SC_V6_LPBIG_OFFBIG -> Integer
--- SC_2_C_BIND -> Integer
--- SC_2_C_DEV -> Integer
--- SC_2_CHAR_TERM -> Integer
--- SC_2_FORT_DEV -> Integer
--- SC_2_FORT_RUN -> Integer
--- SC_2_LOCALEDEF -> Integer
--- SC_2_PBS -> Integer
--- SC_2_PBS_ACCOUNTING -> Integer
--- SC_2_PBS_CHECKPOINT -> Integer
--- SC_2_PBS_LOCATE -> Integer
--- SC_2_PBS_MESSAGE -> Integer
--- SC_2_PBS_TRACK -> Integer
--- SC_2_SW_DEV -> Integer
--- SC_2_UPE -> Integer
--- SC_2_VERSION -> Integer
--- SC_PAGE_SIZE -> Integer
--- SC_PAGESIZE -> Integer
--- SC_THREAD_DESTRUCTOR_ITERATIONS -> Integer
--- SC_THREAD_KEYS_MAX -> Integer
--- SC_THREAD_STACK_MIN -> Integer
--- SC_THREAD_THREADS_MAX -> Integer
--- SC_RE_DUP_MAX -> Integer
--- SC_RTSIG_MAX -> Integer
--- SC_SEM_NSEMS_MAX -> Integer
--- SC_SEM_VALUE_MAX -> Integer
--- SC_SIGQUEUE_MAX -> Integer
--- SC_STREAM_MAX -> Integer
--- SC_SYMLOOP_MAX -> Integer
--- SC_TIMER_MAX -> Integer
--- SC_TTY_NAME_MAX -> Integer
--- SC_TZNAME_MAX -> Integer
--- SC_XOPEN_CRYPT -> Integer
--- SC_XOPEN_ENH_I18N -> Integer
--- SC_XOPEN_REALTIME -> Integer
--- SC_XOPEN_REALTIME_THREADS -> Integer
--- SC_XOPEN_SHM -> Integer
--- SC_XOPEN_STREAMS -> Integer
--- SC_XOPEN_UNIX -> Integer
--- SC_XOPEN_UUCP -> Integer
--- SC_XOPEN_VERSION -> Integer
--- SC_PHYS_PAGES -> Integer
--- SC_AVPHYS_PAGES -> Integer
--- SC_NPROCESSORS_CONF -> Integer
--- SC_NPROCESSORS_ONLN -> Integer
--- SC_CPUSET_SIZE -> Integer

[[m:Etc.#sysconf]] の引数に指定します。

詳細は [[man:sysconf(3)]] を参照してください。

--- CS_PATH -> Integer
--- CS_POSIX_V7_ILP32_OFF32_CFLAGS -> Integer
--- CS_POSIX_V7_ILP32_OFF32_LDFLAGS -> Integer
--- CS_POSIX_V7_ILP32_OFF32_LIBS -> Integer
--- CS_POSIX_V7_ILP32_OFFBIG_CFLAGS -> Integer
--- CS_POSIX_V7_ILP32_OFFBIG_LDFLAGS -> Integer
--- CS_POSIX_V7_ILP32_OFFBIG_LIBS -> Integer
--- CS_POSIX_V7_LP64_OFF64_CFLAGS -> Integer
--- CS_POSIX_V7_LP64_OFF64_LDFLAGS -> Integer
--- CS_POSIX_V7_LP64_OFF64_LIBS -> Integer
--- CS_POSIX_V7_LPBIG_OFFBIG_CFLAGS -> Integer
--- CS_POSIX_V7_LPBIG_OFFBIG_LDFLAGS -> Integer
--- CS_POSIX_V7_LPBIG_OFFBIG_LIBS -> Integer
--- CS_POSIX_V7_THREADS_CFLAGS -> Integer
--- CS_POSIX_V7_THREADS_LDFLAGS -> Integer
--- CS_POSIX_V7_WIDTH_RESTRICTED_ENVS -> Integer
--- CS_V7_ENV -> Integer
--- CS_POSIX_V6_ILP32_OFF32_CFLAGS -> Integer
--- CS_POSIX_V6_ILP32_OFF32_LDFLAGS -> Integer
--- CS_POSIX_V6_ILP32_OFF32_LIBS -> Integer
--- CS_POSIX_V6_ILP32_OFFBIG_CFLAGS -> Integer
--- CS_POSIX_V6_ILP32_OFFBIG_LDFLAGS -> Integer
--- CS_POSIX_V6_ILP32_OFFBIG_LIBS -> Integer
--- CS_POSIX_V6_LP64_OFF64_CFLAGS -> Integer
--- CS_POSIX_V6_LP64_OFF64_LDFLAGS -> Integer
--- CS_POSIX_V6_LP64_OFF64_LIBS -> Integer
--- CS_POSIX_V6_LPBIG_OFFBIG_CFLAGS -> Integer
--- CS_POSIX_V6_LPBIG_OFFBIG_LDFLAGS -> Integer
--- CS_POSIX_V6_LPBIG_OFFBIG_LIBS -> Integer
--- CS_POSIX_V6_WIDTH_RESTRICTED_ENVS -> Integer
--- CS_V6_ENV -> Integer
--- CS_GNU_LIBC_VERSION -> Integer
--- CS_GNU_LIBPTHREAD_VERSION -> Integer

[[m:Etc.#confstr]] の引数に指定します。

詳細は [[man:confstr(3)]] を参照してください。

--- PC_FILESIZEBITS -> Integer
--- PC_LINK_MAX -> Integer
--- PC_MAX_CANON -> Integer
--- PC_MAX_INPUT -> Integer
--- PC_NAME_MAX -> Integer
--- PC_PATH_MAX -> Integer
--- PC_PIPE_BUF -> Integer
--- PC_2_SYMLINKS -> Integer
--- PC_ALLOC_SIZE_MIN -> Integer
--- PC_REC_INCR_XFER_SIZE -> Integer
--- PC_REC_MAX_XFER_SIZE -> Integer
--- PC_REC_MIN_XFER_SIZE -> Integer
--- PC_REC_XFER_ALIGN -> Integer
--- PC_SYMLINK_MAX -> Integer
--- PC_CHOWN_RESTRICTED -> Integer
--- PC_NO_TRUNC -> Integer
--- PC_VDISABLE -> Integer
--- PC_ASYNC_IO -> Integer
--- PC_PRIO_IO -> Integer
--- PC_SYNC_IO -> Integer
--- PC_TIMESTAMP_RESOLUTION -> Integer

[[m:IO#pathconf]] の引数に指定します。

詳細は [[man:fpathconf(3)]] を参照してください。
#@end

= class Struct::Group < Struct
#@since 1.9.1
alias Etc::Group
#@end
[[m:Etc.#getgrent]] で得られる構造体。

この構造体の値を変更してもシステムには反映されません。

#@since 1.9.2

== Class Methods

--- each {|entry| ... } -> Struct::Group
--- each                -> Enumerator

/etc/group に含まれるエントリを一つずつブロックに渡して評価します。
ブロックを省略した場合は [[c:Enumerator]] のインスタンスを返します。

@see [[m:Etc.#getpwent]]

#@end

== Instance Methods

--- gid -> Integer

グループ ID を返します。

--- gid=(gid)

グループ ID を設定します。

--- mem -> [String]

このグループに所属するメンバーのログイン名を配列で返します。

--- mem=(mem)

このグループに所属するメンバーのログイン名を設定します。

--- name -> String

グループ名を設定します。


--- name=(name)

グループ名を返します。

--- passwd -> String

暗号化されたパスワードを返します。

このグループのパスワードへのアクセスが無効である場合は 'x' を返します。
このグループの一員になるのにパスワードが不要である場合は、空文字列を返します。


--- passwd=(passwd)

このグループのパスワードを設定します。

= class Struct::Passwd < Struct
#@since 1.9.1
alias Etc::Passwd
#@end
[[m:Etc.#getpwent]] で得られる構造体。

この構造体の値を変更してもシステムには反映されません。

全てのシステムで提供されているメンバ。
  * name
  * passwd
  * uid
  * gid
  * gecos
  * dir
  * shell

以降のメンバはシステムによっては提供されません。
  * change
  * quota
  * age
  * class
  * comment
  * expire

#@since 1.9.2

== Class Methods

--- each {|entry| ... } -> Struct::Passwd
--- each                -> Enumerator

/etc/passwd に含まれるエントリを一つずつブロックに渡して評価します。
ブロックを省略した場合は [[c:Enumerator]] のインスタンスを返します。

@see [[m:Etc.#getpwent]]

#@end

== Instance Methods

--- dir -> String

このユーザのホームディレクトリを表すパスを返します。

--- dir=(dir)

このユーザのホームディレクトリを表すパスを設定します。

--- gecos -> String

このユーザのフルネーム等の詳細情報を返します。

様々な構造化された情報を返す Unix システムも存在しますが、それはシステム依存です。

--- gecos=()

このユーザのフルネーム等の詳細情報を設定します。

--- gid -> Integer

このユーザの gid を返します。

--- gid=(gid)

このユーザの gid を設定します。

--- name -> String

このユーザのログイン名を返します。

--- name=(name)

このユーザのログイン名を設定します。

--- passwd -> String

このユーザの暗号化されたパスワードを返します。

シャドウパスワードが使用されている場合は、 'x' を返します。
このユーザがログインできない場合は '*' を返します。

--- passwd=(passwd)

このユーザの暗号化されたパスワードを設定します。

--- shell -> String

このユーザのログインシェルを返します。

--- shell=(shell)

このユーザのログインシェルを設定します。

--- uid -> Integer

このユーザの uid を返します。

--- uid=(uid)

このユーザの uid を設定します。

--- change -> Integer

パスワード変更時間(整数)を返します。このメンバはシステム依存です。

--- change=(change)

パスワード変更時間(整数)を設定します。このメンバはシステム依存です。

--- quota -> Integer

クォータ(整数)を返します。このメンバはシステム依存です。

--- quota=(quota)

クォータ(整数)を設定します。このメンバはシステム依存です。

--- age -> Integer

エージ(整数)を返します。このメンバはシステム依存です。

--- age=(age)

エージ(整数)を設定します。このメンバはシステム依存です。

--- uclass -> String

ユーザアクセスクラス(文字列)を返します。このメンバはシステム依存です。

--- uclass=(class)

ユーザアクセスクラス(文字列)を設定します。このメンバはシステム依存です。

--- comment -> String

コメント(文字列)を返します。このメンバはシステム依存です。

--- comment=(comment)

コメント(文字列)を設定します。このメンバはシステム依存です。

--- expire -> Integer

アカウント有効期限(整数)を返します。このメンバはシステム依存です。

--- expire=(expire)

アカウント有効期限(整数)を設定します。このメンバはシステム依存です。

#@since 2.2.0
= reopen IO

== Instance Methods

--- pathconf(name) -> Integer | nil

[[man:fpathconf(3)]] で取得したファイルの設定変数の値を返します。

引数 name が制限に関する設定値であり、設定が制限がない状態の場合は nil
を返します。([[man:fpathconf(3)]] が -1 を返し、errno が設定されていない
場合)

@param name [[c:Etc]] モジュールの PC_ で始まる定数のいずれかを指定します。

  require 'etc'
  IO.pipe {|r, w|
    p w.pathconf(Etc::PC_PIPE_BUF) # => 4096
  }
#@end
