= module Test::Unit::Util::Observable
This is a utility class that allows anything mixing
it in to notify a set of listeners about interesting
events.

== Instance Methods

--- add_listener(channel_name, listener_key=NOTHING, &listener)
#@todo

Adds the passed proc as a listener on the
channel indicated by channel_name. listener_key
is used to remove the listener later; if none is
specified, the proc itself is used.

Whatever is used as the listener_key is
returned, making it very easy to use the proc
itself as the listener_key:

 listener = add_listener("Channel") { ... }
 remove_listener("Channel", listener)

--- remove_listener(channel_name, listener_key)
#@todo

Removes the listener indicated by listener_key
from the channel indicated by
channel_name. Returns the registered proc, or
nil if none was found.

--- notify_listeners(channel_name, *arguments)
#@todo

Calls all the procs registered on the channel
indicated by channel_name. If value is
specified, it is passed in to the procs,
otherwise they are called with no arguments.

