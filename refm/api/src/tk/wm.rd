#@since 1.8.2
require tk

= module Tk::Wm
include TkComm

== Constants

#@since 1.8.3
--- TOPLEVEL_METHODCALL_OPTKEYS

#@end

--- TkCommandNames

== Instance Methods

--- aspect(*args)

--- attributes(slot = nil, value = Tk::None)

--- client(name = Tk::None)

--- colormapwindows(*args)

--- deiconify(ex = true)

--- focusmodel(mode = nil)

--- frame

--- geometry(geom = nil)

--- group(leader = nil)

--- iconbitmap(bmp = nil)

--- iconify(ex = true)

--- iconmaskbmp = nil)

--- iconname(name = nil)

--- iconphoto(*imgs)

--- iconphoto_default(*imgs)

--- iconposition(*args)

--- iconwindow(win = nil)

--- maxsize(*args)

--- minsize(*args)

--- overrideredirect(mode = Tk::None)

--- positionfrom(who = Tk::None)

--- protocol(name = nil, cmd = nil, &block)

#@since 1.8.3
--- protocols(kv = nil)

#@end

--- resizable(*args)

--- sizefrom(who = Tk::None)

--- stackorder

--- stackorder_isabove(win)

--- stackorder_isbelow(win)

--- state(st = nil)

--- title(str = nil)

--- transient(master = nil)

--- withdraw(ex = true)

--- wm_command(value = nil)

--- wm_grid(*args)


#@end
