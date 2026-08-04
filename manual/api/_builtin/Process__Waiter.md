---
library: _builtin
---
# class Process::Waiter < Thread

[m:Process?.detach] が返す、子プロセスの終了を監視するスレッドを表すクラスです。

[c:Thread] のサブクラスであり、監視している子プロセスのプロセス ID を保持しています。

- **SEE** [m:Process?.detach]

## Instance Methods

### def pid -> Integer
{: since="2.2.0"}

監視している子プロセスのプロセス ID を返します。
