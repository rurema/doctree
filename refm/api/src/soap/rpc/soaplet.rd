#@#require webrick/httpservlet/abstract
#@#require webrick/httpstatus
require soap/rpc/router
require soap/streamHandler
#@#require stringio
#@#require zlib
#@#require webrick/log

= redefine WEBrick::Log

== Instance Methods

--- debug(msg = nil)
--- debug(msg = nil) {|msg| ... }
#@todo

= class SOAP::RPC::SOAPlet < WEBrick::HTTPServlet::AbstractServlet

== Class Methods

--- new(router = nil)
#@todo

== Instance Methods

--- options
#@todo

--- app_scope_router
#@todo

--- add_ervant(obj, namespace)
#@todo

--- allow_content_encoding_gzip=(allow)
#@todo

--- get_instance(config, *options)
#@todo

--- require_path_info?
#@todo

--- do_GET(req, res)
#@todo

--- do_POST(req, res)
#@todo

