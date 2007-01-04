#@since 1.8.2

require tk
require tkextlib/blt

= module Tk::BLT::Winop

extend TkCore

== Singleton Methods

--- changes(win)



--- colormap(win)



--- convolve(src, dest, filter)



--- image_convolve(src, dest, filter)



--- image_gradient(photo, left, right, type)



--- image_read_jpeg(file, photo)



--- image_resample(src, dest, horiz_filter = None, vert_filter = None)



--- image_rotate(src, dest, angle)



--- image_snap(win, photo, width = None, height = None)



--- image_subsample(src, dest, x, y, width, height, horiz_filter = None, vert_filter = None)



--- lower(*wins)



--- map(*wins)



--- move(win, x, y)



--- quantize(src, dest, colors)



--- query



--- raise(*wins)



--- read_jpeg(file, photo)



--- resample(src, dest, horiz_filter = None, vert_filter = None)



--- snap(win, photo)



--- subsample(src, dest, x, y, width, height, horiz_filter = None, vert_filter = None)



--- unmap(*wins)



--- warpto(win = None)




#@end
