= module File::Constants

[[c:File]] クラスに関る定数を集めたモジュール。

File クラスはこのモジュールをインクルードしているので、以下に挙
げる定数は File クラスの定数のように扱うことができます。

以下の定数は、[[m:File#flock]] で使用します。

== Constants

--- LOCK_SH
共有ロック。複数のプロセスが同時にロックを共有できます。
--- LOCK_EX
排他ロック。同時にはただひとつのプロセスだけがロックを保持できます。
--- LOCK_UN
アンロック。
--- LOCK_NB
ロックの際にブロックしない。他の指定と or することで指定します。

以下の定数は、[[m:File#open]]で使用します。

--- RDONLY

--- WRONLY

--- RDWR

--- APPEND

--- CREAT

--- EXCL

--- NONBLOCK

--- TRUNC

--- NOCTTY

--- BINARY

--- SYNC

#@if (version >= "1.7.0")
以下の定数は、[[m:File#fnmatch]], [[m:Dir#glob]]で使用します。

--- FNM_NOESCAPE

--- FNM_PATHNAME

--- FNM_PERIOD

--- FNM_CASEFOLD

--- FNM_DOTMATCH
#@end
