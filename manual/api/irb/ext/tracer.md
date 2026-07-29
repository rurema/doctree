---
type: library
require:
#%until 3.1
  - tracer
#%end
---
#%since 3.1
irb への入力を評価する時に tracer gem を使用してトレース
出力を行う機能を提供するサブライブラリです。tracer は Ruby 3.1 で
標準添付ライブラリから削除されたため、使用するには tracer gem の
インストールが必要です。
#%else
irb への入力を評価する時に [lib:tracer] ライブラリを使用してトレース
出力を行う機能を提供するサブライブラリです。
#%end

conf.use_tracer か IRB.conf[:USE_TRACER] に true を設定する事で使用でき
#%since 3.1
ます。ただし、`Tracer.verbose?` は常に false で実行されます。
#%else
ます。ただし、[m:Tracer.verbose?] は常に false で実行されます。
#%end

# reopen IRB::Context

## Instance Methods

### def use_tracer  -> bool
### def use_tracer? -> bool

#%since 3.1
irb への入力を評価する時に `tracer` によるトレース出力が有効かどうかを返します。

- **SEE** [m:IRB::Context#use_tracer=]
#%else
irb への入力を評価する時に [lib:tracer] が有効かどうかを返します。

- **SEE** [lib:tracer], [m:IRB::Context#use_tracer=]
#%end

### def use_tracer=(val)

#%since 3.1
irb への入力を評価する時に `tracer` によるトレース出力を有効にするかどうかを val で
指定します。
#%else
irb への入力を評価する時に [lib:tracer] が有効にするかどうかを val で
指定します。
#%end

.irbrc ファイル中で IRB.conf[:USE_TRACER] を設定する事でも同様の事が行
えます。

#%since 3.1
- **param** `val` -- トレース出力を有効にする場合に true を指定します。

- **SEE** [m:IRB::Context#use_tracer]
#%else
- **param** `val` -- [lib:tracer] を有効にする場合に true を指定します。

- **SEE** [lib:tracer], [m:IRB::Context#use_tracer]
#%end
