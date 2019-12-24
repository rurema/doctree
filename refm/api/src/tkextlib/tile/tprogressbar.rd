
require tk
require tkextlib/tile

= class Tk::Tile::TProgressbar < TkWindow
include Tk::Tile::TileWidget

== Class Methods
--- style(*args)
#@todo

== Instance Methods
#@if (version <= "1.8.3")
--- step
#@todo

--- step=(amount)
#@todo

#@else
--- step(amount = None)
#@todo

#@end

--- start(interval = None)
#@todo

#@if (version <= "1.8.3")
--- stop
#@todo

#@else
--- stop(amount = None)
#@todo

#@end

= class Tk::Tile::Progressbar
alias Tk::Tile::TProgressbar

