#@if (version <= "1.8.1")

require tk
require tkfont

= module TkTreatCItemFont
include TkTreatItemFont

== Instance Methods

#@if (version <= "1.8.0")
--- __conf_cmd(idx)
#@todo

--- __item_pathname(tagOrId)
#@todo
#@end

== Constants

--- ItemCMD
#@todo

#@include(tk/canvas/TkCanvas)
#@include(tk/canvastag/TkcTagAccess)
#@include(tk/canvastag/TkcTag)
#@include(tk/canvastag/TkcTagString)
#@include(tk/canvastag/TkcTagAll)
#@include(tk/canvastag/TkcTagCurrent)
#@include(tk/canvastag/TkcGroup)
#@include(tk/canvas/TkcItem)
#@include(tk/canvas/TkcArc)
#@include(tk/canvas/TkcBitmap)
#@include(tk/canvas/TkcImage)
#@include(tk/canvas/TkcLine)
#@include(tk/canvas/TkcOval)
#@include(tk/canvas/TkcPolygon)
#@include(tk/canvas/TkcRectangle)
#@include(tk/canvas/TkcText)
#@include(tk/canvas/TkcWindow)
#@include(tk/image/TkImage)
#@include(tk/image/TkBitmapImage)
#@include(tk/image/TkPhotoImage)

#@else

require tk/canvas

#@end
