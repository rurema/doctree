= trap::NilClass

nil (NilClassのインスタンス) にもいくつかメソッドが定義されている。

以下、リファレンスマニュアルからコピペ：

--- self & other

    常に (({false})) を返します。

--- self | other
--- self ^ other

    ((|other|)) が真なら true を偽なら (({false})) を返します。

--- nil?

    常に (({true})) を返します。

--- to_a

    空の配列(({[]}))を返します。

--- to_f        ((<ruby 1.7 feature>))

    0.0 を返します。

--- to_i

    0 を返します。

--- to_s

    空文字列(({""}))を返します。
