= class REXML::Light::Node

== Class Methods

--- new(node = nil)

== Instance Methods

--- size

--- each {|x| ... }

--- name

--- name=(name_str, ns = nil)

--- parent=(node)

--- local_name

--- local_name=(name_str)

--- prefix(namespace = nil)

--- namespace(prefix = prefix())

--- namespace=(namespace)

--- [](reference, ns = nil)
#@if (version <= "1.8.0")
--- _old_get(reference, ns = nil)
#@end

--- =~(path)

--- []=(reference, ns, value = nil)
#@if (version <= "1.8.0")
--- _old_put(reference, ns, value = nil)
#@end

--- <<(element)

--- node_type

--- text=(foo)

--- root

--- has_name?

--- children

--- parent

--- to_s

#@if (version <= "1.8.0")
--- el!
#@end

== Constants

--- NAMESPLIT

#@since 1.8.1
--- PARENTS
#@end
