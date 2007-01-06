#@since 1.8.3

require tk
require tkextlib/tile

= class Tk::Tile::TPaned < TkWindow
include Tk::Tile::TileWidget

== Class Methods
--- style(*args)

== Instance Methods
--- add(win, keys)

--- forget(pane)

--- insert(pos, win, keys)

--- panecget(pane, slot)

--- paneconfigure(pane, key, value = nil)

--- paneconfiginfo(win)

--- current_paneconfiginfo(win, key = nil)

--- identify(x, y)

--- sashpos(idx, newpos = None)

= class Tk::Tile::Paned
alias Tk::Tile::TPaned

#@end
