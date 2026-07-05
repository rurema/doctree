#@since 1.9.2
### def pp(*obj)    -> object
#@else
### def pp(*obj)    -> nil
#@end

指定されたオブジェクト obj を標準出力に見やすい形式(プリティプリント)で出力します。
obj それぞれを引数として [m:PP.pp] を呼ぶことと同等です。

#@since 2.5.0
初回呼び出し時に自動的に [lib:pp] を require します。
#@end

- **param** `obj` -- 表示したいオブジェクトを指定します。

```ruby title="例"
require 'pp'

b = [1, 2, 3] * 4
a = [b, b]
a << a
pp a

#=> [[1, 2, 3, 1, 2, 3, 1, 2, 3, 1, 2, 3],
#    [1, 2, 3, 1, 2, 3, 1, 2, 3, 1, 2, 3],
#    [...]]
```

- **SEE** [m:PP.pp]
