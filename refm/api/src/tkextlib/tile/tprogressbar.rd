#@since 1.8.3

require tk
require tkextlib/tile

= class Tk::Tile::TProgressbar < TkWindow
include Tk::Tile::TileWidget

== Class Methods
--- style(*args)

== Instance Methods
#@if (version <= "1.8.3")
--- step

--- step=(amount)

#@else
--- step(amount = None)

#@end

--- start(interval = None)

#@if (version <= "1.8.3")
--- stop

#@else
--- stop(amount = None)

#@end

= class Tk::Tile::Progressbar
alias Tk::Tile::TProgressbar

#@end
