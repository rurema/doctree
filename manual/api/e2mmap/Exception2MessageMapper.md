---
library: e2mmap
alias:
  - Exception2MessageMapper::E2MM
until: "2.7.0"
---
# module Exception2MessageMapper

例外クラスに特定のエラーメッセージ用フォーマットを関連づけるためのモジュールです。

## Singleton Methods
### def def_e2message(klass, exception_class, message_format) -> Class

すでに存在する例外クラス exception_class に、
エラーメッセージ用フォーマット message_format を関連づけます。

- **param** `klass` -- 一階層上となるクラス名を指定します。

- **param** `exception_class` -- メッセージを登録する例外クラスを指定します。

- **param** `message_format` -- メッセージのフォーマットを指定します。
                    [m:Kernel?.sprintf] のフォーマット文字列と同じ形式を使用できます。

- **return** -- exception_class を返します。

### def def_exception(klass, exception_name, message_format, superklass = StandardError) -> Class

exception_name という名前の例外クラスを定義します。

- **param** `klass` -- 一階層上となるクラス名を指定します。

- **param** `exception_name` -- 例外クラスの名前をシンボルで指定します。

- **param** `message_format` -- メッセージのフォーマットを指定します。
                    [m:Kernel?.sprintf] のフォーマット文字列と同じ形式を使用できます。

- **param** `superklass` -- 定義する例外クラスのスーパークラスを指定します。
                  省略すると [c:StandardError] を使用します。

- **return** -- 定義した例外クラスを返します。

### def e2mm_message(klass, exp) -> String | nil
### def message(klass, exp) -> String | nil
#@todo

- **param** `klass` --

- **param** `exp` --

### def extend_object(cl) -> ()
#@todo

- **param** `cl` --

### def Raise(klass = E2MM, exception_class = nil, *rest) -> ()
### def Fail(klass = E2MM, exception_class = nil, *rest)  -> ()

登録されている情報を使用して、例外を発生させます。

- **param** `klass` -- 一階層上となるクラス名を指定します。

- **param** `exception_class` -- 例外クラス。

- **param** `rest` -- メッセージに埋め込む値。

- **raise** `Exception2MessageMapper::ErrNotRegisteredException` -- 指定された例外クラスに対応するメッセージが存在しない場合に発生します。

## Instance Methods

### def bind(cl) -> ()
#@todo

- **param** `cl` -- xxx

### def Raise(exception_class = nil, *rest) -> ()
### def Fail(exception_class = nil, *rest)  -> ()

登録されている情報を使用して、例外を発生させます。

- **param** `exception_class` -- 例外クラス。

- **param** `rest` -- メッセージに埋め込む値。

- **raise** `Exception2MessageMapper::ErrNotRegisteredException` -- 指定された例外クラスに対応するメッセージが存在しない場合に発生します。

```ruby title="例"
class Foo
  extend Exception2MessageMapper
  p def_exception :NewExceptionClass, "message...%d, %d and %d" # =>
    
  def foo
    Raise NewExceptionClass, 1, 2, 3
  end
end
  
p Foo.new().foo() #=> in `Raise': message...1, 2 and 3 (Foo::NewExceptionClass)
                #   という例外が発生します。
  
p Foo.Raise Foo::NewExceptionClass, 1, 3, 5  #=> in `Raise': message...1, 3 and 5 (Foo::NewExceptionClass)
                                           #   という例外が発生します。
```

### def fail(exception_class = nil, *rest) -> ()

登録されている情報を使用して、例外を発生させます。

- **param** `exception_class` -- 例外クラス。

- **param** `rest` -- メッセージに埋め込む値。

- **raise** `Exception2MessageMapper::ErrNotRegisteredException` -- 指定された例外クラスに対応するメッセージが存在しない場合に発生します。

### def def_e2message(exception_class, message_format) -> Class

すでに存在する例外クラス exception_class に、
エラーメッセージ用フォーマット message_format を関連づけます。

このフォーマットは [m:Exception2MessageMapper#Raise],
[m:Exception2MessageMapper#Fail] で使用します。

- **param** `exception_class` -- メッセージを登録する例外クラスを指定します。

- **param** `message_format` -- メッセージのフォーマットを指定します。
                    [m:Kernel?.sprintf] のフォーマット文字列と同じ形式を使用できます。

- **return** -- exception_class を返します。

### def def_exception(exception_name, message_format, superclass = StandardError) -> Class

exception_name という名前の例外クラスを定義します。

- **param** `exception_name` -- 定義する例外クラスの名前をシンボルで指定します。

- **param** `message_format` -- メッセージのフォーマット。

- **param** `superclass` -- 定義する例外のスーパークラスを指定します。
                  省略すると [c:StandardError] を使用します。

