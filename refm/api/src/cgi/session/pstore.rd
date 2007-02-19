require cgi/session
require pstore

= class CGI::Session::PStore < Object

== Class Methods

--- new(session, option = {})
#@todo

== Instance Methods

--- restore
#@todo

--- update
#@todo

--- close
#@todo

--- delete
#@todo

#@if (version <= "1.8.1")
--- check_id(id)
#@todo
#@end

#@if (version <= "1.8.4")
= redefine CGI::Session

== Instance Methods

--- []=(key, value)
#@todo
#@end
