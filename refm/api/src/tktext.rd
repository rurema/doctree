#@if (version <= "1.8.1")

= module TkTreatTextTagFont
include TkTreatItemFont

== Constants

--- ItemCMD

#@include(tk/TkText)
#@include(tk/TkTextTag)
#@include(tk/TkTextNamedTag)
#@include(tk/TkTextTagSel)
#@include(tk/TkTextMark)
#@include(tk/TkTextNamedMark)
#@include(tk/TkTextMarkInsert)
#@include(tk/TkTextMarkCurrent)
#@include(tk/TkTextMarkAnchor)
#@include(tk/TkTextWindow)
#@#@include(tk/TkTextImage)

#@else

#@include(tk/text.rd)

#@end
