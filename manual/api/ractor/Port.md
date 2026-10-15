---
library: _builtin
since: "4.0"
---
# class Ractor::Port < Object

Ractor 間でメッセージを交換するための仕組みを提供するクラスです。

## Class Methods

### def Ractor::Port.new -> Ractor::Port

## Instance Methods

### def <<(msg, move: false)
### def send(msg, move: false)

Port にメッセージを送信します。

- **param** `msg` -- 送信するメッセージを指定します。
- **param** `move` -- msg を「移動」する場合、true を指定します。

### def close

Port を閉じます。

閉じられた Port に対して [m:Ractor::Port#send] による送信を試みた場合、 Ractor::ClosedError が発生します。
Port が閉じられる前に送信され、未受信のメッセージがある場合、その数ぶんだけ [m:Ractor::Port#receive] を使って受信できます。

Port を作成した Ractor 以外で close を呼ぶことはできません。

### def closed? -> bool

Port が閉じられている場合、true を返します。

#%since 4.1
### def receive(timeout: nil) -> object | nil
#%else
### def receive -> object
#%end

Port に送信されたメッセージを受信します。

メッセージキューが空の場合はブロックします。

#%since 4.1
- **param** `timeout` -- メッセージを待つ秒数を数値で指定します。nil の場合は、メッセージが届くまで待ち続けます。指定した秒数が経過しても届かなかった場合は nil を返します。0 を指定した場合はブロックしません。
- **raise** `ArgumentError` -- `timeout` が負の場合に発生します。
#%end
- **raise** `Ractor::ClosedError` -- Port が閉じられている場合に発生します。
#%since 4.1

```ruby title="例: timeout を指定"
port = Ractor::Port.new
p port.receive(timeout: 0.1) # => nil
```

#%end
