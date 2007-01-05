#@since 1.8.2

require tk
require tkextlib/iwidgets

= class Tk::Iwidgets::Calendar < Tk::Itk::Widget

include Tk::ValidateConfigure

== Instance Methods

--- __validation_class_list



--- get

Alias for #get_string

--- get_clicks



--- get_string
alias get



--- select(date)



--- show(date)



--- show_now




#@end
