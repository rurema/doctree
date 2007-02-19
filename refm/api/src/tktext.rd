#@if (version <= "1.8.1")

= module TkTreatTextTagFont
include TkTreatItemFont

== Constants

--- ItemCMD
#@todo

#@include(tk/text/TkText)
#@include(tk/texttag/TkTextTag)
#@include(tk/texttag/TkTextNamedTag)
#@include(tk/texttag/TkTextTagSel)
#@include(tk/textmark/TkTextMark)
#@include(tk/textmark/TkTextNamedMark)
#@include(tk/textmark/TkTextMarkInsert)
#@include(tk/textmark/TkTextMarkCurrent)
#@include(tk/textmark/TkTextMarkAnchor)
#@include(tk/textwindow/TkTextWindow)
#@include(tk/textimage/TkTextImage)

#@else

require tk/text

#@end
