#@since 1.9.1

JSON (JavaScript Object Notation)を扱うライブラリです。

JSON の仕様は [[rfc:4627]] を参照してください。

拡張ライブラリによる実装と Ruby による実装があり、拡張ライブラリによる実装が使用できるときは
拡張ライブラリによる実装を使用します。
Ruby による実装は [[lib:iconv]] と [[lib:strscan]] に依存しています。


#@include(json/JSON)
#@include(json/JSON__Ext__Generator__GeneratorMethods)
#@include(json/JSON__Pure__Generator__GeneratorMethods)
#@include(json/JSON__Parser)
#@include(json/JSON__State)

= reopen Kernel

== Private Instance Methods

--- j(*objects) -> String
#@todo

--- jj(*objects) -> String
#@todo

--- JSON(object, options = {}) -> ojects
#@todo


= reopen Class

== Public Instance Methods

--- json_creatable? -> bool
#@todo

= reopen Array
== Public Instance Methods
--- to_json
#@todo

= reopen FalseClass
== Public Instance Methods
--- to_json
#@todo

= reopen Float
== Public Instance Methods
--- to_json
#@todo

= reopen Hash
== Public Instance Methods
--- to_json
#@todo

= reopen Integer
== Public Instance Methods
--- to_json
#@todo

= reopen NilClass
== Public Instance Methods
--- to_json
#@todo

= reopen Object
== Public Instance Methods
--- to_json
#@todo

= reopen String
== Public Instance Methods
--- to_json
#@todo

= reopen TrueClass
== Public Instance Methods
--- to_json
#@todo

#@end
