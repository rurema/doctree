= class REXML::Light::Node
#@# DOMより軽量なのを目指したと思われる、がこのクラスのオブジェクトを
#@# 出力する XML パーサが存在しないのであまり利用価値がないように思われる。

== Class Methods

--- new(node = nil)
#@todo

== Instance Methods

--- size
#@todo

--- each {|x| ... }
#@todo

--- name
#@todo

--- name=(name_str, ns = nil)
#@todo

--- parent=(node)
#@todo

--- local_name
#@todo

--- local_name=(name_str)
#@todo

--- prefix(namespace = nil)
#@todo

--- namespace(prefix = prefix())
#@todo

--- namespace=(namespace)
#@todo

--- [](reference, ns = nil)
#@todo
#@if (version <= "1.8.0")
--- _old_get(reference, ns = nil)
#@todo
#@end

--- =~(path)
#@todo

--- []=(reference, ns, value = nil)
#@todo
#@if (version <= "1.8.0")
--- _old_put(reference, ns, value = nil)
#@todo
#@end

--- <<(element)
#@todo

--- node_type
#@todo

--- text=(foo)
#@todo

--- root
#@todo

--- has_name?
#@todo

--- children
#@todo

--- parent
#@todo

--- to_s
#@todo

#@if (version <= "1.8.0")
--- el!
#@todo
#@end

== Constants

--- NAMESPLIT
#@todo

#@since 1.8.1
--- PARENTS
#@todo
#@end
