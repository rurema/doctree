#@since 1.8.2

require tk
require tk/itemconfig
require tk/menuspec

= module TkMenuEntryConfig
include TkItemConfigMethod

== Instance Methods

--- entrycget(tagOrId, option)

--- entryconfigure(tagorId, slot, value = TkUtil::None)

--- entryconfiginfo(tagOrId, slot = nil)

--- current_entryconfiginfo(tagOrId, slot = nil)

= class TkMenu < TkWindow
extend TkMenuSpec
include Tk::Wm
include TkMenuEntryConfig

== Class Methods

--- new_menuspec(menu_spec, parent = nil, tearoff = false, keys = nil)

== Instance Methods

--- tagid(id)

--- activate(index)

--- add(type, keys = nil)

--- add_cascade(keys = nil)

--- add_checkbutton(keys = nil)

--- add_command(keys = nil)

--- add_radiobutton(keys = nil)

--- add_separator(keys = nil)

#@since 1.8.5
--- clone_menu(*args)
#@end

--- index(idx)

--- invoke(index)

--- insert(index, type, keys = nil)

--- delete(first, last = nil)

--- popup(x, y, index = nil)

--- post(x, y)

--- postcascade(index)

--- postcommand(cmd = Proc.new)

--- set_focus

--- tearoffcommand(cmd = Proc.new)

--- menutype(index)

--- unpost

--- yposition(index)

== Constants

--- TkCommandNames

--- WidgetClassName

= class TkMenuClone < TkMenu

== Class Methods

--- new(src_menu, *args)

== Instance Methods

#@since 1.8.5
--- source_menu
#@end

= module TkSystemMenu

== Instance Methods

--- initialize(parent, keys = nil)

= class TkSysMenu_Help < TkMenu
include TkSystemMenu

== Constants

--- SYSMENU_NAME

= class TkSysMenu_System < TkMenu
include TkSystemMenu

== Constants

--- SYSMENU_NAME

= class TkSysMenu_Apple < TkMenu
include TkSystemMenu

== Constants

--- SYSMENU_NAME

= class TkMenubutton < TkLabel

== Constants

--- TkCommandNames

--- WidgetClassName

= class TkOptionMenubutton < TkMenubutton

== Class Methods

--- new(*args)

== Instance Methods

--- value

--- value=(val)

--- activate(index)

--- add(value)

--- index(index)

--- invoke(index)

--- insert(index, value)

--- delete(index, last = TkUtil::None)

--- yposition(index)

--- menu

--- menucget(key)

--- menuconfigure(key, val = TkUtil::None)

--- menuconfiginfo(key = nil)

--- current_menuconfiginfo(key = nil)

--- entrycget(index, key)

--- entryconfigure(index, key, val = TkUtil::None)

--- entryconfiginfo(index, key = nil)

--- current_entryconfiginfo(index, key = nil)

== Constants

--- TkCommandNames

= class TkOptionMenubutton::OptionMenu < TkMenu

== Class Methods

--- new(path)

= reopen Kernel

== Constants

--- TkCloneMenu

--- TkMenuButton

--- TkOptionMenuButton

#@end
