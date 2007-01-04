#@since 1.8.2

require tk
require tk/itemconfig
require tkextlib/blt

= module Tk::BLT::DragDrop

extend TkCore
extend TkItemConfigMethod
extend Tk::ValidateConfigure

== Singleton Methods

--- __validation_class_list



--- active



--- current_source_configinfo(win, slot = nil)



--- drag(win, x, y)



--- drop(win, x, y)



--- errors(cmd = Proc.new)



--- handle_target(win, type, val = None)



--- init_source(win)



--- location(x = None, y = None)



--- source



--- source_configinfo(win, slot = nil)



--- source_configure(win, slot, value = None)



--- source_handler(win, datatype, cmd = Proc.new, *args)



--- source_handler_info(win, type)



--- source_handler_list(win)



--- target



--- target_handler(win, datatype, cmd = Proc.new, *args)



--- target_handler_list(win)



--- token(win)



#@include(DragDrop__Token)
#@include(DragDrop__PackageCommand)
#@include(DragDrop__PackageCommand__ValidateArgs)
#@include(DragDrop__SiteCommand)
#@include(DragDrop__SiteCommand__ValidateArgs)
#@include(DragDrop__DnD_Handle)

#@end
