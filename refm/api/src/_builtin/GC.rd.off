= module GC

GC は Ruby インタプリタの「ゴミ集め(Garbage Collection)」を制御
するモジュールです。

== Module Functions

--- disable

ガーベージコレクトを禁止します。

前回の禁止状態を返します(禁止されていたなら true, GC が有効であったなら、
false)。

--- enable

ガーベージコレクトを許可します。

前回の禁止状態を返します(禁止されていたなら true, GC が有効であったなら、
false)。

--- start

ガーベージコレクトを開始します。

nil を返します。

#@if (version >= "1.9.0")
--- stress
--- stress=(bool)

((<ruby 1.9 feature>))

GC.stress が真に設定されている間は、GC を行えるすべての機会に GC を行います。
#@end

== Instance Methods

--- garbage_collect

ガーベージコレクトを開始します。以下と同じ働きをします。

  GC.start

nil を返します。
