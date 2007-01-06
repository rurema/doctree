#@if (version <= "1.8.1")

require tk
require tkfont

= module TkTreatCItemFont
include TkTreatItemFont

== Instance Methods

#@if (version <= "1.8.0")
--- __conf_cmd(idx)

--- __item_pathname(tagOrId)
#@end

== Constants

--- ItemCMD

#@include(tk/TkCanvas)
#@include(tk/TkcTagAccess)
#@include(tk/TkcTag)
#@include(tk/TkcTagString)
#@include(tk/TkcTagAll)
#@include(tk/TkcTagCurrent)
#@include(tk/TkcGroup)
#@include(tk/TkcItem)
#@include(tk/TkcArc)
#@include(tk/TkcBitmap)
#@include(tk/TkcImage)
#@include(tk/TkcLine)
#@include(tk/TkcOval)
#@include(tk/TkcPolygon)
#@include(tk/TkcRectangle)
#@include(tk/TkcText)
#@include(tk/TkcWindow)
#@include(tk/TkImage)
#@include(tk/TkBitmapImage)
#@include(tk/TkPhotoImage)

= reopen Kernel

== Constants

--- TkcNamedTag

#@else

require tk/canvas

#@end
