
require tk
require tkextlib/blt

= class Tk::BLT::Tree < TkObject

== Class Methods

--- destroy(*names)
#@todo



--- id2obj(id)
#@todo



--- names(pat = None)
#@todo



--- new(name = nil)
#@todo



== Instance Methods

--- __destroy_hook__
#@todo



--- __keyonly_optkeys
#@todo



--- ancestor(node1, node2)
#@todo



--- ancestor?(node1, node2)
#@todo



--- apply(node, keys = {})
#@todo



--- attach(tree_obj)
#@todo



--- before?(node1, node2)
#@todo



--- children(node)
#@todo



--- copy(src, parent, keys = {})
#@todo



--- copy_to(src, dest_tree, parent, keys = {})
#@todo



--- degree(node)
#@todo



--- delete(*nodes)
#@todo



--- depth(node)
#@todo



--- destroy
#@todo



--- dump(node)
#@todo



--- dump_to_file(node, file)
#@todo



--- exist?(node, key = None)
#@todo



--- find(node, keys = {})
#@todo



--- find_child(node, label)
#@todo



--- first_child(node)
#@todo



--- fullpath(node)
#@todo



--- get(node)
#@todo



--- get_value(node, key, default_val = None)
#@todo



--- index(node)
#@todo



--- initialize(name = nil)
#@todo



--- insert(parent, keys = {})
#@todo



--- keys(node, *nodes)
#@todo



--- label(node, text = nil)
#@todo



--- last_child(node)
#@todo



--- leaf?(node)
#@todo



--- link(parent, node, keys = {})
#@todo



--- link?(node)
#@todo



--- move(node, dest, keys = {})
#@todo



--- next(node)
#@todo



--- next_sibling(node)
#@todo



--- notify_create(*args, &b)
#@todo



--- notify_delete(id)
#@todo



--- notify_info(id)
#@todo



--- notify_names
#@todo



--- parent(node)
#@todo



--- position(node)
#@todo



--- prev_sibling(node)
#@todo



--- previous(node)
#@todo



--- restore(node, str, keys = {})
#@todo



--- restore_from_file(node, file, keys = {})
#@todo



--- restore_overwrite(node, str, keys = {})
#@todo



--- restore_overwrite_from_file(node, file, keys = {})
#@todo



--- root(node = None)
#@todo



--- root?(node)
#@todo



--- set(node, data)
#@todo



--- size(node)
#@todo



--- sort(node, keys = {})
#@todo



--- tag_add(tag, *nodes)
#@todo



--- tag_delete(tag, *nodes)
#@todo



--- tag_forget(tag)
#@todo



--- tag_get(node, *patterns)
#@todo



--- tag_names(node = None)
#@todo



--- tag_nodes(tag)
#@todo



--- tag_set(node, *tags)
#@todo



--- tag_unset(node, *tags)
#@todo



--- tagid(tag)
#@todo



--- trace_create(*args, &b)
#@todo



--- trace_delete(*args)
#@todo



--- trace_info(id)
#@todo



--- trace_names
#@todo



--- type(node, key)
#@todo



--- unset(node, *keys)
#@todo



--- values(node, key = None)
#@todo



#@include(tree/Tree__Node)
#@include(tree/Tree__Tag)
#@include(tree/Tree__Notify)
#@include(tree/Tree__Trace)

