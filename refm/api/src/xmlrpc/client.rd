require xmlrpc/datetime

XML-RPC クライアントのためのライブラリです。

  require "xmlrpc/client"
  
  # Make an object to represent the XML-RPC server.
  server = XMLRPC::Client.new( "xmlrpc-c.sourceforge.net", "/api/sample.php")

  # Call the remote server and get our result
  result = server.call("sample.sumAndDifference", 5, 3)

  sum = result["sum"]
  difference = result["difference"]

  puts "Sum: #{sum}, Difference: #{difference}"

=== Client with XML-RPC fault-structure handling

There are two possible ways, of handling a fault-structure:

==== by catching a XMLRPC::FaultException exception

  require "xmlrpc/client"

  # Make an object to represent the XML-RPC server.
  server = XMLRPC::Client.new( "xmlrpc-c.sourceforge.net", "/api/sample.php")

  begin
    # Call the remote server and get our result
    result = server.call("sample.sumAndDifference", 5, 3)

    sum = result["sum"]
    difference = result["difference"]

    puts "Sum: #{sum}, Difference: #{difference}"

  rescue XMLRPC::FaultException => e
    puts "Error: "
    puts e.faultCode
    puts e.faultString
  end
   
==== by calling "call2" which returns a boolean

  require "xmlrpc/client"

  # Make an object to represent the XML-RPC server.
  server = XMLRPC::Client.new( "xmlrpc-c.sourceforge.net", "/api/sample.php")

  # Call the remote server and get our result
  ok, result = server.call2("sample.sumAndDifference", 5, 3)

  if ok
    sum = result["sum"]
    difference = result["difference"]

    puts "Sum: #{sum}, Difference: #{difference}"
  else
    puts "Error: "
    puts result.faultCode
    puts result.faultString
  end
   
=== Client using Proxy

You can create a +Proxy+ object onto which you can call methods. This way it
looks nicer. Both forms, _call_ and _call2_ are supported through _proxy_ and
<i>proxy2</i>.  You can additionally give arguments to the Proxy, which will be
given to each XML-RPC call using that Proxy.

  require "xmlrpc/client"
  
  # Make an object to represent the XML-RPC server.
  server = XMLRPC::Client.new( "xmlrpc-c.sourceforge.net", "/api/sample.php")

  # Create a Proxy object
  sample = server.proxy("sample")

  # Call the remote server and get our result
  result = sample.sumAndDifference(5,3)

  sum = result["sum"]
  difference = result["difference"]

  puts "Sum: #{sum}, Difference: #{difference}"

#@include(Client)
#@include(Client__Proxy)
