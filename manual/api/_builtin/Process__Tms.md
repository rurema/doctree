---
library: _builtin
---
# class Process::Tms < Struct

[m:Process?.times] の返り値を表現する構造体です。

この機能がサポートされているプラットフォーム上でプロセスの
処理時間に関する情報を保持します。プラットフォームによっては
使えない値があります。

- **SEE** [m:Process?.times]

## Instance Methods

### def cstime -> Float
終了した子プロセスのシステム CPU 時間の合計(秒)を返します。

Windows 上では常に 0 を返します。

### def cstime=(n)
終了した子プロセスのシステム CPU 時間の合計(秒)をセットします。

### def cutime -> Float
終了した子プロセスのユーザー CPU 時間の合計(秒)を返します。

Windows 上では常に 0 を返します。

### def cutime=(n)
終了した子プロセスのユーザー CPU 時間の合計(秒)をセットします。

### def stime -> Float
システム CPU 時間を返します。

### def stime=(n)
システム CPU 時間をセットします。

### def utime -> Float
ユーザー CPU 時間を返します。

### def utime=(n)
ユーザー CPU 時間をセットします。
