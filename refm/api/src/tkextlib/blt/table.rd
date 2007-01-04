#@since 1.8.2

require tk
require tk/itemconfig
require tkextlib/blt

= module Tk::BLT::Table

extend Tk
extend TkItemConfigMethod

include Tk

== Singleton Methods

--- add(container, *args)



--- arrange(container)



--- cget(container, option)



--- configinfo(container, *args)



--- configure(container, *args)



--- containers(arg = {})



--- containers_pattern(pat)



--- containers_slave(win)



--- create_container(container)



--- current_configinfo(container, *args)



--- delete(container, *args)



--- extents(container, item)



--- forget(*wins)



--- info(container)



--- insert(container, *args)



--- insert_after(container, *args)



--- insert_before(container, *args)



--- itemcget(container, item, option)



--- itemconfiginfo(container, *args)



--- itemconfigure(container, *args)



--- iteminfo(container, item)



--- join(container, first, last)



--- locate(container, x, y)



--- save(container)



--- search(container, keys = {})



--- split(container, *args)



--- tagid(tag)



--- tagid2obj(tagid)



#@include(Table__TableContainer)

#@end
