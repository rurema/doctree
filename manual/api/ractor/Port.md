---
library: _builtin
since: "4.0"
---
# class Ractor::Port < Object

Ractor 間でメッセージを交換するための仕組みを提供するクラスです。

## Class Methods

### def new -> Ractor::Port

## Instance Methods

### def <<(msg, move: false)
### def send(msg, move: false)

Port にメッセージを送信します。

- **param** `msg` -- 送信するメッセージを指定します。
- **param** `move` -- msg を「移動」する場合、true を指定します。

### def close

Port を閉じます。

閉じられた Port に対して [m:Ractor::Port#send] による送信を試みた場合、 Ractor::ClosedError が発生します。
Port が閉じられる前に送信され、未受信のメッセージがある場合、
その数ぶんだけ [m:Ractor::Port#receive] を使って受信できます。

Port を作成した Ractor 以外で close を呼ぶことはできません。

### def closed? -> bool

Port が閉じられている場合、true を返します。

### def receive -> object

Port に送信されたメッセージを受信します。

メッセージキューが空の場合はブロックします。
