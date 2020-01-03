
require tk
require tkextlib/bwidget
require tkextlib/bwidget/arrowbutton
require tkextlib/bwidget/entry

= class Tk::BWidget::SpinBox < TkEntry

include Tk::Scrollable

== Instance Methods

--- entrybind(context, *args)
#@todo

def entrybind(*args)

  _bind([path, 'bind'], *args)
  self

end

--- entrybind_append(context, *args)
#@todo

def entrybind_append(*args)

  _bind_append([path, 'bind'], *args)
  self

end

--- entrybind_remove(*args)
#@todo



--- entrybindinfo(*args)
#@todo



--- get_index_of_value
#@todo
alias get_value
alias get_value_index



--- get_value
#@todo

Alias for #get_index_of_value

--- get_value_index
#@todo

Alias for #get_index_of_value

--- set_index_value(idx)
#@todo

Alias for #set_value_by_index

--- set_value(idx)
#@todo

Alias for #set_value_by_index

--- set_value_by_index(idx)
#@todo
alias set_value
alias set_index_value




