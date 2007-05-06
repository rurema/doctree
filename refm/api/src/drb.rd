分散オブジェクトプログラミングのためのライブラリです。

[[unknown:執筆者募集]]

  * [[url:http://www2a.biglobe.ne.jp/~seki/ruby/druby.html]]
  * [[url:http://www.ruby-doc.org/stdlib/libdoc/drb/rdoc/index.html]]


= module DRb

== Module Functions

--- config
#@todo

Get the configuration of the current server.

If there is no current server, this returns the default configuration.
See #current_server and DRbServer::make_config.

--- current_server
#@todo

Get the 'current' server.

In the context of execution taking place within the main thread
of a dRuby server (typically, as a result of a remote call on
the server or one of its objects), the current server is that
server. Otherwise, the current server is the primary server.

If the above rule fails to find a server, a DRbServerNotFound
error is raised.

--- fetch_server(uri)
#@todo



--- front
#@todo

Get the front object of the current server.

This raises a DRbServerNotFound error if there is no current
server. See [[m:DRb.#current_server]].

--- here?(uri)
#@todo

Is uri the URI for the current local server?

--- install_acl(acl)
#@todo

Set the default acl.

See [[m:DRb::DRbServer.default_acl]].

--- install_id_conv(idconv)
#@todo

Set the default id conv object.
See [[m:DRb::DRbServer.default_id_conv]].

--- regist_server(server)
#@todo



--- remove_server(server)
#@todo



--- start_service(uri=nil, front=nil, config=nil)
#@todo

Start a dRuby server locally.

The new dRuby server will become the primary server, even if
another server is currently the primary server.

uri is the URI for the server to bind to. If nil, the server
will bind to random port on the default local host name and use
the default dRuby protocol.

front is the server's front object. This may be nil.

config is the configuration for the new server. This may be nil.

See DRbServer::new.

--- stop_service
#@todo

Stop the local dRuby server.

This operates on the primary server. If there is no primary server
currently running, it is a noop.

--- thread
#@todo

Get the thread of the primary server.

This returns nil if there is no primary server. See #primary_server.

--- to_id(obj)
#@todo

Get a reference id for an object using the current server.

This raises a DRbServerNotFound error if there is no current
server. See #current_server.

--- to_obj(ref)
#@todo

Convert a reference into an object using the current server.

This raises a DRbServerNotFound error if there is no current
server. See #current_server.

--- uri
#@todo

Get the URI defining the local dRuby space.

This is the URI of the current server. See #current_server.


= class DRb::DRbError < RuntimeError

= class DRb::DRbServerNotFound < DRb::DRbError

Error raised by the DRb module when an attempt is made to refer to the context's current
drb server but the context does not have one. See current_server.

= class DRb::DRbRemoteError < DRb::DRbError

An exception wrapping an error object


#@include(drb/DRbIdConv)
#@include(drb/DRbObject)
#@include(drb/DRbServer)
#@include(drb/DRbUnknown)
#@include(drb/DRbUndumped)
#@include(drb/DRbProtocol)
