#@since 1.8.2

require tk
require tkextlib/bwidget

= module Tk::BWidget::Widget

extend Tk

include Tk

== Singleton Methods

--- __cget_cmd



--- __config_cmd



--- __pathname



--- add_map(klass, subclass, subpath, opts)



--- bwinclude(klass, subclass, subpath, *args)



--- cget(slot)



--- create(klass, path, rename = None, &b)



--- declare(klass, optlist)



--- define(klass, filename, *args)



--- destroy(win)



--- focus_next(win)



--- focus_ok(win)



--- focus_prev(win)



--- generate_doc(dir, widgetlist)



--- generate_widget_doc(klass, iscmd, file)



--- get_option(win, option)



--- get_variable(win, varname, my_varname = None)



--- has_changed(win, option, pvalue)



--- init(klass, win, options)



--- set_option(win, option, value)



--- sub_cget(win, subwidget)



--- sync_options(klass, subclass, subpath, options)



--- tkinclude(klass, tkwidget, subpath, *args)




#@end
