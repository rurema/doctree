#@since 1.8.2
= class Tk::Winico < TkObject

require tk
require tkextlib/setup
require tkextlib/winico/setup

== Class Methods
--- package_version

--- id2obj(id)

--- info

--- icon_info(id)

--- new_from_file(file_name)

--- new_from_resource(resource_name, file_name = nil)

--- new(file_name, resource_name=nil, winico_id=nil)

== Instance Methods
--- id

--- set_window(win_id, *opts)

--- delete

--- info

--- add_to_taskbar(keys = {})
--- taskbar_add(keys = {})

--- modify_taskbar(keys = {})
--- taskbar_modify(keys = {})

--- delete_from_taskbar
--- taskbar_delete

#@include(Winico_callback)
#@include(Winico_callback__ValidateArgs)
#@end
