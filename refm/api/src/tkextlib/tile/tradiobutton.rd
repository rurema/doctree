#@since 1.8.2

require tk
require tkextlib/tile

= class Tk::Tile::TRadioButton < TkRadioButton
include Tk::Tile::TileWidget

= class Tk::Tile::TRadiobutton
alias Tk::Tile::TkRadioButton

#@end
