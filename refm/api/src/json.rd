#@since 1.9.1

JSON (JavaScript Object Notation)を扱うライブラリです。

JSON の仕様は [[rfc:4627]] を参照してください。

拡張ライブラリによる実装と Ruby による実装があり、拡張ライブラリによる実装が使用できるときは
拡張ライブラリによる実装を使用します。
Ruby による実装は [[lib:iconv]] と [[lib:strscan]] に依存しています。


#@include(json/JSON)
#@include(json/JSON__Ext__Generator__GeneratorMethods)
#@until 1.9.2
#@include(json/JSON__Pure__Generator__GeneratorMethods)
#@end
#@include(json/JSON__Parser)
#@include(json/JSON__State)

= reopen Kernel

== Private Instance Methods

--- j(*objects) -> nil

与えられたオブジェクトを JSON 形式の文字列で標準出力に一行で出力します。

@param objects JSON 形式で出力したいオブジェクトを指定します。

@see [[m:Kernel.#p]]

--- jj(*objects) -> nil

与えられたオブジェクトを JSON 形式の文字列で標準出力に人間に読みやすく整形して出力します。

@param objects JSON 形式で出力したいオブジェクトを指定します。

@see [[m:Kernel.#pp]]

--- JSON(object, options = {}) -> object

第一引数に与えられたオブジェクトの種類によって Ruby のオブジェクトか JSON 形式の文字列を返します。

第一引数に文字列のようなオブジェクトを指定した場合は、それを [[m:JSON.#parse]] を用いてパースした結果を返します。
そうでないオブジェクトを指定した場合は、それを [[m:JSON.#generate]] を用いて変換した結果を返します。

@param object 任意のオブジェクトを指定します。

@param options [[m:JSON.#parse]], [[m:JSON.#generate]] に渡すオプションを指定します。

@see [[m:JSON.#parse]], [[m:JSON.#generate]]

= reopen Class

== Public Instance Methods

--- json_creatable? -> bool

シリアライズされた JSON 形式の文字列から、インスタンスを作成するのにこのクラスを使用できる場合は
真を返します。そうでない場合は、偽を返します。

このメソッドが真を返すクラスは json_create というメソッドを実装していなければなりません。
また json_create の第一引数は必要なデータを含むハッシュを期待しています。

= reopen Array
== Public Instance Methods
--- to_json(state = nil, depth = 0) -> String

自身から生成した JSON 形式の文字列を返します。

@param state 生成する JSON 形式の文字列をカスタマイズするために [[c:JSON::State]] のインスタンスを指定します。

@param depth ネストの深さを見つけるために使用されます。

= reopen FalseClass
== Public Instance Methods
--- to_json -> String

自身から生成した JSON 形式の文字列を返します。

"false" という文字列を返します。

= reopen Float
== Public Instance Methods
--- to_json -> String

自身から生成した JSON 形式の文字列を返します。

= reopen Hash
== Public Instance Methods
--- to_json(state = nil, depth = 0) -> String

自身から生成した JSON 形式の文字列を返します。

@param state 生成する JSON 形式の文字列をカスタマイズするために [[c:JSON::State]] のインスタンスを指定します。

@param depth ネストの深さを見つけるために使用されます。

= reopen Integer
== Public Instance Methods
--- to_json -> String

自身から生成した JSON 形式の文字列を返します。

= reopen NilClass
== Public Instance Methods
--- to_json -> String

自身から生成した JSON 形式の文字列を返します。

"null" という文字列を返します。

= reopen Object
== Public Instance Methods
--- to_json -> String

自身を to_s で文字列にした結果を JSON 形式の文字列に変換して返します。

このメソッドはあるオブジェクトに to_json メソッドが定義されていない場合に使用する
フォールバックのためのメソッドです。

= reopen String
== Public Instance Methods
--- to_json -> String

自身から生成した JSON 形式の文字列を返します。

自身のエンコードは UTF-8 であるべきです。
"\u????" のように UTF-16 ビッグエンディアンでエンコードされた文字列を返すことがあります。

= reopen TrueClass
== Public Instance Methods
--- to_json -> String

自身から生成した JSON 形式の文字列を返します。

"true" という文字列を返します。

#@end
