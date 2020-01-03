
require tk
require tkextlib/tile

= class Tk::Tile::TPaned < TkWindow
include Tk::Tile::TileWidget

== Class Methods
--- style(*args)
#@todo

== Instance Methods
--- add(win, keys)
#@todo

--- forget(pane)
#@todo

--- insert(pos, win, keys)
#@todo

--- panecget(pane, slot)
#@todo

--- paneconfigure(pane, key, value = nil)
#@todo

--- paneconfiginfo(win)
#@todo

--- current_paneconfiginfo(win, key = nil)
#@todo

--- identify(x, y)
#@todo

--- sashpos(idx, newpos = None)
#@todo

= class Tk::Tile::Paned
alias Tk::Tile::TPaned

