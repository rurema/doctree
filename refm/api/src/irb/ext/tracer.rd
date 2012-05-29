require tracer

irb への入力を評価する時に [[lib:tracer]] ライブラリを使用してトレース
出力を行う機能を提供するサブライブラリです。

conf.use_tracer か IRB.conf[:USE_TRACER] に true を設定する事で使用でき
ます。ただし、[[m:Tracer.verbose?]] は常に false で実行されます。

= reopen IRB::Context

== Instance Methods

--- use_tracer  -> bool
--- use_tracer? -> bool

irb への入力を評価する時に [[lib:tracer]] が有効かどうかを返します。

@see [[lib:tracer]], [[m:IRB::Context#use_tracer=]]

--- use_tracer=(val)

irb への入力を評価する時に [[lib:tracer]] が有効にするかどうかを val で
指定します。

.irbrc ファイル中で IRB.conf[:USE_TRACER] を設定する事でも同様の事が行
えます。

@param val [[lib:tracer]] を有効にする場合に true を指定します。

@see [[lib:tracer]], [[m:IRB::Context#use_tracer]]
