Finalizer とは, あるオブジェクト obj が GC される時に obj に依存しているオブジェクトに対
してメッセージを送る機能です。

[[unknown:ruby-list:3465]]

= module Finalizer
== Singleton Methods

--- add(obj, dependant, method = :finalize, *opt)
--- add_dependency(obj, dependant, method = :finalize, *opt)

--- delete(id, dependant, method = :finalize)
--- delete_dependency(id, dependant, method = :finalize)

--- delete_all_dependency(id, dependant)

--- delete_by_dependant(dependant, method = :finalize)

--- delete_all_by_dependant(dependant)

--- finalize_dependency(id, dependant, method = :finalize)

--- finalize_all_dependency(id, dependant)

--- finalize_by_dependant(dependant, method = :finalize)

--- finalize_all_by_dependant(dependant)

--- finalize_all

--- safe
