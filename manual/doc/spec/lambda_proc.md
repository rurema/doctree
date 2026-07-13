# 手続きオブジェクトの挙動の詳細

 - [ref:def]
 - [ref:proc_generation]
 - [ref:should_use_next]
 - [ref:block]
 - [ref:lambda_proc]
 - [ref:orphan]

### 手続きオブジェクトとは {#def}

手続きオブジェクトとはブロックをコンテキスト(ローカル変数のスコープやスタックフレーム)と
ともにオブジェクトにしたものです。[c:Proc] クラスのインスタンスとして実現されています。

ブロック内では、新たなスコープが導入されるとともに、外側のローカル変数を参照できます。
Proc オブジェクトがローカル変数のスコープを保持していることは以下の例で変数 var を
参照できていることからわかります。

```ruby title="例"
var = 1
$foo = Proc.new { var }
var = 2

def foo
 $foo.call
end

p foo       # => 2
```

#@include(../../api/_builtin/lambda_proc)
