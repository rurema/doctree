= 手続きオブジェクトの挙動の詳細

 * [[ref:def]]
 * [[ref:should_use_next]]
 * [[ref:block]]
 * [[ref:lambda_proc]]
 * [[ref:orphan]]

===[a:def] 手続きオブジェクトとは

手続きオブジェクトとはブロックをコンテキスト(ローカル変数のスコープやスタックフレーム)と
ともにオブジェクトしたものです。[[c:Proc]] クラスのインスタンスとして実現されています。

ブロック内では、新たなスコープが導入されるとともに、外側のローカル変数を参照できます。
Proc オブジェクトがローカル変数のスコープを保持していることは以下の例で変数 var を
参照できていることからわかります。

例:

 var = 1
 $foo = Proc.new { var }
 var = 2 
 
 def foo
   $foo.call
 end 

 p foo       # => 2

#@include(../../api/src/_builtin/lambda_proc)
