---
library: sync
until: "2.7.0"
---
# class Sync_m::UnknownLocker < Sync_m::Err

スレッドがロックされているべきタイミングでロックさせない場合に発生する例外です。

## Singleton Methods

### def Fail(*options) -> ()

自身に定義されているメッセージをセットして例外を発生させます。

