#@since 1.8.2

require tk
require tk/entry
require tkextlib/bwidget
require tkextlib/bwidget/labelframe
require tkextlib/bwidget/entry

= class Tk::BWidget::LabelEntry < TkEntry

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




#@end
