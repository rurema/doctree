#@since 1.8.2

require tk
require tkextlib/blt

= class Tk::BLT::Tree < TkObject

== Class Methods

--- destroy(*names)



--- id2obj(id)



--- names(pat = None)



--- new(name = nil)



== Instance Methods

--- __destroy_hook__



--- __keyonly_optkeys



--- ancestor(node1, node2)



--- ancestor?(node1, node2)



--- apply(node, keys = {})



--- attach(tree_obj)



--- before?(node1, node2)



--- children(node)



--- copy(src, parent, keys = {})



--- copy_to(src, dest_tree, parent, keys = {})



--- degree(node)



--- delete(*nodes)



--- depth(node)



--- destroy



--- dump(node)



--- dump_to_file(node, file)



--- exist?(node, key = None)



--- find(node, keys = {})



--- find_child(node, label)



--- first_child(node)



--- fullpath(node)



--- get(node)



--- get_value(node, key, default_val = None)



--- index(node)



--- initialzie(name = nil)



--- insert(parent, keys = {})



--- keys(node, *nodes)



--- label(node, text = nil)



--- last_child(node)



--- leaf?(node)



--- link(parent, node, keys = {})



--- link?(node)



--- move(node, dest, keys = {})



--- next(node)



--- next_sibling(node)



--- notify_create(*args, &b)



--- notify_delete(id)



--- notify_info(id)



--- notify_names



--- parent(node)



--- position(node)



--- prev_sibling(node)



--- previous(node)



--- restore(node, str, keys = {})



--- restore_from_file(node, file, keys = {})



--- restore_overwrite(node, str, keys = {})



--- restore_overwrite_from_file(node, file, keys = {})



--- root(node = None)



--- root?(node)



--- set(node, data)



--- size(node)



--- sort(node, keys = {})



--- tag_add(tag, *nodes)



--- tag_delete(tag, *nodes)



--- tag_forget(tag)



--- tag_get(node, *patterns)



--- tag_names(node = None)



--- tag_nodes(tag)



--- tag_set(node, *tags)



--- tag_unset(node, *tags)



--- tagid(tag)



--- trace_create(*args, &b)



--- trace_delete(*args)



--- trace_info(id)



--- trace_names



--- type(node, key)



--- unset(node, *keys)



--- values(node, key = None)



#@include(tree/Tree__Node)
#@include(tree/Tree__Tag)
#@include(tree/Tree__Notify)
#@include(tree/Tree__Trace)

#@end
