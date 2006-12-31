require cgi/session
require pstore

= class CGI::Session::PStore < Object

== Class Methods

--- new(session, option = {})

== Instance Methods

--- restore

--- update

--- close

--- delete

#@if (version <= "1.8.1")
--- check_id(id)
#@end

#@if (version <= "1.8.4")
= redefine CGI::Session

== Instance Methods

--- []=(key, value)
#@end
