### Proc オブジェクトの生成 {#proc_generation}

Proc オブジェクトを生成する手段には、主に以下の四つがあります。

* [m:Proc.new]
* [m:Kernel?.proc]
* [m:Kernel?.lambda]
* `->(){ }` (`->` を使った lambda の短縮記法)

このうち [m:Proc.new] と [m:Kernel?.proc] は同じ性質の Proc オブジェクトを生成し、
[m:Kernel?.lambda] と `->(){ }` も互いに同じ性質の Proc オブジェクトを生成しますが、
前二者と後二者では、生成される Proc オブジェクトの引数の扱いや return・break の
挙動などが異なります(詳細は後述)。生成された Proc オブジェクトが後二者
(lambda)に該当するかどうかは [m:Proc#lambda?] で調べることができます。

このほか、メソッド呼び出しにブロックを渡した場合、そのブロックをブロック引数
(`&block` など)で受け取ると Proc オブジェクトが生成されます。

### 手続きを中断して値を返す {#should_use_next}

手続きオブジェクトを中断して、呼出し元(呼び出しブロックでは yield、それ以外では [m:Proc#call])
へジャンプし値を返すには next を使います。break や return ではありません。


```ruby title="例"
def foo
  f = Proc.new{
    next 1
    2              # この行に到達することはない
  }
end

p foo().call       #=> 1
```

### Proc オブジェクトをブロック付きメソッド呼び出しに使う {#block}

ブロック付きメソッドに対して Proc オブジェクトを \`&\` を指定して渡すと
呼び出しブロックのように動作します。
しかし、厳密には以下の違いがあります。
これらは、Proc オブジェクトが呼び出しブロックとして振舞う際の制限です。

```ruby title="問題なし"
(1..5).each { break }
```

```ruby title="LocalJumpError が発生します。"
pr = Proc.new { break }
(1..5).each(&pr)
```

### lambda と proc と Proc.new とイテレータの違い {#lambda_proc}

[m:Kernel?.lambda] と [m:Proc.new] はどちらも [c:Proc] クラスのインスタンス(手続きオブジェクト)を生成しますが、
生成された手続きオブジェクトはいくつかの場面で挙動が異なります。 lambda の生成する手続きオブジェクトのほうが
よりメソッドに近い働きをするように設計されています。

[m:Kernel?.proc] は Proc.new と同じになります。
引数に & を付けることで手続きオブジェクト化したブロックは、Proc.new で生成されたそれと
同じように振る舞います。

#### 引数の扱い

lambda のほうがより厳密です。引数の数が違っていると（メソッドのように）エラーになります。
Proc.new は引数を多重代入に近い扱い方をします。

```ruby title="Proc.new は引数の数が違っていてもエラーにならない"
b = Proc.new{|a,b,c|
  p a,b,c
}
p b.call(2, 4)
#=> 2
    4
    nil
```

```ruby title="lambda は引数の数が違うとエラーになる"
b = lambda{|a,b,c|
  p a,b,c
}
p b.call(2, 4)
# => wrong number of arguments (given 2, expected 3)
```

[ref:d:spec/call#block_arg] も参照してください。

#### ジャンプ構文の挙動の違い

return と break は、lambda と Proc.new では挙動が異なります。
例えば return を行った場合、lambda では手続きオブジェクト自身を抜けますが、
Proc.new では手続きオブジェクトを囲むメソッドを抜けます。

```ruby title="例"
def test_proc
  f = Proc.new { return :from_proc }
  f.call
  return :from_method
end

def test_lambda
  f = lambda { return :from_lambda }
  f.call
  return :from_method
end

def test_block
  tap { return :from_block }
  return :from_method
end

p test_proc()   #=> :from_proc
p test_lambda() #=> :from_method
p test_block()  #=> :from_block
```

以下の表は、手続きオブジェクトの実行を上の例と同じように、手続きオブジェクトが定義されたのと
同じメソッド内で行った場合の結果です。

```text
               return                          next                        break
Proc.new   メソッドを抜ける            手続きオブジェクトを抜ける   例外が発生する
proc       メソッドを抜ける            手続きオブジェクトを抜ける   例外が発生する
lambda     手続きオブジェクトを抜ける  手続きオブジェクトを抜ける   手続きオブジェクトを抜ける
イテレータ メソッドを抜ける            手続きオブジェクトを抜ける   手続きオブジェクトを抜ける
```



### orphan な手続きオブジェクトの挙動 {#orphan}

Proc を生成したメソッドから脱出した後、手続きオブジェクトからの
return, break は例外 [c:LocalJumpError] を発生させます。
ただし、上でも説明した通り lambda で生成した手続きオブジェクトはメソッドと同じように振る舞う
ことを意図されているため、例外 [c:LocalJumpError] は発生しません。

```ruby title="例"
def foo
  Proc.new { return }
end

foo.call
#@since 3.4
# => in 'block in Object#foo': unexpected return (LocalJumpError)
#@else
# => in `block in foo': unexpected return (LocalJumpError)
#@end
```

以下の表は、手続きオブジェクトの実行を上の例と同じように、手続きオブジェクトが定義されたメソッドを
脱出してから行った場合の結果です。

```text
               return                          next                        break
Proc.new   例外が発生する              手続きオブジェクトを抜ける   例外が発生する
proc       例外が発生する              手続きオブジェクトを抜ける   例外が発生する
lambda     手続きオブジェクトを抜ける  手続きオブジェクトを抜ける   手続きオブジェクトを抜ける
```
