#@since 1.8.2

require tk
require tkextlib/blt
require tkextlib/blt/component

= class Tk::BLT::Graph < TkWindow

include Tk::BLT::PlotComponent
include Tk::BLT::GraphCommand

== Instance Methods

--- extents(item)



--- inside(x, y)



--- invtransform(x, y)



--- snap(output, keys = {})



--- transform(x, y)




#@end
