#@since 1.8.2
require tk

= class TkVirtualEvent < TkObject
extend Tk

== Constants

--- TkCommandNames

--- TkVirtualEventID

--- TkVirtualEventTBL


== Class Methods

--- getobj(event)

--- info

--- new(*sequences)

== Instance Methods

--- add(*sequences)

--- delete(*sequences)

--- info


= class TkVirtualEvent::PreDefVirtEvent < TkVirtualEvent

== Class Methods

--- new(event, *sequences)

= class TkNamedVirtualEvent
alias TkVirtualEvent::PreDefVirtEvent

#@end
