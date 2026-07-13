---
type: library
until: "2.7.0"
---
例外クラスに特定のエラーメッセージ用フォーマットを関連づけるためのライブラリです。

### 使い方

**1.** クラス定義の中で、Exception2MessageMapper を extend すれば、
def_e2message メソッドや def_exception メソッドが使えます。
これらで例外クラスとメッセージを関連づけることができます。

```text title="例"
class Foo
  extend Exception2MessageMapper
  def_e2message ExistingExceptionClass, "message..."
  def_exception :NewExceptionClass, "message...", StandardError
  ...
end
  
foo = Foo.new
foo.Fail ....
```

**2.** 何度も使いたい例外クラスは、クラスの代わりにモジュールで定義して、
それを include して使います。

```text title="例"
module ErrorMod
  extend Exception2MessageMapper
  def_e2message ExistingExceptionClass, "message..."
  def_exception :NewExceptionClass, "message...", StandardError
  ...
end
class Foo
  include ErrorMod
  ...
end
  
foo = Foo.new
foo.Fail ....
```

**3.** 例外を設定したクラスのインスタンス以外から例外を呼ぶこともできます。

```text title="例"
module ErrorMod
  extend Exception2MessageMapper
  def_e2message ExistingExceptionClass, "message..."
  def_exception :NewExceptionClass, "message...", StandardError
  ...
end
class Foo
  extend Exception2MessageMapper
  include ErrorMod
  ...
end
  
Foo.Fail NewExceptionClass, arg...
Foo.Fail ExistingExceptionClass, arg...
```

