require xmlrpc/datetime

XML-RPC サーバのためのライブラリです。

==== CGI-based Server

There are also two ways to define handler, the first is
like C/PHP, the second like Java, of course both ways
can be mixed:

===== C/PHP-like (handler functions)

  require "xmlrpc/server"

  s = XMLRPC::CGIServer.new

  s.add_handler("sample.sumAndDifference") do |a,b|
    { "sum" => a + b, "difference" => a - b }
  end
    
  s.serve

===== Java-like (handler classes)

  require "xmlrpc/server"

  s = XMLRPC::CGIServer.new

  class MyHandler
    def sumAndDifference(a, b)
      { "sum" => a + b, "difference" => a - b }
    end
  end
    
  # NOTE: Security Hole (read below)!!! 
  s.add_handler("sample", MyHandler.new)
  s.serve


To return a fault-structure you have to raise an FaultException e.g.:

  require "xmlrpc/server"

  raise XMLRPC::FaultException.new(3, "division by Zero")

====== Security Note

From Brian Candler:

  Above code sample has an extremely nasty security hole, in that you can now call
  any method of 'MyHandler' remotely, including methods inherited from Object
  and Kernel! For example, in the client code, you can use

    puts server.call("sample.send","`","ls")

  (backtick being the method name for running system processes). Needless to
  say, 'ls' can be replaced with something else.

  The version which binds proc objects (or the version presented below in the next section) 
  doesn't have this problem, but people may be tempted to use the second version because it's 
  so nice and 'Rubyesque'. I think it needs a big red disclaimer.


From Michael:

A solution is to undef insecure methods or to use XMLRPC::iPIMethods as shown below:

  require "xmlrpc/server"

  class MyHandler
    def sumAndDifference(a, b)
      { "sum" => a + b, "difference" => a - b }
    end
  end

  # ... server initialization ...

  s.add_handler(XMLRPC::iPIMethods("sample"), MyHandler.new)

  # ...

This adds only public instance methods explicitly declared in class MyHandler 
(and not those inherited from any other class).

===== With interface declarations

Code sample from the book Ruby Developer's Guide:

  require "xmlrpc/server"

  class Num
    INTERFACE = XMLRPC::interface("num") {
      meth 'int add(int, int)', 'Add two numbers', 'add'
      meth 'int div(int, int)', 'Divide two numbers'
    }

    def add(a, b) a + b end
    def div(a, b) a / b end
  end


  s = XMLRPC::CGIServer.new
  s.add_handler(Num::INTERFACE, Num.new)
  s.serve

==== Standalone server

Same as CGI-based server, only that the line

  require "xmlrpc/server"

  server = XMLRPC::CGIServer.new

must be changed to

  require "xmlrpc/server"

  server = XMLRPC::Server.new(8080)

if you want a server listening on port 8080.
The rest is the same.

#@include(BasicServer)
#@include(CGIServer)
#@include(ModRubyServer)
#@include(Server)
#@include(WEBrickServlet)
