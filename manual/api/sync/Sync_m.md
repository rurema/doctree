---
library: sync
alias:
  - Synchronizer_m
until: "2.7.0"
---
# module Sync_m

スレッド同期機構である再入可能な reader/writer ロック機能を Mix-in により提供します。

includeしたクラスではinitializeでsuperを呼び出しておく必要があります。

## Constants
### const UN -> Symbol

ロックされていない状態を表す定数です。

### const EX -> Symbol

排他ロックされている状態を表す定数です。
オブジェクトの状態を更新する場合のように、
1つのスレッドがオブジェクトを独占的に使用したい場合に用います。
排他ロック中に他のスレッドはオブジェクトを共有/排他ロックできません。

### const SH -> Symbol

共有ロックされている状態を表す定数です。
複数のスレッドが同時にオブジェクトを使用できる場合に用います。
複数のスレッドが共有ロックしている場合、
どのスレッドもオブジェクトを排他ロックできません。

## Instance Methods
### def sync_mode -> Symbol

現在のロック状態を返します。

### def sync_locked? -> bool
### def locked? -> bool

ロックされているかどうかを返します。

### def sync_shared? -> bool
### def shared? -> bool

共有ロックされているかどうかを返します。

### def sync_exclusive? -> bool
### def exclusive? -> bool

排他ロックされているかどうかを返します。

### def sync_try_lock(mode = EX) -> bool
### def try_lock(mode = EX) -> bool

ロック状態を変更します。
変更できたかどうかをtrueかfalseで返し、ブロックしません。

- **param** `mode` -- 変更後の状態を指定します。
            通常、 [m:Sync_m::EX], [m:Sync_m::SH] のどれかを指定します。

### def sync_lock(mode = EX) -> self
### def lock(mode = EX) -> self

ロック状態を変更します。
変更できるまで現在のスレッドの実行をブロックします。

- **param** `mode` -- 変更後の状態を指定します。
            通常、 [m:Sync_m::EX], [m:Sync_m::SH] のどれかを指定します。

### def sync_unlock(mode = EX) -> self
### def unlock(mode = EX) -> self

ロックを解除します。

- **param** `mode` -- 変更後の状態を指定します。
            通常、 [m:Sync_m::UN], [m:Sync_m::EX], [m:Sync_m::SH] のどれかを指定します。

### def sync_synchronize(mode = EX) {...} -> object
### def synchronize(mode = EX) {...} -> object

ロック状態を変更してブロックを実行します。
ブロックの実行結果を返します。

- **param** `mode` -- 変更後の状態を指定します。
            通常、 [m:Sync_m::UN], [m:Sync_m::EX], [m:Sync_m::SH] のどれかを指定します。

### def sync_waiting -> [Thread]
#@todo

### def sync_waiting=(arr)
#@todo

### def sync_upgrade_waiting -> [Thread]
#@todo

### def sync_upgrade_waiting=(arr)
#@todo

### def sync_sh_locker -> Hash
#@todo

### def sync_sh_locker=(hash)
#@todo

### def sync_ex_locker -> Thread | nil
#@todo

### def sync_ex_locker=(thread)
#@todo

### def sync_ex_count -> Integer
#@todo

### def sync_ex_count=(count)
#@todo

### def sync_extend
#@todo

### def sync_inspect
#@todo

