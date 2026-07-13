---
library: etc
---
# module Etc

/etc に存在するデータベースから情報を得るためのモジュールです。
クラスにインクルードして使うこともできます。

## Module Functions

### module_function def getgrent -> Etc::Group | nil

/etc/group ファイルから読み込んだエントリを一つ返します。

最初の呼び出しでは、先頭のエントリを返します。それ以降の呼び出しでは、
呼び出す度に次のエントリを順に返します。ファイルの終端に達すると nil を返します。

処理が終了したときは [m:Etc?.endgrent] を呼び出すようにしてください。

- **SEE** [man:getgrent(3)], [c:Etc::Group]

### module_function def endgrent -> nil

[m:Etc?.getgrent] によって開始された /etc/group ファイルを読む
プロセスを終了させファイルを閉じます。

- **SEE** [man:getgrent(3)]

### module_function def setgrent -> nil

/etc/group の先頭に戻ります。

このメソッドを呼び出した後 [m:Etc?.getgrent] を呼び出すと先頭のエントリを返します。

- **SEE** [man:getgrent(3)]

### module_function def getpwent -> Etc::Passwd | nil

/etc/passwd から読み込んだエントリを一つ返します。

最初の呼び出しでは、先頭のエントリを返します。それ以降の呼び出しでは、
呼び出す度に次のエントリを順に返します。ファイルの終端に達すると nil を返します。

処理が終了したときは [m:Etc?.endpwent] を呼び出すようにしてください。

- **SEE** [man:getpwent(3)]

### module_function def endpwent -> nil

[m:Etc?.getpwent] によって開始された /etc/passwdファイルを読む
プロセスを終了させファイルを閉じます。

- **SEE** [man:getpwent(3)]

### module_function def setpwent -> nil

/etc/passwd の先頭に戻ります。

このメソッドを呼び出した後 [m:Etc?.getpwent] を呼び出すと先頭のエントリを返します。

- **SEE** [man:getpwent(3)]


### module_function def getlogin -> String | nil

自分の login 名を返します。得られなかった場合は nil を返します。

getlogin は [man:su(1)] などでログイン時のユーザとは異なるユーザになっている場合、
現在ではなくログイン時のユーザを返します。

このメソッドが失敗した場合は [m:Etc?.getpwuid] に
フォールバックするとよいでしょう。

たとえば、環境変数 USER などもあわせて、以下のようにフォールバックできます。

```ruby
require "etc"
login_user = ENV['USER'] || ENV['LOGNAME'] || Etc.getlogin || Etc.getpwuid.name
```


### module_function def getpwnam(name) -> Etc::Passwd

passwd データベースを検索し、
名前が name である passwd エントリを返します。

- **param** `name` -- 検索するユーザ名。

- **raise** `ArgumentError` -- エントリが見つからなかった場合に発生します。

- **SEE** [man:getpwnam(3)], [c:Etc::Passwd]

### module_function def getpwuid(uid = getuid) -> Etc::Passwd

passwd データベースを検索し、
ユーザ ID が uid である passwd エントリを返します。

- **param** `uid` -- 検索する uid 。引数を省略した場合には [man:getuid(2)] の値を用います。

- **raise** `ArgumentError` -- エントリが見つからなかった場合に発生します。

- **SEE** [man:getpwuid(3)], [c:Etc::Passwd]

### module_function def getgrgid(gid) -> Etc::Group

group データベースを検索し、グループ ID が gid
であるグループエントリを返します。

- **param** `gid` -- 検索する gid

- **raise** `ArgumentError` -- エントリが見つからなかった場合に発生します。

- **SEE** [man:getgrgid(3)], [c:Etc::Group]

### module_function def getgrnam(name) -> Etc::Group

name という名前のグループエントリを返します。

- **param** `name` -- 検索するグループ名。

- **raise** `ArgumentError` -- エントリが見つからなかった場合に発生します。

- **SEE** [man:getgrnam(3)], [c:Etc::Group]

### module_function def group -> Etc::Group | nil

/etc/group ファイルから読み込んだエントリを一つ返します。

最初の呼び出しでは、先頭のエントリを返します。それ以降の呼び出しでは、
呼び出す度に次のエントリを順に返します。ファイルの終端に達すると nil を返します。

- **raise** `RuntimeError` -- /etc/group ファイルがロックされている場合に発生します。

- **SEE** [m:Etc?.getgrent], [man:getgrent(3)]

### module_function def group {|gr| ... } -> ()

全てのグループエントリを順にアクセスするためのイテレータです。

### module_function def passwd -> Etc::Passwd | nil

/etc/passwd から読み込んだエントリを一つ返します。

最初の呼び出しでは、先頭のエントリを返します。それ以降の呼び出しでは、
呼び出す度に次のエントリを順に返します。ファイルの終端に達すると nil を返します。

- **raise** `RuntimeError` -- /etc/passwd ファイルがロックされている場合に発生します。

- **SEE** [m:Etc?.getpwent], [man:getpwent(3)]

### module_function def passwd {|pw| ... } -> ()

全ての passwd エントリを順にアクセスするためのイテレータです。

### module_function def sysconfdir -> String | nil

システムの設定ディレクトリを返します。

```ruby
require 'etc'
p Etc.sysconfdir # => "/etc"
```

主に "/etc" を返しますが、Ruby をソースからビルドした場合は異なるディレ
クトリを返す場合があります。例えば、Ruby を /usr/local にインストールし
た場合は、"/usr/local/etc" を返します。
Windows では常にシステムで提供されたディレクトリを返します。

### module_function def systmpdir -> String | nil

システムのテンポラリディレクトリを返します。

```ruby
require 'etc'
p Etc.systmpdir # => "/tmp"
```

### module_function def uname -> {Symbol => String}

[man:uname(2)] で取得したシステム情報を [c:Hash] で返します。

- **return** -- 少なくとも :sysname, :nodename, :release, :version, :machine の
        5 つのキーを持つ [c:Hash] を返します。

```ruby title="例"
require 'etc'
require 'pp'

pp Etc.uname
# => {:sysname=>"Linux",
#     :nodename=>"boron",
#     :release=>"2.6.18-6-xen-686",
#     :version=>"#1 SMP Thu Nov 5 19:54:42 UTC 2009",
#     :machine=>"i686"}
```

### module_function def sysconf(name) -> Integer | nil

[man:sysconf(3)] で取得したシステム設定変数の値を返します。

引数 name が制限に関する設定値であり、設定が制限がない状態の場合は nil
を返します。([man:sysconf(3)] が -1 を返し、errno が設定されていない
場合)

- **param** `name` -- [c:Etc] モジュールの SC_ で始まる定数のいずれかを指定します。

```ruby
require "etc"
p Etc.sysconf(Etc::SC_ARG_MAX) # => 2097152

# Number of processors.
# It is not standardized.
p Etc.sysconf(Etc::SC_NPROCESSORS_ONLN) # => 4
```

### module_function def confstr(name) -> String | nil

[man:confstr(3)] で取得したシステム設定変数の値を返します。

- **param** `name` -- [c:Etc] モジュールの CS_ で始まる定数のいずれかを指定します。

引数 name に対応する設定が行われていない状態の場合は nil を返します。
([man:confstr(3)] が -1 を返し、errno が設定されていない場合)

```ruby
require "etc"
p Etc.confstr(Etc::CS_PATH) # => "/bin:/usr/bin"

# GNU/Linux
p Etc.confstr(Etc::CS_GNU_LIBC_VERSION) # => "glibc 2.18"
p Etc.confstr(Etc::CS_GNU_LIBPTHREAD_VERSION) # => "NPTL 2.18"
```

### module_function def nprocessors -> Integer

有効な CPU コア数を返します。

```ruby
require 'etc'
p Etc.nprocessors #=> 4
```

## Constants

### const SC_AIO_LISTIO_MAX -> Integer
### const SC_AIO_MAX -> Integer
### const SC_AIO_PRIO_DELTA_MAX -> Integer
### const SC_ARG_MAX -> Integer
### const SC_ATEXIT_MAX -> Integer
### const SC_BC_BASE_MAX -> Integer
### const SC_BC_DIM_MAX -> Integer
### const SC_BC_SCALE_MAX -> Integer
### const SC_BC_STRING_MAX -> Integer
### const SC_CHILD_MAX -> Integer
### const SC_CLK_TCK -> Integer
### const SC_COLL_WEIGHTS_MAX -> Integer
### const SC_DELAYTIMER_MAX -> Integer
### const SC_EXPR_NEST_MAX -> Integer
### const SC_HOST_NAME_MAX -> Integer
### const SC_IOV_MAX -> Integer
### const SC_LINE_MAX -> Integer
### const SC_LOGIN_NAME_MAX -> Integer
### const SC_NGROUPS_MAX -> Integer
### const SC_GETGR_R_SIZE_MAX -> Integer
### const SC_GETPW_R_SIZE_MAX -> Integer
### const SC_MQ_OPEN_MAX -> Integer
### const SC_MQ_PRIO_MAX -> Integer
### const SC_OPEN_MAX -> Integer
### const SC_ADVISORY_INFO -> Integer
### const SC_BARRIERS -> Integer
### const SC_ASYNCHRONOUS_IO -> Integer
### const SC_CLOCK_SELECTION -> Integer
### const SC_CPUTIME -> Integer
### const SC_FSYNC -> Integer
### const SC_IPV6 -> Integer
### const SC_JOB_CONTROL -> Integer
### const SC_MAPPED_FILES -> Integer
### const SC_MEMLOCK -> Integer
### const SC_MEMLOCK_RANGE -> Integer
### const SC_MEMORY_PROTECTION -> Integer
### const SC_MESSAGE_PASSING -> Integer
### const SC_MONOTONIC_CLOCK -> Integer
### const SC_PRIORITIZED_IO -> Integer
### const SC_PRIORITY_SCHEDULING -> Integer
### const SC_RAW_SOCKETS -> Integer
### const SC_READER_WRITER_LOCKS -> Integer
### const SC_REALTIME_SIGNALS -> Integer
### const SC_REGEXP -> Integer
### const SC_SAVED_IDS -> Integer
### const SC_SEMAPHORES -> Integer
### const SC_SHARED_MEMORY_OBJECTS -> Integer
### const SC_SHELL -> Integer
### const SC_SPAWN -> Integer
### const SC_SPIN_LOCKS -> Integer
### const SC_SPORADIC_SERVER -> Integer
### const SC_SS_REPL_MAX -> Integer
### const SC_SYNCHRONIZED_IO -> Integer
### const SC_THREAD_ATTR_STACKADDR -> Integer
### const SC_THREAD_ATTR_STACKSIZE -> Integer
### const SC_THREAD_CPUTIME -> Integer
### const SC_THREAD_PRIO_INHERIT -> Integer
### const SC_THREAD_PRIO_PROTECT -> Integer
### const SC_THREAD_PRIORITY_SCHEDULING -> Integer
### const SC_THREAD_PROCESS_SHARED -> Integer
### const SC_THREAD_ROBUST_PRIO_INHERIT -> Integer
### const SC_THREAD_ROBUST_PRIO_PROTECT -> Integer
### const SC_THREAD_SAFE_FUNCTIONS -> Integer
### const SC_THREAD_SPORADIC_SERVER -> Integer
### const SC_THREADS -> Integer
### const SC_TIMEOUTS -> Integer
### const SC_TIMERS -> Integer
### const SC_TRACE -> Integer
### const SC_TRACE_EVENT_FILTER -> Integer
### const SC_TRACE_EVENT_NAME_MAX -> Integer
### const SC_TRACE_INHERIT -> Integer
### const SC_TRACE_LOG -> Integer
### const SC_TRACE_NAME_MAX -> Integer
### const SC_TRACE_SYS_MAX -> Integer
### const SC_TRACE_USER_EVENT_MAX -> Integer
### const SC_TYPED_MEMORY_OBJECTS -> Integer
### const SC_VERSION -> Integer
### const SC_V7_ILP32_OFF32 -> Integer
### const SC_V7_ILP32_OFFBIG -> Integer
### const SC_V7_LP64_OFF64 -> Integer
### const SC_V7_LPBIG_OFFBIG -> Integer
### const SC_V6_ILP32_OFF32 -> Integer
### const SC_V6_ILP32_OFFBIG -> Integer
### const SC_V6_LP64_OFF64 -> Integer
### const SC_V6_LPBIG_OFFBIG -> Integer
### const SC_2_C_BIND -> Integer
### const SC_2_C_DEV -> Integer
### const SC_2_CHAR_TERM -> Integer
### const SC_2_FORT_DEV -> Integer
### const SC_2_FORT_RUN -> Integer
### const SC_2_LOCALEDEF -> Integer
### const SC_2_PBS -> Integer
### const SC_2_PBS_ACCOUNTING -> Integer
### const SC_2_PBS_CHECKPOINT -> Integer
### const SC_2_PBS_LOCATE -> Integer
### const SC_2_PBS_MESSAGE -> Integer
### const SC_2_PBS_TRACK -> Integer
### const SC_2_SW_DEV -> Integer
### const SC_2_UPE -> Integer
### const SC_2_VERSION -> Integer
### const SC_PAGE_SIZE -> Integer
### const SC_PAGESIZE -> Integer
### const SC_THREAD_DESTRUCTOR_ITERATIONS -> Integer
### const SC_THREAD_KEYS_MAX -> Integer
### const SC_THREAD_STACK_MIN -> Integer
### const SC_THREAD_THREADS_MAX -> Integer
### const SC_RE_DUP_MAX -> Integer
### const SC_RTSIG_MAX -> Integer
### const SC_SEM_NSEMS_MAX -> Integer
### const SC_SEM_VALUE_MAX -> Integer
### const SC_SIGQUEUE_MAX -> Integer
### const SC_STREAM_MAX -> Integer
### const SC_SYMLOOP_MAX -> Integer
### const SC_TIMER_MAX -> Integer
### const SC_TTY_NAME_MAX -> Integer
### const SC_TZNAME_MAX -> Integer
### const SC_XOPEN_CRYPT -> Integer
### const SC_XOPEN_ENH_I18N -> Integer
### const SC_XOPEN_REALTIME -> Integer
### const SC_XOPEN_REALTIME_THREADS -> Integer
### const SC_XOPEN_SHM -> Integer
### const SC_XOPEN_STREAMS -> Integer
### const SC_XOPEN_UNIX -> Integer
### const SC_XOPEN_UUCP -> Integer
### const SC_XOPEN_VERSION -> Integer
### const SC_PHYS_PAGES -> Integer
### const SC_AVPHYS_PAGES -> Integer
### const SC_NPROCESSORS_CONF -> Integer
### const SC_NPROCESSORS_ONLN -> Integer
### const SC_CPUSET_SIZE -> Integer

[m:Etc?.sysconf] の引数に指定します。

詳細は [man:sysconf(3)] を参照してください。

### const CS_PATH -> Integer
### const CS_POSIX_V7_ILP32_OFF32_CFLAGS -> Integer
### const CS_POSIX_V7_ILP32_OFF32_LDFLAGS -> Integer
### const CS_POSIX_V7_ILP32_OFF32_LIBS -> Integer
### const CS_POSIX_V7_ILP32_OFFBIG_CFLAGS -> Integer
### const CS_POSIX_V7_ILP32_OFFBIG_LDFLAGS -> Integer
### const CS_POSIX_V7_ILP32_OFFBIG_LIBS -> Integer
### const CS_POSIX_V7_LP64_OFF64_CFLAGS -> Integer
### const CS_POSIX_V7_LP64_OFF64_LDFLAGS -> Integer
### const CS_POSIX_V7_LP64_OFF64_LIBS -> Integer
### const CS_POSIX_V7_LPBIG_OFFBIG_CFLAGS -> Integer
### const CS_POSIX_V7_LPBIG_OFFBIG_LDFLAGS -> Integer
### const CS_POSIX_V7_LPBIG_OFFBIG_LIBS -> Integer
### const CS_POSIX_V7_THREADS_CFLAGS -> Integer
### const CS_POSIX_V7_THREADS_LDFLAGS -> Integer
### const CS_POSIX_V7_WIDTH_RESTRICTED_ENVS -> Integer
### const CS_V7_ENV -> Integer
### const CS_POSIX_V6_ILP32_OFF32_CFLAGS -> Integer
### const CS_POSIX_V6_ILP32_OFF32_LDFLAGS -> Integer
### const CS_POSIX_V6_ILP32_OFF32_LIBS -> Integer
### const CS_POSIX_V6_ILP32_OFFBIG_CFLAGS -> Integer
### const CS_POSIX_V6_ILP32_OFFBIG_LDFLAGS -> Integer
### const CS_POSIX_V6_ILP32_OFFBIG_LIBS -> Integer
### const CS_POSIX_V6_LP64_OFF64_CFLAGS -> Integer
### const CS_POSIX_V6_LP64_OFF64_LDFLAGS -> Integer
### const CS_POSIX_V6_LP64_OFF64_LIBS -> Integer
### const CS_POSIX_V6_LPBIG_OFFBIG_CFLAGS -> Integer
### const CS_POSIX_V6_LPBIG_OFFBIG_LDFLAGS -> Integer
### const CS_POSIX_V6_LPBIG_OFFBIG_LIBS -> Integer
### const CS_POSIX_V6_WIDTH_RESTRICTED_ENVS -> Integer
### const CS_V6_ENV -> Integer
### const CS_GNU_LIBC_VERSION -> Integer
### const CS_GNU_LIBPTHREAD_VERSION -> Integer

[m:Etc?.confstr] の引数に指定します。

詳細は [man:confstr(3)] を参照してください。

### const PC_FILESIZEBITS -> Integer
### const PC_LINK_MAX -> Integer
### const PC_MAX_CANON -> Integer
### const PC_MAX_INPUT -> Integer
### const PC_NAME_MAX -> Integer
### const PC_PATH_MAX -> Integer
### const PC_PIPE_BUF -> Integer
### const PC_2_SYMLINKS -> Integer
### const PC_ALLOC_SIZE_MIN -> Integer
### const PC_REC_INCR_XFER_SIZE -> Integer
### const PC_REC_MAX_XFER_SIZE -> Integer
### const PC_REC_MIN_XFER_SIZE -> Integer
### const PC_REC_XFER_ALIGN -> Integer
### const PC_SYMLINK_MAX -> Integer
### const PC_CHOWN_RESTRICTED -> Integer
### const PC_NO_TRUNC -> Integer
### const PC_VDISABLE -> Integer
### const PC_ASYNC_IO -> Integer
### const PC_PRIO_IO -> Integer
### const PC_SYNC_IO -> Integer
### const PC_TIMESTAMP_RESOLUTION -> Integer

[m:IO#pathconf] の引数に指定します。

詳細は [man:fpathconf(3)] を参照してください。

