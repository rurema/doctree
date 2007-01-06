#@since 1.8.2

require tk
require tkextlib/iwidgets

= class Tk::Iwidgets::Spinner < Tk::Iwidgets::Labeledwidget

include Tk::ValidateConfigure

== Instance Methods

--- __validation_class_list



--- clear



--- cursor=(index)
alias icursor



--- delete(first, last = None)



--- down



--- dragto(pos)



--- get

Alias for #value

--- icursor(index)

Alias for #cursor=

--- index(idx)



--- insert(pos, text)



--- mark(pos)



--- selection_adjust(index)



--- selection_clear



--- selection_from(index)



--- selection_present



--- selection_range(s, e)



--- selection_to(index)



--- set(val)

Alias for #value=

--- up



--- value
alias get



--- value=(val)
alias set



--- xview(*index)

based on tk/scrollable.rb

--- xview_moveto(*index)



--- xview_scroll(*index)



#@include(spinner/Spinner__EntryfieldValidate)
#@include(spinner/Spinner__EntryfieldValidate__ValidateArgs)

#@end
