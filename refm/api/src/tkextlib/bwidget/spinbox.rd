#@since 1.8.2

require tk
require tkextlib/bwidget
require tkextlib/bwidget/arrowbutton
require tkextlib/bwidget/entry

= class Tk::BWidget::SpinBox < TkEntry

include Tk::Scrollable

== Instance Methods

--- entrybind(context, *args)

def entrybind(*args)

  _bind([path, 'bind'], *args)
  self

end

--- entrybind_append(context, *args)

def entrybind_append(*args)

  _bind_append([path, 'bind'], *args)
  self

end

--- entrybind_remove(*args)



--- entrybindinfo(*args)



--- get_index_of_value
alias get_value
alias get_value_index



--- get_value

Alias for #get_index_of_value

--- get_value_index

Alias for #get_index_of_value

--- set_index_value(idx)

Alias for #set_value_by_index

--- set_value(idx)

Alias for #set_value_by_index

--- set_value_by_index(idx)
alias set_value
alias set_index_value




#@end
