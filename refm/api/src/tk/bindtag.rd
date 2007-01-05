#@since 1.8.2

require 'tk'

= class TkBindTag

include TkBindCore

== Class Methods

--- id2obj(id)

--- new_by_name(name, *args, &b)

--- new(*args, &b)

== Instance Methods

--- name

--- to_eval

--- inspect

== Constants

--- BTagID_TBL

--- Tk_BINDTAG_ID

--- ALL

= class TkBindTagAll < TkBindTag

== Class Methods

--- new(*args, &b)


= class TkDatabaseClass < TkBindTag

== Class Methods

--- new(name, *args, &b)


== Instance Methods

--- inspect



#@end
