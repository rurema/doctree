---
library: timeout
until: "3.1"
---
# reopen Kernel

## Private Instance Methods

### def timeout(sec) {|i| .... }                        -> object
### def timeout(sec, exception_class = nil) {|i| .... } -> object

ブロックを sec 秒の期限付きで実行します。
ブロックの実行時間が制限を過ぎたときは例外
[c:Timeout::Error] が発生します。

exception_class を指定した場合には [c:Timeout::Error] の代わりに
その例外が発生します。
ブロックパラメータ i は sec がはいります。

また sec が 0 もしくは nil のときは制限時間なしで
ブロックを実行します。

- **param** `sec` -- タイムアウトする時間を秒数で指定します.
- **param** `exception_class` -- タイムアウトした時、発生させる例外を指定します.

### 注意

timeout による割り込みは Thread によって実現されています。C 言語
レベルで実装され、Ruby のスレッドが割り込めない処理に対して
timeout は無力です。
そのような
ものは実用レベルでは少ないのですが、例をあげると Socket などは
DNSの名前解決に時間がかかった場合割り込めません
([lib:resolv-replace] を使用する必要があります)。
その処理を Ruby で実装しなおすか C 側で Ruby
のスレッドを意識してあげる必要があります。
#@# [[unknown:timeoutの落し穴|trap::timeout]]も参照

