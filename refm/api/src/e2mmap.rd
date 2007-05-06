例外クラスに特定のエラーメッセージ用フォーマットを関連づけます。

1. クラス定義の中で、Exception2MessageMapper を extend すれば、
def_e2message メソッドや def_exception メソッドが使えます。
これらで例外クラスとメッセージを関連づけることができます。

例:

  class Foo
    extend Exception2MessageMapper
    def_e2message ExistingExceptionClass, "message..."
    def_exception :NewExceptionClass, "message...", StandardError
    ...
  end

  foo = Foo.new
  foo.Fail ....

2. 何度も使いたい例外クラスは、クラスの代わりにモジュールで定義して、
それを include して使います。

例:

  module ErrorMod
    extend Exception2MessageMapper
    def_e2meggage ExistingExceptionClass, "message..."
    def_exception :NewExceptionClass, "message...", StandardError
    ...
  end
  class Foo
    include ErrorMod
    ...
  end
  
  foo = Foo.new
  foo.Fail ....

3. 例外を設定したクラスのインスタンス以外から例外を呼ぶこともできます。

例:

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



= reopen Kernel

== Private Instance Methods

--- Raise(error, *args)
--- Fail(error, *args)
#@todo

error クラスのエラーを発生させます。

error の後に続く引数 args 群は、例外クラスに関連づけられたエラー
メッセージ用フォーマットと合わせて、エラーメッセージの一部に
なります。例えば、

  class Foo
    extend Exception2MessageMapper
    def_exception :NewExceptionClass, "message...%d, %d and %d"
    
    def foo
      Raise NewExceptionClass, 1, 2, 3
    end
  end

という定義があれば、

  Foo.new().foo()

というメソッドで、

  in `Raise': message...1, 2 and 3 (Foo::NewExceptionClass)

というエラーが発生します。

また、

  Foo.Raise Foo::NewExceptionClass, 1, 3, 5

というメソッドでも、

  in `Raise': message...1, 3 and 5 (Foo::NewExceptionClass)

という例外が発生します。



= module Exception2MessageMapper

== Singleton Methods
--- def_e2message(k, c, m)
#@todo

--- def_exception(k, n, m, s = StandardError)
#@todo

--- Raise(klass = E2MM, err = nil, *rest)
--- Fail(klass = E2MM, err = nil, *rest)
#@todo

== Instance Methods

--- Raise(err = nil, *rest)
--- Fail(err  = nil, *rest)
#@todo

--- fail(err = nil, *rest)
#@todo

--- def_e2message(exception, message_form)
#@todo

すでに存在する例外クラス exception に、
エラーメッセージ用フォーマット message_form を関連づけます。
message_form の形式は sprintf() の format 文字列と同じです。

このフォーマットは Raise (またはその別名の Fail)で使われます。

--- def_exception(exception_name, message_form, superclass)
#@todo

exception_name という名前の例外クラスを作ります。
exception_name はシンボルで与えられます。

このクラスは、superclass が設定されていれば
そのクラスのサブクラスに、
設定されていない場合は StandardError のサブクラスになります。

そして、そのクラスに message_form で指定された
フォーマットを関連づけます。
これは Raise (またはその別名の Fail) で使われます。

= module Exception2MessageMapper::E2MM
Exception2MessageMapper の別名です。

= class Exception2MessageMapper::ErrNotRegisteredException < StandardError
