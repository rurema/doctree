#@since 1.8.2

require tk
require tkextlib/iwidgets

= class Tk::Iwidgets::Menubar < Tk::Itk::Widget

include TkItemConfigMethod

== Instance Methods

--- __methodcall_optkeys



--- _parse_menu_spec(menu_spec)



--- add(type, tag = nil, keys = {})



--- delete(path1, path2 = nil)



--- index(idx)



--- insert(idx, type, tag = nil, keys = {})



--- invoke(idx)



--- menubuttons(val = nil)



--- menupath(pat)



--- menupath_glob(pat)



--- menupath_tclregexp(pat)



--- tagid(tagOrId)



--- type(path)



--- yposition(path)




#@end
