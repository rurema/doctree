#@since 1.8.3

require tk
require tkextlib/tile

= class Tk::Tile::TCombobox < Tk::Tile::TEntry
include Tk::Tile::TileWidget

== Class Methods
--- style(*args)

== Instance Methods
--- current

--- current=(idx)

--- identify(x, y)

--- set(val)

= class Tk::Tile::Combobox
alias Tk::Tile::TCombobox

#@end
