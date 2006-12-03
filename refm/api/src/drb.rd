dRuby -- 分散オブジェクトプログラミングのためのライブラリ

[[unknown:執筆者募集]]

  * [[url:http://www2a.biglobe.ne.jp/~seki/ruby/druby.html]]
  * [[url:http://www.ruby-doc.org/stdlib/libdoc/drb/rdoc/index.html]]

//emlist{
ACL
    ACL::ACLEntry
    ACL::ACLList
DRb
    DRb::DRbIdConv
    DRb::DRbObject
    DRb::DRbObservable
    DRb::DRbProtocol
    DRb::DRbSSLSocket
    DRb::DRbServer
    DRb::DRbUndumped
    DRb::DRbUnknown
    DRb::ExtServ
    DRb::ExtServManager
    DRb::GW
    DRb::GWIdConv
    DRb::TimerIdConv
//}

= module DRb

== Module Functions

#@# bc-rdoc: detected missing name: config
--- config

Get the configuration of the current server.

If there is no current server, this returns the default configuration.
See #current_server and DRbServer::make_config.

#@# bc-rdoc: detected missing name: current_server
--- current_server

Get the 'current' server.

In the context of execution taking place within the main thread
of a dRuby server (typically, as a result of a remote call on
the server or one of its objects), the current server is that
server. Otherwise, the current server is the primary server.

If the above rule fails to find a server, a DRbServerNotFound
error is raised.

#@# bc-rdoc: detected missing name: fetch_server
--- fetch_server(uri)



#@# bc-rdoc: detected missing name: front
--- front

Get the front object of the current server.

This raises a DRbServerNotFound error if there is no current
server. See #current_server.

#@# bc-rdoc: detected missing name: here?
--- here?(uri)

Is uri the URI for the current local server?

#@# bc-rdoc: detected missing name: install_acl
--- install_acl(acl)

Set the default acl.

See DRb::DRbServer.default_acl.

#@# bc-rdoc: detected missing name: install_id_conv
--- install_id_conv(idconv)

Set the default id conv object.
See [[m:DRbServer#default_id_conv]].

#@# bc-rdoc: detected missing name: regist_server
--- regist_server(server)



#@# bc-rdoc: detected missing name: remove_server
--- remove_server(server)



#@# bc-rdoc: detected missing name: start_service
--- start_service(uri=nil, front=nil, config=nil)

Start a dRuby server locally.

The new dRuby server will become the primary server, even if
another server is currently the primary server.

uri is the URI for the server to bind to. If nil, the server
will bind to random port on the default local host name and use
the default dRuby protocol.

front is the server's front object. This may be nil.

config is the configuration for the new server. This may be nil.

See DRbServer::new.

#@# bc-rdoc: detected missing name: stop_service
--- stop_service

Stop the local dRuby server.

This operates on the primary server. If there is no primary server
currently running, it is a noop.

#@# bc-rdoc: detected missing name: thread
--- thread

Get the thread of the primary server.

This returns nil if there is no primary server. See #primary_server.

#@# bc-rdoc: detected missing name: to_id
--- to_id(obj)

Get a reference id for an object using the current server.

This raises a DRbServerNotFound error if there is no current
server. See #current_server.

#@# bc-rdoc: detected missing name: to_obj
--- to_obj(ref)

Convert a reference into an object using the current server.

This raises a DRbServerNotFound error if there is no current
server. See #current_server.

#@# bc-rdoc: detected missing name: uri
--- uri

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

