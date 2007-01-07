#@since 1.8.1
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

= class SOAP::RPC::SOAPlet < WEBrick::HTTPServlet::AbstractServlet

== Class Methods

--- new(router = nil)

== Instance Methods

--- options

--- app_scope_router

--- add_ervant(obj, namespace)

--- allow_content_encoding_gzip=(allow)

--- get_instance(config, *options)

--- require_path_info?

--- do_GET(req, res)

--- do_POST(req, res)

#@end
