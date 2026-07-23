---
library: _builtin
since: "3.0"
---
# class Ractor < Object

並列プログラミングの仕組みを提供するクラスです。

## Class Methods

### def new(*args, name: nil) {|*args| ... } -> Ractor

Ractor を生成して、ブロックの評価を開始します。
生成した Ractor を返します。

- **param** `args` -- ブロックの引数として渡されます。
            値が shareable である場合はそのインスタンスが、そうでない場合はコピーが試みられた値が渡されます。
            コピーできない値であった場合は例外が発生します。
- **param** `name` -- Ractor の名前を指定します。

#@since 3.4
### def [](sym) -> object | nil

このメソッドを呼び出した Ractor の Ractor-local storage の sym に対応するデータを取り出します。
sym に対応するデータがなければ nil を返します。

- **param**  `sym` -- Ractor-local storage のキーを指定します。
- **return** --     Ractor-local storage に格納されている値を返します。

### def []=(sym, val)

- **param** `sym` -- Ractor-local storage のキーを指定します。
- **param** `val` -- 格納するデータを指定します。
#@end

### def count -> Integer

実行中の Ractor の数を返します。

### def current -> Ractor

このメソッドを呼び出された Ractor を返します。

### def main -> Ractor

main Ractor（プログラムの実行が開始された Ractor）を返します。

#@since 3.4
### def main? -> bool

このメソッドを呼び出した Ractor が main Ractor であるとき、true を返します。
#@end

### def make_shareable(obj, copy: false) -> object

obj が shareable になるよう変換します。

obj が shareable でない場合、obj と obj が参照する shareable でないオブジェクトをすべて freeze します。

- **param** `obj` -- Shareable にしたいオブジェクトを指定します。
- **param** `copy` -- true の場合、obj を変更する代わりに obj のコピーを作成し shareable にします。

### def receive -> object
### def recv -> object

#@since 4.0
このメソッドを呼び出した Ractor の default port からメッセージを受信します。

- **SEE** [m:Ractor::Port#receive]
#@else
このメソッドを呼び出した Ractor が受信したメッセージを取り出して返します。
メッセージが届くまでブロックします。

他の Ractor から [m:Ractor#send] で送られたメッセージを受信します。
#@end

#@until 4.0
### def receive_if {|msg| ... } -> object

このメソッドを呼び出した Ractor が受信したメッセージのうち、
ブロックの評価結果が真になる最初のメッセージを受信して返します。
#@end

#@since 4.0
### def select(*ports) -> [object, object]

引数で指定した Ractor または [c:Ractor::Port] のいずれかが受信可能になるまで待ち、
受信可能になったものと受信した値の配列を返します。
#@else
### def select(*ractors, yield_value: nil, move: false) -> [object, object]

引数で指定した Ractor のいずれかが [m:Ractor.yield] などで送信可能になるまで待ち、
その Ractor と受信したオブジェクトの配列 [Ractor, obj] を返します。
受信したのが現在の Ractor 自身であった場合は、Ractor の代わりに :receive シンボルが返ります。
yield_value を指定すると、他の Ractor が [m:Ractor#take] を呼んだときにその値が yield され、
[:yield, nil] が返ります。move が真のとき yield_value は移動されます。
#@end

### def shareable?(obj) -> bool

obj が shareable である場合、true を返します。

- **param** `obj` -- Shareable であるか判定したいオブジェクトを指定します。

#@since 3.4
### def store_if_absent(key) { ... } -> object

このメソッドを呼び出した Ractor の Ractor-local storage の key データがない場合、
ブロックを評価した結果を格納します。
格納した値を返します。

- **param** `key` -- Ractor-local storage のキーを指定します。
#@end

#@until 4.0
### def yield(obj, move: false) -> object

現在の Ractor の outgoing port に obj を送信します。
別の Ractor が [m:Ractor#take] でこのメッセージを受信するまでブロックします。

- **param** `obj` -- 送信するオブジェクトを指定します。
- **param** `move` -- obj を「移動」する場合は true を指定します。
#@end

## Instance Methods

#@since 4.0
### def close -> bool

Default port を閉じます。

self がこのメソッドを呼び出した Ractor ではない場合、Ractor::Error が発生します。

#@end

#@since 4.0
### def default_port -> Ractor::Port

self の default port を返します。

#@end

#@since 4.0
### def join -> Ractor

self が終了するまで待ちます。
Ractor の実行が例外で終了した場合には、 [m:Ractor#value]を呼び出し、その例外を再発生させます。

#@end

#@since 4.0
### def monitor(port) -> bool

port を self の監視ポートとして登録します。
self が終了すると、port は :exited（例外なく終了した場合）または
:aborted（未処理の例外で終了した場合）というシンボルを受信します。

監視を登録できた（self がまだ終了していない）場合は true を返します。
self が既に終了していた場合は false を返し、port は直ちに終了を表すシンボルを受信します。

#@end

### def name -> String

self の名前を返します。

- **SEE** [m:Ractor.new]

### def <<(msg, move: false) -> self
### def send(msg, move: false) -> self

#@since 4.0
Ractor の default port に対してメッセージを送信します。
#@else
self にメッセージを送信します。
送られたメッセージは self が [m:Ractor.receive] で受信できます。
#@end

- **param** `msg` -- 送信するメッセージを指定します。
- **param** `move` -- msg を「移動」する場合は true を指定します。

#@since 4.0
- **SEE** [m:Ractor::Port#send]
#@end

#@until 4.0
### def take -> object

self の outgoing port からメッセージを受信します。
self が [m:Ractor.yield] で送ったメッセージ、または self のブロックが返した値を受け取ります。
メッセージが届くまでブロックします。
#@end

#@since 4.0
### def unmonitor(port) -> self

[m:Ractor#monitor] で登録した port の監視を解除します。

#@end

#@since 4.0
### def value -> object

self が終了するまで待ち、その Ractor のブロックが返した値を返します。
Ractor の実行が例外で終了した場合には、その例外を再発生させます。

#@end
