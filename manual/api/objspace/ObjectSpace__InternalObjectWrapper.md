---
library: objspace
since: "2.0.0"
---
# class ObjectSpace::InternalObjectWrapper < Object

Ruby の内部オブジェクトをラップするクラスです。

内部オブジェクトとは、include したモジュールを表す iclass(`T_ICLASS`)のように、CRuby の実装の都合で作られ、通常は Ruby のコードからは直接見えないオブジェクトです。

[m:ObjectSpace?.reachable_objects_from] と [m:ObjectSpace?.reachable_objects_from_root] は、到達できるオブジェクトが内部オブジェクトのときにこのクラスのインスタンスを返します。[m:ObjectSpace?.internal_super_of] など他の ObjectSpace のメソッドもラップされた内部オブジェクトを返すことがあります。

このクラスはデバッグやイントロスペクションのためのものです。アプリケーションのコードでは使わないでください。ラップされるオブジェクトやこのクラスの詳細は処理系に依存し、将来のバージョンで変更される可能性があります。

## Instance Methods

### def type -> Symbol

ラップしている内部オブジェクトの型をシンボルで返します。

例えば、include したモジュールは内部的には `T_ICLASS` のオブジェクトとして表現されています。

```ruby title="例"
require 'objspace'

module M; end
class A; include M; end

iclass = ObjectSpace.internal_super_of(A)
p iclass.type # => :T_ICLASS
```

返されるシンボルの集合は処理系に依存します。

### def inspect -> String

ラップしている内部オブジェクトの型とアドレスを含む、人間が読みやすい形式の文字列を返します。

```ruby title="例"
require 'objspace'

module M; end
class A; include M; end

p ObjectSpace.internal_super_of(A) # => #<InternalObject:0x... T_ICLASS>
```

### def internal_object_id -> Integer

ラップしている内部オブジェクトの [m:Object#object_id] を返します。

この値は `ObjectSpace::InternalObjectWrapper` のインスタンスではなく、ラップされている内部オブジェクトを識別するものです。デバッグやイントロスペクションにだけ使ってください。内部オブジェクトの object_id は処理系に依存します。
