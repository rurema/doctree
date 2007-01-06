#@since 1.8.2
require tk

= module TkWinDDE
extend Tk
extend TkWinDDE

== Constants

--- TkCommandNames
#@# = ['dde'.freeze].freeze

--- PACKAGE_NAME
#@# = 'dde'.freeze

== Class Methods

--- package_name

--- async_execute(service, topic, data)

--- eval(topic, cmd, *args)

--- execute(service, topic, data)

--- poke(service, topic, item, data)

--- request(service, topic, item)

--- servername(*args)

--- services(service, topic)

== Instance Methods

--- async_eval(topic, cmd, *args)

--- async_execute(service, topic, data)

--- binary_request(service, topic, item)

--- eval(topic, cmd, *args)

--- execute(service, topic, data)

--- poke(service, topic, item, data)

--- request(service, topic, item)

--- servername(*args)

--- services(service, topic)


= module TkWinRegistry
extend Tk
extend TkWinRegistry

== Constants

--- TkCommandNames
#@# = ['registry'.freeze].freeze

== Class Methods

--- delete(keynam, valnam = Tk::None)

--- get(keynam, valnam)

--- keys(keynam, pattern = nil)

--- set(keynam, valnam = Tk::None, data = Tk::None, dattype = Tk::None)

--- type(keynam, valnam)

--- values(keynam, pattern = nil)


== Instance Methods

--- broadcast(keynam, timeout = nil)

--- delete(keynam, valnam = Tk::None)

--- get(keynam, valnam)

--- keys(keynam, pattern = nil)

--- set(keynam, valnam = Tk::None, data = Tk::None, dattype = Tk::None)

--- type(keynam, valnam)

--- values(keynam, pattern = nil)

#@end
