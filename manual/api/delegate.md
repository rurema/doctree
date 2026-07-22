---
type: library
category: DesignPattern
---
メソッドの委譲 (delegation) を行うためのライブラリです。

[c:Delegator] クラスは指定したオブジェクトにメソッドの実行を委譲します。
[c:Delegator] クラスを利用する場合はこれを継承して
[m:Delegator#__getobj__] メソッドを再定義して委譲先のオブジェクトを指定します。

[c:SimpleDelegator] は [c:Delegator] の利用例の一つであり、
コンストラクタに渡されたオブジェクトにメソッドの実行を委譲します。

[m:Kernel#DelegateClass] は 引数で渡されたクラスのインスタンスをひとつとり、
そのオブジェクトにインスタンスメソッドを委譲するクラスを定義して返します。

### 参考

  - Rubyist Magazine - 標準添付ライブラリ紹介【第 6 回】委譲 <https://magazine.rubyist.net/articles/0012/0012-BundledLibraries.html>

# reopen Kernel

## Private Instance Methods

### def DelegateClass(superclass) -> object

クラス superclass のインスタンスへメソッドを委譲するクラスを定義し、
そのクラスを返します。

- **param** `superclass` -- 委譲先となるクラス

```ruby title="例"
require 'delegate'

class ExtArray < DelegateClass(Array)
  def initialize
    super([])
  end
end
a = ExtArray.new
p a.class   # => ExtArray
a.push 25
p a         # => [25]
```

# class Delegator < Object

サブクラスにメソッド委譲の仕組みを提供する抽象クラス。

メソッド委譲を行う場合は、本クラスを継承し[m:Delegator#__getobj__]を再定義する必要があります。

具体的な使用例については、[c:SimpleDelegator]を参照してください。

## Class Methods

#@#--- delegation_block
#@# 見つからない

#@#--- public_api
#@# nodoc

#@# --- const_missing
#@# 見つからない

## Instance Methods

### def ==(obj) -> bool

自身が与えられたオブジェクトと等しい場合は、真を返します。
そうでない場合は、偽を返します。

- **param** `obj` -- 比較対象のオブジェクトを指定します。

### def !=(obj) -> bool

自身が与えられたオブジェクトと等しくない場合は、真を返します。
そうでない場合は、偽を返します。

- **param** `obj` -- 比較対象のオブジェクトを指定します。

### def ! -> bool

自身を否定します。

### def __getobj__ -> object

委譲先のオブジェクトを返します。

本メソッドは、サブクラスで再定義する必要があり、
デフォルトでは [c:NotImplementedError] が発生します。

- **raise** `NotImplementedError` -- サブクラスにて本メソッドが再定義されていない場合に発生します。

### def __setobj__(obj) -> object

委譲先のオブジェクトをセットします。

- **param** `obj` -- 委譲先のオブジェクトを指定します。

- **raise** `NotImplementedError` -- サブクラスにて本メソッドが再定義されていない場合に発生します。

### def marshal_dump -> object

シリアライゼーションをサポートするために[m:Delegator#__getobj__] が返すオブジェクトを返します。

### def marshal_load(obj) -> object

シリアライズされたオブジェクトから、[m:Delegator#__getobj__] が返すオブジェクトを再現します。

- **param** `obj` -- [m:Delegator#marshal_dump]の戻り値のコピー

### def method_missing(m, *args) -> object

渡されたメソッド名と引数を使って、[m:Delegator#__getobj__] が返すオブジェクトへメソッド委譲を行います。

- **param** `m` -- メソッドの名前（シンボル）

- **param** `args` -- メソッドに渡された引数

- **return** -- 委譲先のメソッドからの返り値

- **SEE** [m:BasicObject#method_missing]

### def respond_to?(m) -> bool

[m:Delegator#__getobj__] が返すオブジェクトが メソッド m を持つとき真を返します。

- **param** `m` -- メソッド名

- **SEE** [m:Object#respond_to?]

### def freeze -> self

自身を凍結します。

- **SEE** [m:Object#freeze]

### def methods -> [Symbol]

そのオブジェクトに対して呼び出せるメソッド名の一覧を返します。
このメソッドは public メソッドおよび protected メソッドの名前を返します。

- **SEE** [m:Object#methods]

### def protected_methods(all = true) -> [Symbol]

そのオブジェクトが理解できる protected メソッド名の一覧を返します。

- **param** `all` -- 偽を指定すると __getobj__ のスーパークラスで定義されたメソッドを除きます。

- **SEE** [m:Object#protected_methods]

### def public_methods(all = true) -> [Symbol]

そのオブジェクトが理解できる public メソッド名の一覧を返します。

- **param** `all` -- 偽を指定すると __getobj__ のスーパークラスで定義されたメソッドを除きます。

- **SEE** [m:Object#public_methods]

### def respond_to_missing?(m, include_private) -> bool

- **param** `m` -- メソッド名を指定します。

- **param** `include_private` -- 真を指定すると private メソッドも調べます。

## Constants

