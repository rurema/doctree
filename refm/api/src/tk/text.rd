#@since 1.8.2

require tk
require tk/itemfont
require tk/itemconfig
require tk/scrollable
require tk/txtwin_abst

= module TkTextTagConfig
include TkTreatItemFont
include TkItemConfigMethod

== Instance Methods

--- tag_cget(tagOrId, option)

--- tag_configure(tagOrId, slot, value = TkUtil::None

--- tag_configinfo(tagOrId, slot = nil)

--- current_tag_configinfo(tagOrId, slot = nil)

--- window_cget(tagOrId, option)

--- window_configure(tagOrId, slot, value = TkUtil::None)

--- window_configinfo(tagOrId, slot = nil)

--- current_window_configinfo(tagOrId, slot = nil)

= class TkText < TkTextWin
include TkTextTagConfig
include Tk::Scrollable

== Class Methods

--- new(*args) { ... }

#@since 1.8.3
--- at(x, y)
#@end

== Instance Methods

--- init_instance_variable

--- __destroy_hook__

#@since 1.8.3
--- at(x, y)
#@end

--- index(idx)

--- get_displaychars(*index)

--- value

--- value=(val)

--- clear
--- erase

--- _addcmd(cmd)

--- _addtag(name, obj)

--- tagid2obj(tagid)

--- tag_names(index = TkUtil::None)

--- mark_names

--- mark_gravity(mark, direction = nil)

--- mark_set(mark, index)
--- set_mark(mark, index)

--- mark_unset(*marks)
--- unset_mark(*marks)

--- mark_next(index)
--- next_mark(index)

--- mark_previous(index)
--- previous_mark(index)

--- image_cget(index, slot)

--- image_configure(index, slot, value = TkUtil::None)

--- image_configinfo(index, slot = nil)

--- current_image_configinfo(index, slot = nil)

--- image_names

--- set_insert(index)

--- set_current(index)

--- insert(index, chars, *tags)

--- destroy

--- backspace

--- bbox(index)

--- compare(idx1, op, idx2)

--- count(idx1, idx2, *opts)

--- count_info(idx1, idx2, update = true)

--- peer_names

--- replace(idx1, idx2, *opts)

--- debug

--- debug=(boolean)

--- dlineinfo(index)

--- modified?

--- modified(mode)

--- modified=(mode)

--- edit_redo

--- edit_reset

--- edit_separator

--- edit_undo

--- xview_pickplace(index)

--- yview_pickplace(index)

--- text_copy

--- text_cut

--- text_paste

--- tag_add(tag, index1, index2 = TkUtil::None)
--- addtag(tag, index1, index2 = TkUtil::None)
--- add_tag(tag, index1, index2 = TkUtil::None)

--- tag_delete(*tags)
--- deltag(*tags)
--- delete_tag(*tags)

--- tag_bind(tag, seq, *args)

--- tag_bind_append(tag, seq, *args)

--- tag_bind_remove(tag, seq)

--- tag_bindinfo(tag, context = nil)

--- tag_raise(tag, above = TkUtil::None)

--- tag_lower(tag, below = TkUtil::None)

--- tag_remove(tag, *indices)

--- tag_ranges(tag)

--- tag_nextrange(tag, first, last = TkUtil::None)

--- tag_prevrange(tag, first, last = TkUtil::None)

--- window_names

--- tksearch(*args)

--- tksearch_with_count(*args)

--- search_with_length(pat, start, stop = TkUtil::None)

--- search(pat, start, stop = TkUtil::None)

--- rsearch_with_length(pat, start, stop = TkUtil::None)

--- rsearch(pat, start, stop = TkUtil::None)

--- dump(type_info, *index) { ... }

--- dump_all(*index) { ... }

--- dump_mark(*index) { ... }

--- dump_tag(*index) { ... }

--- dump_text(*index) { ... }

--- dump_window(*index) { ... }

--- dump_image(*index) { ... }

== Constants

--- ItemConfCMD

--- TkCommandNames

--- WidgetClassName

= module TkText::IndexModMethods

== Instance Methods

#@since 1.8.3
--- +(mod)

--- -(mod)
#@end

--- chars(mod)
--- char(mod)

#@since 1.8.4
--- display_chars(mod)
--- display_char(mod)

--- any_chars(mod)
--- any_char(mod)
#@end

--- indices(mod)

#@since 1.8.4
--- display_indices(mod)

--- any_indices(mod)
#@end

--- lines(mod)
--- line(mod)

#@since 1.8.4
--- display_lines(mod)
--- display_line(mod)

--- any_lines(mod)
--- any_line(mod)
#@end

--- linestart

--- lineend

#@since 1.8.4
--- display_linestart

--- display_lineend
#@end

--- wordstart

--- wordend

#@since 1.8.4
--- display_wordstart

--- display_wordend
#@end

= class TkText::IndexString < String
include TkText::IndexModMethods

== Class Methods

#@since 1.8.3
--- at(x, y)
#@end

--- new(str)

== Instance Methods

--- id

= class TkText::Peer < TkText

== Class Methods

--- new(text, parent = nil, keys = {})

#@end
