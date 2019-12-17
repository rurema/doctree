
require tk
require tk/itemconfig
require tkextlib/blt

= module Tk::BLT::DragDrop

extend TkCore
extend TkItemConfigMethod
extend Tk::ValidateConfigure

== Singleton Methods

--- __validation_class_list
#@todo



--- active
#@todo



--- current_source_configinfo(win, slot = nil)
#@todo



--- drag(win, x, y)
#@todo



--- drop(win, x, y)
#@todo



--- errors(cmd = Proc.new)
#@todo



--- handle_target(win, type, val = None)
#@todo



--- init_source(win)
#@todo



--- location(x = None, y = None)
#@todo



--- source
#@todo



--- source_configinfo(win, slot = nil)
#@todo



--- source_configure(win, slot, value = None)
#@todo



--- source_handler(win, datatype, cmd = Proc.new, *args)
#@todo



--- source_handler_info(win, type)
#@todo



--- source_handler_list(win)
#@todo



--- target
#@todo



--- target_handler(win, datatype, cmd = Proc.new, *args)
#@todo



--- target_handler_list(win)
#@todo



--- token(win)
#@todo



#@include(dragdrop/DragDrop__Token)
#@include(dragdrop/DragDrop__PackageCommand)
#@include(dragdrop/DragDrop__PackageCommand__ValidateArgs)
#@include(dragdrop/DragDrop__SiteCommand)
#@include(dragdrop/DragDrop__SiteCommand__ValidateArgs)
#@include(dragdrop/DragDrop__DnD_Handle)

