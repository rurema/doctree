require tk
= module TkWinfo
extend Tk
include Tk

== Constants

--- TkCommandNames

== Class Methods

--- appname(win)

--- atom(name, win = nil)

--- atomname(id, win = nil)

--- cells(win)

--- children(win)

--- classname(win)

--- colormapfull(win)

--- containing(root_x, root_y, win = nil)

--- depth(win)

--- exist?(win)

--- fpixels(win, dist)

--- geometry(win)

--- height(win)

--- id(win)

--- interps(win = nil)

--- manager(win)

--- mapped?(win)

--- parent(win)

--- pixels(win. dist)

--- pointerx(win)

--- pointerxy(win)

--- pointery(win)

--- reqheight(win)

--- reqwidth(win)

--- rgb(win. color)

--- rootx(win)

--- rooty(win)

--- screen(win)

--- screencells(win)

--- screendepth(win)

--- screenheight(win)

--- screenmmheight(win)

--- screenmmwidth(win)

--- screenvisual(win)

--- screenwidth(win)

--- server(win)

--- toplevel(win)

--- viewable(win)

--- visual(win)

--- visualid(win)

--- visualsavailable(win, includeids = false)

--- vrootheight(win)

--- vrootwidth(win)

--- vrootx(win)

--- vrooty(win)

--- widget(win)

--- width(win)

--- x(win)

--- y(win)


== Instance Methods

--- winfo_appname

--- winfo_atom(name)

--- winfo_atomname(id)

--- winfo_cells

--- winfo_children

--- winfo_class

--- winfo_classname

--- winfo_colormapfull

--- winfo_containing(x, y)

--- winfo_depth

--- winfo_exist?

--- winfo_fpixels(dist)

--- winfo_geometry

--- winfo_height

--- winfo_id

--- winfo_interps

--- winfo_manager

--- winfo_mapped?

--- winfo_parent

--- winfo_pixels(dist)

--- winfo_pointerx

--- winfo_pointerxy

--- winfo_pointery

--- winfo_reqheight

--- winfo_reqwidth

--- winfo_rgb(color)

--- winfo_rootx

--- winfo_rooty

--- winfo_screen

--- winfo_screencells

--- winfo_screendepth

--- winfo_screenheight

--- winfo_screenmmheight

--- winfo_screenmmwidth

--- winfo_screenvisual

--- winfo_screenwidth

--- winfo_server

--- winfo_toplevel

--- winfo_viewable

--- winfo_visual

--- winfo_visualid

--- winfo_visualsavailable(includeids = false)

--- winfo_vrootheight

--- winfo_vrootwidth

--- winfo_vrootx

--- winfo_vrooty

--- winfo_widget(id)

--- winfo_width

--- winfo_x

--- winfo_y


