#@since 1.8.2

require tk
require tkextlib/blt
require tk/validation

= class Tk::BLT::Treeview < TkWindow

include Tk::Scrollable
include Tk::ValidateConfigure
include Tk::ItemValidateConfigure
include Tk::BLT::Treeview::ConfigMethod

== Instance Methods

--- __destroy_hook__



--- __item_validation_class_list(id)



--- __validation_class_list



--- _find_exec_flag_value(val)



--- bbox(*tags)



--- button_activate(tag)



--- button_bind(tag, seq, *args)



--- button_bind_append(tag, seq, *args)



--- button_bind_remove(tag, seq)



--- button_bindinfo(tag, seq = nil)



--- close(*tags)



--- close_recurse(*tags)



--- column_activate(column = None)



--- column_delete(*fields)



--- column_insert(pos, field, *opts)



--- column_invoke(field)



--- column_move(name, dest)



--- column_names



--- column_nearest(x, y = None)



--- curselection



--- delete(*tags)



--- entry_activate(tag)



--- entry_before?(tag1, tag2)



--- entry_children(tag, first = None, last = None)



--- entry_delete(tag, first = None, last = None)



--- entry_hidden?(tag)



--- entry_open?(tag)



--- entry_size(tag)



--- entry_size_recurse(tag)



--- find(first, last, keys = {})



--- get(*tags)



--- get_full(*tags)



--- hide(*tags)



--- index(str)



--- index_at(tag, str)



--- index_at_path(tag, str)



--- insert(pos, parent = nil, keys = {})



--- insert_at(tag, pos, parent = nil, keys = {})



--- move_after(tag, dest)



--- move_before(tag, dest)



--- move_into(tag, dest)



--- nearest(x, y, var = None)



--- open(*tags)



--- open_recurse(*tags)



--- range(first, last)



--- range_open(first, last)



--- scan_dragto(x, y)



--- scan_mark(x, y)



--- screen_bbox(*tags)



--- see(tag)



--- see_anchor(anchor, tag)



--- selection_anchor(tag)



--- selection_cancel



--- selection_clear(first, last = None)



--- selection_clear_all



--- selection_include?(tag)



--- selection_mark(tag)



--- selection_present?



--- selection_set(first, last = None)



--- selection_toggle(first, last = None)



--- show(*tags)



--- sort_auto(mode)



--- sort_auto=(mode)



--- sort_auto?



--- sort_once(*tags)



--- sort_once_recurse(*tags)



--- tag_add(tag, *ids)



--- tag_bind(tag, seq, *args)



--- tag_bind_append(tag, seq, *args)



--- tag_bind_remove(tag, seq)



--- tag_bindinfo(tag, seq = nil)



--- tag_delete(tag, *ids)



--- tag_focus(tag)



--- tag_forget(tag)



--- tag_names(id = nil)



--- tag_nodes(tag)



--- tagid2obj(tagid)



--- text_apply



--- text_cancel



--- text_delete(first, last)



--- text_get(x, y)



--- text_get_root(x, y)



--- text_icursor(idx)



--- text_index(idx)



--- text_insert(idx, str)



--- text_selection_adjust(idx)



--- text_selection_clear



--- text_selection_from(idx)



--- text_selection_present



--- text_selection_range(start, last)



--- text_selection_to(idx)



--- toggle(tag)



#@include(Treeview__ConfigMethod)
#@include(Treeview__TagOrID_Methods)
#@include(Treeview__Node)
#@include(Treeview__Tag)
#@include(Hiertable)
#@include(Treeview__OpenCloseCommand)
#@include(Treeview__OpenCloseCommand__ValidateArgs)
#@include(Treeview__FindExecFlagValue)
#@include(Treeview__FindExecFlagValue__ValidateArgs)

#@end
