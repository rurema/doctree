#@since 1.8.2

require tk
require tk/text
require tkextlib/tcllib

= class Tk::Tcllib::CText < TkText

== Class Methods
#@since 1.8.3
--- package_name

#@end
--- package_version

== Instance Methods
--- append(*args)

--- copy

--- cut

--- fast_delete(*args)

--- fast_insert(*args)

--- highlight(*args)

--- paste

--- edit(*args)

--- add_highlight_class(klass, col, *keywords)

--- add_highlight_class_for_special_chars(klass, col, *chrs)

--- add_highlight_class_for_regexp(klass, col, tcl_regexp)

--- add_highlight_class_with_only_char_start(klass, col, chr)

--- clear_highlight_classes

--- get_highlight_classes

--- delete_highlight_class(klass)

--- enable_C_comments

--- disable_C_comments

--- find_next_char(idx, chr)

--- find_next_space(idx)

--- find_previous_space(idx)

--- set_update_proc(cmd = Proc.new)

--- modified?(mode)

#@end
