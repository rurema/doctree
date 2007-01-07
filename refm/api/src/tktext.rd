#@if (version <= "1.8.1")

= module TkTreatTextTagFont
include TkTreatItemFont

== Constants

--- ItemCMD

#@include(tk/text/TkText)
#@include(tk/text/TkTextTag)
#@include(tk/text/TkTextNamedTag)
#@include(tk/text/TkTextTagSel)
#@include(tk/text/TkTextMark)
#@include(tk/text/TkTextNamedMark)
#@include(tk/text/TkTextMarkInsert)
#@include(tk/text/TkTextMarkCurrent)
#@include(tk/text/TkTextMarkAnchor)
#@include(tk/text/TkTextWindow)
#@include(tk/text/TkTextImage)

#@else

require tk/text

#@end
