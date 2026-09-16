---
library: _builtin
since: "4.1"
alias:
  - MonitorMixin::ConditionVariable
---
# class Thread::Monitor::ConditionVariable < Object

[c:Thread::Monitor] と [c:MonitorMixin] のための条件変数クラスです。
[m:Thread::Monitor#new_cond] や [m:MonitorMixin#new_cond] が返します。ユーザが
Thread::Monitor::ConditionVariable.new を直接呼ぶことはありません。

Ruby 4.0 までは [lib:monitor] ライブラリの `MonitorMixin::ConditionVariable` クラスとして提供されていましたが、Ruby 4.1 で組み込みクラスになりました。`MonitorMixin::ConditionVariable` は、[lib:monitor] ライブラリを読み込むと `Thread::Monitor::ConditionVariable` の別名として引き続き使えます。

## Instance Methods

### def broadcast -> ()
{: since=""}

その条件変数で待っている全てのスレッドの実行を再開します。

- **SEE** [m:Thread::Monitor::ConditionVariable#signal]

### def signal -> ()
{: since=""}

その条件変数で待っているスレッドがあれば実行を再開させます。

複数のスレッドが待っている場合には1つのスレッドのみ実行を再開します。

- **SEE** [m:Thread::Monitor::ConditionVariable#broadcast]

### def wait(timeout = nil) -> bool
{: since=""}

モニタのロックを開放し、現在のスレッドを停止します。

これを呼ぶスレッドはモニタのロックを保持している必要があります。

[m:Thread::Monitor::ConditionVariable#signal] や
[m:Thread::Monitor::ConditionVariable#broadcast]
で起こされるまでスレッドは停止し続けます。

timeout を与えた場合は最大 timeout 秒まで停止した後にスレッドを再開します。

実行を再開したスレッドはモニタのロックを保持した状態になります。
これによって危険領域(critical section)上で動作しているスレッドはただ一つになり、排他を実現します。

true を返します。timeout が与えられていて待ち時間が timeout を越えた場合は false を返します。

- **param** `timeout` -- タイムアウトまでの秒数。指定しなかった場合はタイムアウトしません。

- **raise** `ThreadError` -- ロックを持っていないスレッドがこのメソッドを呼びだした場合に発生します

- **SEE** [m:Thread::Monitor::ConditionVariable#wait_while], [m:Thread::Monitor::ConditionVariable#wait_until]

### def wait_while { ... } -> ()
{: since=""}

モニタのロックを開放し、現在のスレッドをブロックで指定した条件を満たしている間停止します。

[m:Thread::Monitor::ConditionVariable#signal] や
[m:Thread::Monitor::ConditionVariable#broadcast] でスレッドが起こされると、ロックを取得し、ブロックを評価しその結果によってこのメソッドから抜け処理を継続するか再びロックを開放しスレッドを停止するかを決めます。

- **raise** `ThreadError` -- ロックを持っていないスレッドがこのメソッドを呼びだした場合に発生します
- **SEE** [m:Thread::Monitor::ConditionVariable#wait]

### def wait_until { ... } -> ()
{: since=""}

モニタのロックを開放し、現在のスレッドをブロックで指定した条件を満たすまで停止します。

[m:Thread::Monitor::ConditionVariable#signal] や
[m:Thread::Monitor::ConditionVariable#broadcast] でスレッドが起こされると、ロックを取得し、ブロックを評価しその結果によってこのメソッドから抜け処理を継続するか再びロックを開放しスレッドを停止するかを決めます。

- **SEE** [m:Thread::Monitor::ConditionVariable#wait]
