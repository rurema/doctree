例外クラスに特定のエラーメッセージ用フォーマットを関連づけるためのライブラリです。

=== 使い方

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

= module Exception2MessageMapper
alias Exception2MessageMapper::E2MM

例外クラスに特定のエラーメッセージ用フォーマットを関連づけるためのモジュールです。

== Singleton Methods
--- def_e2message(klass, exception_class, message_format) -> Class
すでに存在する例外クラス exception_class に、
エラーメッセージ用フォーマット message_format を関連づけます。

@param klass 一階層上となるクラス名を指定します。

@param exception_class メッセージを登録する例外クラスを指定します。

@param message_format メッセージのフォーマットを指定します。
                    [[m:Kernel.#sprintf]] のフォーマット文字列と同じ形式を使用できます。

@return exception_class を返します。

--- def_exception(klass, exception_name, message_format, superklass = StandardError) -> Class

exception_name という名前の例外クラスを定義します。

@param klass 一階層上となるクラス名を指定します。

@param exception_name 例外クラスの名前をシンボルで指定します。

@param message_format メッセージのフォーマットを指定します。
                    [[m:Kernel.#sprintf]] のフォーマット文字列と同じ形式を使用できます。

@param superklass 定義する例外クラスのスーパークラスを指定します。
                  省略すると [[c:StandardError]] を使用します。

@return 定義した例外クラスを返します。

--- e2mm_message(klass, exp) -> String | nil
--- message(klass, exp) -> String | nil
#@todo

@param klass

@param exp

--- extend_object(cl) -> ()
#@todo

@param cl

--- Raise(klass = E2MM, exception_class = nil, *rest) -> ()
--- Fail(klass = E2MM, exception_class = nil, *rest)  -> ()

登録されている情報を使用して、例外を発生させます。

@param klass 一階層上となるクラス名を指定します。

@param exception_class 例外クラス。

@param rest メッセージに埋め込む値。

@raise Exception2MessageMapper::ErrNotRegisteredException 指定された例外クラスに対応するメッセージが存在しない場合に発生します。

#@until 1.9.1
--- fail(exception_class = nil, *rest) -> ()

このメソッドは後方互換性のために用意されています。

登録されている情報を使用して、例外を発生させます。

@param exception_class 例外クラス。

@param rest メッセージに埋め込む値。

@raise Exception2MessageMapper::ErrNotRegisteredException 指定された例外クラスに対応するメッセージが存在しない場合に発生します。

--- extend_to(b) -> Class

このメソッドは後方互換性のために用意されています。

@param b [[c:Binding]] オブジェクト。

#@end

== Instance Methods

--- bind(cl) -> ()
#@todo

@param cl xxx

--- Raise(exception_class = nil, *rest) -> ()
--- Fail(exception_class = nil, *rest)  -> ()
登録されている情報を使用して、例外を発生させます。

@param exception_class 例外クラス。

@param rest メッセージに埋め込む値。

@raise Exception2MessageMapper::ErrNotRegisteredException 指定された例外クラスに対応するメッセージが存在しない場合に発生します。

例:

  class Foo
    extend Exception2MessageMapper
    p def_exception :NewExceptionClass, "message...%d, %d and %d" # =>
    
    def foo
      Raise NewExceptionClass, 1, 2, 3
    end
  end
  
  Foo.new().foo() #=> in `Raise': message...1, 2 and 3 (Foo::NewExceptionClass)
                  #   という例外が発生します。
  
  Foo.Raise Foo::NewExceptionClass, 1, 3, 5  #=> in `Raise': message...1, 3 and 5 (Foo::NewExceptionClass)
                                             #   という例外が発生します。

--- fail(exception_class = nil, *rest) -> ()
登録されている情報を使用して、例外を発生させます。

@param exception_class 例外クラス。

@param rest メッセージに埋め込む値。

@raise Exception2MessageMapper::ErrNotRegisteredException 指定された例外クラスに対応するメッセージが存在しない場合に発生します。

--- def_e2message(exception_class, message_format) -> Class

すでに存在する例外クラス exception_class に、
エラーメッセージ用フォーマット message_format を関連づけます。

このフォーマットは [[m:Exception2MessageMapper#Raise]],
[[m:Exception2MessageMapper#Fail]] で使用します。

@param exception_class メッセージを登録する例外クラスを指定します。

@param message_format メッセージのフォーマットを指定します。
                    [[m:Kernel.#sprintf]] のフォーマット文字列と同じ形式を使用できます。

@return exception_class を返します。


--- def_exception(exception_name, message_format, superclass = StandardError) -> Class

exception_name という名前の例外クラスを定義します。

@param exception_name 定義する例外クラスの名前をシンボルで指定します。

@param message_format メッセージのフォーマット。

@param superclass 定義する例外のスーパークラスを指定します。
                  省略すると [[c:StandardError]] を使用します。


= class Exception2MessageMapper::ErrNotRegisteredException < StandardError

登録されていない例外が [[m:Exception2MessageMapper#Raise]] で使用された場合に発生します。
