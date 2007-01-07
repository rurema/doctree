= module Process

UNIX のプロセスを管理するモジュール。

Process がプロセスを表現するクラスではなく、プロセスに対する操作
をまとめたモジュールであることに注意してください。

== Singleton Methods

#@since 1.8.0
--- abort([message])

関数 [[m:Kernel#abort]] と同じです。
#@end

#@since 1.9.0
--- daemon(nochdir=nil,noclose=nil)

プロセスから制御端末を切り離し、
バックグラウンドにまわってデーモンとして動作させます。

カレントディレクトリを / に移動します。
ただし nochdir に真を指定したときにはこの動作は抑制され、
カレントディレクトリは移動しません。

標準入力・標準出力・標準エラー出力を /dev/null にリダイレクトします。
ただし noclose に真を指定したときにはこの動作は抑制され、
リダイレクトは行なわれません。

0を返します。
#@end

#@since 1.8.0
--- detach(pid)

子プロセス pid の終了を監視するスレッドを生成して返します。
生成したスレッドは子プロセスが終了した後に nil で終了します。
(指定した子プロセスが存在しなければ即座に nil で終了します)。

    pid = fork {
      # child
      sleep 3
    }

    th = Process.detach(pid)
    p th.value

    # => nil
#@end

#@since 1.8.0
--- exit([status])

関数 [[m:Kernel#exit]] と同じです。
#@end

--- exit!([status])

関数 [[m:Kernel#exit!]] と同じです。

--- fork
--- fork { ... }

関数 [[m:Kernel#fork]] と同じです。

#@since 1.8.5
--- getrlimit(resource)
--- setrlimit(resource, cur_limit, max_limit)
--- setrlimit(resource, limit)

resource で示すプロセスリソースの制限値の取得、設定を行います。

Process.setrlimit において単一の limit が指定された場合には、
cur_limit, max_limit の両方がその値として指定されたものとして扱います。
これらの引数には、resource によって決まる意味を持つ何らかの整数もしくは
[[m:Process::RLIM_INFINITY]],
[[m:Process::RLIM_SAVED_CUR]],
[[m:Process::RLIM_SAVED_MAX]] のいずれかを指定します。

resource に指定する値は環境によりますが、以下のいずれかです。
システムによってはこれらのいくつかは存在しない場合があります。
詳細は、[[man:setrlimit(2)]] を参照してください。

  * [[m:Process::RLIMIT_CORE]] core ファイルのサイズ (バイト) (SUSv3)
  * [[m:Process::RLIMIT_CPU]] プロセスの CPU 時間 (秒) (SUSv3)
  * [[m:Process::RLIMIT_DATA]] プロセスのデータ領域のサイズ (バイト) (SUSv3)
  * [[m:Process::RLIMIT_FSIZE]] プロセスが生成するファイルのサイズ (バイト) (SUSv3)
  * [[m:Process::RLIMIT_NOFILE]] プロセスがオープンできるファイルの数 (SUSv3)
  * [[m:Process::RLIMIT_STACK]] プロセスのスタック領域のサイズ (バイト) (SUSv3)
  * [[m:Process::RLIMIT_AS]] プロセスの仮想メモリサイズ (バイト) (SUSv3, NetBSD, FreeBSD, OpenBSD but 4.4BSD-Lite))
  * [[m:Process::RLIMIT_MEMLOCK]] mlock(2) でロックできるトータルのサイズ (バイト) (4.4BSD, GNU/Linux)
  * [[m:Process::RLIMIT_NPROC]] そのユーザのプロセスの最大数 (4.4BSD, GNU/Linux)
  * [[m:Process::RLIMIT_RSS]] 使用できる実メモリの最大サイズ (バイト) (4.2BSD, GNU/Linux)
  * [[m:Process::RLIMIT_SBSIZE]] ソケットバッファのサイズ (バイト) (NetBSD, FreeBSD)

getrlimit は、2値の配列 [cur_limit, max_limit]
を返します。
setrlimit は、引数に指定した値を設定し、nil を返します。

リソースの制限値の取得、設定に失敗した場合、例外 [[c:Errno::EXXX]]
が発生します。

以下の例は RLIMIT_CORE の制限を hard limit (max limit) まで引き上げ、可能なら core を残すようにします。

  Process.setrlimit(Process::RLIMIT_CORE, 
                    Process.getrlimit(Process::RLIMIT_CORE)[1])

#@end

#@since 1.9.0
--- spawn(cmd, [, arg, ...])

関数 [[m:Kernel#spawn]] と同じです。
#@end

== Module Functions

--- egid

カレントプロセスの実効グループ ID を返します。

--- egid=(gid)

カレントプロセスの実効グループ ID を設定します。gid を返します。

--- euid

カレントプロセスの実効ユーザ ID を返します。

--- euid=(uid)

カレントプロセスの実効ユーザ ID を設定します。uid を返します。

--- gid

カレントプロセスの実グループ ID を返します。

--- gid=(gid)

カレントプロセスの実グループ ID を設定します。gid を返します。

--- groups

補助グループ ID の配列を返します(実効グループ ID を含むかも知れません)。

返される配列の最大要素数は 32 固定です(たぶんbug)。

--- groups=(gid_ary)

補助グループを設定します。右辺の配列の要素はグループ ID かグループ
名を指定します。Process.groups の結果を返します。

設定する補助グループ ID の数が [[m:Process#Process.maxgroups]] の
数を越えている場合、例外 [[c:ArgumentError]] が発生します。

--- maxgroups
--- maxgroups=(num)

設定できる補助グループ ID の数を指定します。実際に返される補助グルー
プ ID の数よりも少ない値を設定していると、
[[m:Process#Process.groups]] で例外が発生します。

--- pid

カレントプロセスのプロセス ID を返します。変数 [[m:$$]]
の値と同じです。

--- ppid

親プロセスのプロセス ID を返します。UN*X では実際の親プロセスが終
了した後は ppid は 1 (initの pid)になります。

--- uid

プロセスの実ユーザ ID を返します。

--- uid=(uid)

プロセスの実ユーザ ID を設定します。uid を返します。

--- getpgid(pid)
--- getpgrp([pid])

pid のプロセスのプロセスグループを返します。pid が 0
の時や省略された時はカレントプロセスを意味します。

プロセスグループの取得に失敗した場合は、例外 [[c:Errno::EXXX]] が
発生します。
#@# 1.6.7 までは、getpgid() は例外を発生させていませんでした。
#@# p Process.getpgid(1000000) # => -1

--- getpriority(which, who)

プロセス、プロセスグループ、ユーザの現在のプライオリティを返
します ([[man:getpriority(2)]] 参照)。

Process モジュールは which として指定できる定数
[[m:Process::PRIO_PROCESS]], [[m:Process::PRIO_PGRP]],
[[m:Process::PRIO_USER]] を定義しています。

who には、which の値にしたがってプロセス ID、プロセス
グループ ID、ユーザ ID のいずれかを指定します。

プライオリティの取得に失敗した場合は、例外 [[c:Errno::EXXX]] が発
生します。

#@since 1.8.0
--- initgroups(user, group)
#@todo

[[man:initgroups(3)]] 参照
#@end

--- kill(signal, pid ... )

pid で指定されたプロセスにシグナルを送ります。signal
はシグナル番号か名前(文字列または[[c:Symbol]])で指定します。

負の値を持つシグナル(あるいはシグナル名の前に-)もしくは
負の値を持つプロセス番号を与えるとプロセスではなくプロセスグループにシグナルを送ります。
負の値のプロセス番号はプロセスグループ番号を符号反転したものと見なされます。

全てのシグナル送信に成功した場合、指定した pid の数を返します。
失敗した場合は例外 [[c:Errno::EXXX]] が発生します。

存在しないシグナルを指定した場合は
例外 [[c:ArgumentError]] が発生します。

#@#なお、Windows ([[unknown:mswin32]], [[unknown:mingw32]])では、INT
#@#ILL FPE SEGV TERM BREAK ABRT しか指定できません。((<ruby 1.7 feature>))
#@#KILL も指定できます

[[m:Kernel#trap]]も参照してください。

#@since 1.8.0
--- setpgrp
#@else
--- setpgrp(pid, pgrp)
#@end
--- setpgid(pid, pgrp)

pid のプロセスグループを設定します。
pid が 0 の時はカレントプロセスを意味します。

プロセスグループの設定に成功した場合は 0 を返します。
失敗した場合は例外 [[c:Errno::EXXX]] が発生します。

#@since 1.8.0
Process.setpgrp は、引数を取りません。
#@end

--- setpriority(which, who, prio)

プロセス、プロセスグループ、
ユーザの現在のプライオリティを設定します
([[man:setpriority(2)]] 参照)。

Process モジュールは which として指定できる定数
[[m:Process::PRIO_PROCESS]], [[m:Process::PRIO_PGRP]],
[[m:Process::PRIO_USER]] を定義しています。

who には、which の値にしたがってプロセス ID、プロセス
グループ ID、ユーザ ID のいずれかを指定します。

prio には、-20 から 20 の値を設定します。
小さな値はプライオリティが高いことを意味し、
大きな値はプライオリティが低いことを意味します。

プライオリティの設定に成功した場合は 0 を返します。
失敗した場合は例外 [[c:Errno::EXXX]] が発生します。

以下の例は呼び出したプロセス自身のプライオリティを 10 に下げます。
すでに 10 よりもプライオリティが低く、
Errno::EACCES となった場合には無視して実行を続けます。

  begin
    Process.setpriority(Process::PRIO_PROCESS, 0, 10)
  rescue Errno::EACCES
  end

--- setsid

新しいセッションを作成して、tty を切り離します。デーモンを簡単に作
ることができます。セッション ID を返します。

セッションの作成に失敗した場合は、例外 [[c:Errno::EXXX]] が発生します。

#@since 1.8.0
--- times

自身のプロセスとその子プロセスが消費したユーザ/システム CPU 時間の積算を
[[c:Struct::Tms]] オブジェクトで返します。
Struct::Tms は以下のメンバを持つ構造体クラスです。

  utime           # user time
  stime           # system time
  cutime          # user time of children
  cstime          # system time of children

時間の単位は秒で、浮動小数点数で与えられます。
詳細は [[c:Struct::Tms]] を参照してください。
#@end

--- wait
--- wait2

子プロセスが終了するのを待ち、終了した子プロセスの pid を返します。
子プロセスが一つもなければ例外 [[c:Errno::ECHILD]] が
発生します。

wait2 は、その戻り値が pid と [[m:$?]] の配列であ
る点だけが異なります。

#@since 1.8.0
Ruby 1.8 からは $? は[[c:Process::Status]] オブジェクトです。
Process.wait と Process.waitpid の実体は同じものになりました。
Process.wait2 と Process.waitpid2 の実体は同じものになりました。
#@end

#@since 1.8.0
--- waitall

全ての子プロセスが終了するのを待ちます。

終了した子プロセスの pid と終了ステータス
([[c:Process::Status]]) の配列を要素に持つ配列を返します。
子プロセスがいない状態でこのメソッドを呼び出すと空の配列を返します。

[[m:$?]] には最後に終了した子プロセスの終了ステータスが
設定されます。

例:
    3.times {|n|
      Process.fork() { exit n }
    }
    p ret = Process.waitall
    p ret[-1][1]  , ret[-1][1].class
    p $?          , $?.class
    => [[5245, 256], [5244, 0], [5243, 512]]
       512
       Process::Status
       512
       Process::Status
#@end

--- waitpid(pid[, flags])
--- waitpid2(pid[, flags])

pid で指定される特定の子プロセスの終了を待ち、そのプロセスが
終了した時に pid を返します。子プロセスが存在しなければ例外
[[c:Errno::ECHILD]] が発生します。

flags には、Process モジュールの定数
[[m:Process::WNOHANG]](ノンブロッキングモード)と
[[m:Process::WUNTRACED]] の論理和を指定します。
省略したときの値は 0 です。

ノンブロッキングモードで子プロセスがまだ終了していない時には
nil を返します。[[man:waitpid(2)]] か
[[man:wait4(2)]] の実装されていないマシンでは
flags はいつも nil または 0 を指定する必要があります。

waitpid2 は、その戻り値が pid と [[m:$?]] の配列
である点だけが異なります。

#@since 1.8.0
Ruby 1.8.0 からは $? は [[c:Process::Status]] オブジェクトです。
Process.wait と Process.waitpid の実体は同じものになりました。
Process.wait2 と Process.waitpid2 の実体は同じものになりました。
#@end

== Constants

--- PRIO_PROCESS

[[m:Process#Process.getpriority]] または
[[m:Process#Process.setpriority]] のプロセスプライオリティ指定。

--- PRIO_PGRP

プロセスグループプライオリティ。

--- PRIO_USER

ユーザプライオリティ。

--- RLIMIT_AS

[[m:Process#Process.getrlimit]] 参照。

--- RLIMIT_CORE

[[m:Process#Process.getrlimit]] 参照。

--- RLIMIT_CPU

[[m:Process#Process.getrlimit]] 参照。

--- RLIMIT_DATA

[[m:Process#Process.getrlimit]] 参照。

--- RLIMIT_FSIZE

[[m:Process#Process.getrlimit]] 参照。

--- RLIMIT_MEMLOCK

[[m:Process#Process.getrlimit]] 参照。

--- RLIMIT_NOFILE

[[m:Process#Process.getrlimit]] 参照。

--- RLIMIT_NPROC

[[m:Process#Process.getrlimit]] 参照。

--- RLIMIT_RSS

[[m:Process#Process.getrlimit]] 参照。

--- RLIMIT_SBSIZE

[[m:Process#Process.getrlimit]] 参照。

--- RLIMIT_STACK

[[m:Process#Process.getrlimit]] 参照。

--- RLIM_INFINITY

[[m:Process#Process.getrlimit]] 参照。

--- RLIM_SAVED_CUR

[[m:Process#Process.getrlimit]] 参照。

--- RLIM_SAVED_MAX
#@todo

[[m:Process#Process.getrlimit]] 参照。

--- WNOHANG

[[m:Process#waitpid]] の第二引数に指定するフラグです。
終了した子プロセスがない時に waitpid がブロックしません。

--- WUNTRACED

[[m:Process#waitpid]] の第二引数に指定するフラグです。
子プロセスの停止によりステータスを報告していない
子プロセスがある時に waitpid がブロックしません。

#@since 1.8.0
#@include(Process__Status.rd)
#@include(Process__UID.rd)
#@include(Process__GID.rd)
#@include(Process__Sys.rd)
#@end
