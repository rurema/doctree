= module File::Constants

[[c:File]] クラスに関る定数を集めたモジュール。

File クラスはこのモジュールをインクルードしているので、以下に挙
げる定数は File クラスの定数のように扱うことができます。

== Constants

--- LOCK_SH
共有ロック。複数のプロセスが同時にロックを共有できます。[[m:File#flock]] で使用します。
--- LOCK_EX
排他ロック。同時にはただひとつのプロセスだけがロックを保持できます。[[m:File#flock]] で使用します。
--- LOCK_UN
アンロック。[[m:File#flock]] で使用します。
--- LOCK_NB
ロックの際にブロックしない。他の指定と or することで指定します。[[m:File#flock]] で使用します。

--- RDONLY
[[m:File#open]]で使用します。

--- WRONLY
[[m:File#open]]で使用します。

--- RDWR
[[m:File#open]]で使用します。

--- APPEND
[[m:File#open]]で使用します。

--- CREAT
[[m:File#open]]で使用します。

--- EXCL
[[m:File#open]]で使用します。

--- NONBLOCK
[[m:File#open]]で使用します。

--- TRUNC
[[m:File#open]]で使用します。

--- NOCTTY
[[m:File#open]]で使用します。

--- BINARY
[[m:File#open]]で使用します。

--- SYNC
[[m:File#open]]で使用します。

#@since 1.8.0
--- FNM_NOESCAPE
[[m:File#fnmatch]], [[m:Dir#glob]]で使用します。

--- FNM_PATHNAME
[[m:File#fnmatch]], [[m:Dir#glob]]で使用します。

--- FNM_PERIOD
[[m:File#fnmatch]], [[m:Dir#glob]]で使用します。

--- FNM_CASEFOLD
[[m:File#fnmatch]], [[m:Dir#glob]]で使用します。

--- FNM_DOTMATCH
[[m:File#fnmatch]], [[m:Dir#glob]]で使用します。
#@end

#@since 1.8.5
--- FNM_SYSCASE
#@todo
#@end
