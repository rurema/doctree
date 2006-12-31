#@since 1.8.0
= class YAML::DBM < DBM

== class methods
--- new(*options)

== instance methods
--- [](key)

--- []=(key, val)

--- delete(key)

--- delete_if {|key, val| ...}

--- each
--- each_pair {|key, val| ...}

--- each_values {|val| ...}

--- fetch(keystr, ifnone = nil)

--- has_value?(val)

--- shift

--- index(keystr)

--- invert

--- reject {|key, val| ...}

--- replace(hash)

--- select(*keys)

--- store(key, val)

--- update(hash)

--- to_a

--- to_hash

--- values

--- values_at(*keys)

#@end
