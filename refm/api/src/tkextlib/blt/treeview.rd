
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
#@todo



--- __item_validation_class_list(id)
#@todo



--- __validation_class_list
#@todo



--- _find_exec_flag_value(val)
#@todo



--- bbox(*tags)
#@todo



--- button_activate(tag)
#@todo



--- button_bind(tag, seq, *args)
#@todo



--- button_bind_append(tag, seq, *args)
#@todo



--- button_bind_remove(tag, seq)
#@todo



--- button_bindinfo(tag, seq = nil)
#@todo



--- close(*tags)
#@todo



--- close_recurse(*tags)
#@todo



--- column_activate(column = None)
#@todo



--- column_delete(*fields)
#@todo



--- column_insert(pos, field, *opts)
#@todo



--- column_invoke(field)
#@todo



--- column_move(name, dest)
#@todo



--- column_names
#@todo



--- column_nearest(x, y = None)
#@todo



--- curselection
#@todo



--- delete(*tags)
#@todo



--- entry_activate(tag)
#@todo



--- entry_before?(tag1, tag2)
#@todo



--- entry_children(tag, first = None, last = None)
#@todo



--- entry_delete(tag, first = None, last = None)
#@todo



--- entry_hidden?(tag)
#@todo



--- entry_open?(tag)
#@todo



--- entry_size(tag)
#@todo



--- entry_size_recurse(tag)
#@todo



--- find(first, last, keys = {})
#@todo



--- get(*tags)
#@todo



--- get_full(*tags)
#@todo



--- hide(*tags)
#@todo



--- index(str)
#@todo



--- index_at(tag, str)
#@todo



--- index_at_path(tag, str)
#@todo



--- insert(pos, parent = nil, keys = {})
#@todo



--- insert_at(tag, pos, parent = nil, keys = {})
#@todo



--- move_after(tag, dest)
#@todo



--- move_before(tag, dest)
#@todo



--- move_into(tag, dest)
#@todo



--- nearest(x, y, var = None)
#@todo



--- open(*tags)
#@todo



--- open_recurse(*tags)
#@todo



--- range(first, last)
#@todo



--- range_open(first, last)
#@todo



--- scan_dragto(x, y)
#@todo



--- scan_mark(x, y)
#@todo



--- screen_bbox(*tags)
#@todo



--- see(tag)
#@todo



--- see_anchor(anchor, tag)
#@todo



--- selection_anchor(tag)
#@todo



--- selection_cancel
#@todo



--- selection_clear(first, last = None)
#@todo



--- selection_clear_all
#@todo



--- selection_include?(tag)
#@todo



--- selection_mark(tag)
#@todo



--- selection_present?
#@todo



--- selection_set(first, last = None)
#@todo



--- selection_toggle(first, last = None)
#@todo



--- show(*tags)
#@todo



--- sort_auto(mode)
#@todo



--- sort_auto=(mode)
#@todo



--- sort_auto?
#@todo



--- sort_once(*tags)
#@todo



--- sort_once_recurse(*tags)
#@todo



--- tag_add(tag, *ids)
#@todo



--- tag_bind(tag, seq, *args)
#@todo



--- tag_bind_append(tag, seq, *args)
#@todo



--- tag_bind_remove(tag, seq)
#@todo



--- tag_bindinfo(tag, seq = nil)
#@todo



--- tag_delete(tag, *ids)
#@todo



--- tag_focus(tag)
#@todo



--- tag_forget(tag)
#@todo



--- tag_names(id = nil)
#@todo



--- tag_nodes(tag)
#@todo



--- tagid2obj(tagid)
#@todo



--- text_apply
#@todo



--- text_cancel
#@todo



--- text_delete(first, last)
#@todo



--- text_get(x, y)
#@todo



--- text_get_root(x, y)
#@todo



--- text_icursor(idx)
#@todo



--- text_index(idx)
#@todo



--- text_insert(idx, str)
#@todo



--- text_selection_adjust(idx)
#@todo



--- text_selection_clear
#@todo



--- text_selection_from(idx)
#@todo



--- text_selection_present
#@todo



--- text_selection_range(start, last)
#@todo



--- text_selection_to(idx)
#@todo



--- toggle(tag)
#@todo



#@include(treeview/Treeview__ConfigMethod)
#@include(treeview/Treeview__TagOrID_Methods)
#@include(treeview/Treeview__Node)
#@include(treeview/Treeview__Tag)
#@include(treeview/Hiertable)
#@include(treeview/Treeview__OpenCloseCommand)
#@include(treeview/Treeview__OpenCloseCommand__ValidateArgs)
#@include(treeview/Treeview__FindExecFlagValue)
#@include(treeview/Treeview__FindExecFlagValue__ValidateArgs)

