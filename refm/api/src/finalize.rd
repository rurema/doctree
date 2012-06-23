category GC

オブジェクトが GC される時にメッセージを送る機能を提供します。このライブラリは obsolete です。

Finalizer とは, あるオブジェクト obj が GC される時に obj に依存しているオブジェクトに対
してメッセージを送る機能です。

このライブラリは実装が古いため動きません。
[[m:ObjectSpace.#define_finalizer]] 等を使用してください。

@see [[ruby-list:3465]]

= module Finalizer

オブジェクトが GC される時にメッセージを送る機能を提供します。
このモジュールは obsolete なので、
[[m:ObjectSpace.#define_finalizer]] 等を使用してください。

== Singleton Methods

--- add(obj, dependant, method = :finalize, *options)
--- add_dependency(obj, dependant, method = :finalize, *options)
#@#not_todo

--- delete(id, dependant, method = :finalize)
--- delete_dependency(id, dependant, method = :finalize)
#@#not_todo

--- delete_all_dependency(id, dependant)
#@#not_todo

--- delete_by_dependant(dependant, method = :finalize)
#@#not_todo

--- delete_all_by_dependant(dependant)
#@#not_todo

--- finalize_dependency(id, dependant, method = :finalize)
#@#not_todo

--- finalize_all_dependency(id, dependant)
#@#not_todo

--- finalize_by_dependant(dependant, method = :finalize)
#@#not_todo

--- finalize_all_by_dependant(dependant)
#@#not_todo

--- finalize_all
#@#not_todo

--- safe
#@#not_todo
