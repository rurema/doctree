#@since 1.8.2
require tk

= class Tk::OptionObj < Hash
include TkUtil

== Class Methods

--- new(hash = nil)

== Instance Methods

--- +(hash)

--- [](key)
--- cget(key)

--- []=(key, value)


--- assign(*wins)


--- configure(key, value = nil)

--- notify(target = nil)
--- apply(target = nil)


--- observ_info

--- observs

--- replace(hash)

--- store(key, value)

--- unassign(*wins)

--- update(hash)

--- update_without_notify(hash)

[[m:Hash#update]] と同じ。

#@end
