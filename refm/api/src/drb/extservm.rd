[[c:DRb::ExtServManager]] を定義しているライブラリ。

DRb::ExtServManager は drb で実現されたサービスブローカーです。
個々のサービスは [[lib:drb/extserv]] で定義されている
[[c:DRb::ExtServ]] を用いて実装します。
DRb::ExtServManager
はクライアントの要求に応じて個々のサービスを
サブプロセスとして起動し、各サービスを表す DRb::ExtServ オブジェクト
をリモートオブジェクトとしてクライアントに渡します。

このライブラリは簡易的なもので、あまりメンテナンスもされていないので、
本格的な用途にはこのライブラリを参考にして実装してください。


=== Example

以下の例を実行するためには、まず server.rb を起動し、その後 client.rb を
動かします。service.rb は server.rb が client.rb からサービスを要求された
時に起動されます。また、stop.rbを用いて 



server.rb: 
  require 'drb/drb'
  require 'drb/extservm'
  
  Dir.chdir(File.dirname(__FILE__))
  # サービスを起動するコマンドを指定する
  # コマンドは文字列配列、もしくは文字列で指定できる
  # サブプロセスの起動は Kernel.#spawn でなされる
  #
  # サブプロセスを起動するときは、ここに指定したパラメータに加えて
  # さらに2つのパラメータ(サーバの druby URI とサービス名)が渡されます
  DRb::ExtServManager.command["No1"] = %w(ruby service.rb service1)
  DRb::ExtServManager.command["No2"] = %w(ruby service.rb service2)
  
  # ExtServManager オブジェクトを生成して
  # drb の front object に指定する
  s = DRb::ExtServManager.new
  DRb.start_service("druby://localhost:10234", s)
  
  # drb のプロセスの終了を待つ
  DRb.thread.join

service.rb:
  require 'drb/drb'
  require 'drb/extserv'
  
  # サービスを表すクラス
  class Service
    include DRb::DRbUndumped
  
    def initialize(service_name)
      @service_name = service_name
    end
    
    def hello
      "You invoke #{@service_name}"
    end
  end
  
  puts "Start #{ARGV[0]}"
  # ARGV の最後2つを除いた部分は ExtServManager.command で
  # 指定した引数が渡される
  front = Service.new(ARGV[0])
  
  # 通信のため drb を起動する
  # ポート番号に 0 を指定すると ephemeral port から適当なポート番号が
  # 選ばれる 
  server = DRb::DRbServer.new("druby://localhost:0", front)
  
  # ARGV の最後の2つと DRbServer オブジェクトを ExtServ.new に渡す。
  # これによってブローカープロセスにサービスの
  # 窓口となる ExtServ オブジェクトを渡す
  es = DRb::ExtServ.new(ARGV[1], ARGV[2], server)
  
  # サーバスレッドの停止を待つ
  DRb.thread.join
  # サービスを DRb::ExtServ#stop_service で止めると、サーバスレッドが
  # 終了するため、以下の行が実行される
  puts "Stop #{ARGV[0]}"

client.rb:
  require 'drb/drb'
  
  DRb.start_service
  s = DRbObject.new_with_uri("druby://localhost:10234")
  
  # No1 と名付けられたサービスを呼び出す
  service1 = s.service("No1").front
  p service1.hello # => "service1"
  
  # No2 と名付けられたサービスを呼び出す
  service2 = s.service("No2").front
  p service2.hello # => "service2"

stop.rb:
  require 'drb/drb'
  
  DRb.start_service
  s = DRbObject.new_with_uri("druby://localhost:10234")
  s.service(ARGV[0]).stop_service

= class DRb::ExtServManager < Object
[[c:DRb::ExtServ]] で作られたサービスを管理するクラスです。


== Class Methods
--- command -> { String => String|[String] }

サービスを起動するためのコマンドを指定するための [[c:Hash]] を
返します。

Hash のキーがサービス名で、値がそのサービスを起動するためのコマンドです。
この Hash を変更することでサービスを定義します。
[[m:DRb::ExtServManager.command=]] で Hash 自体を
変更することでも同じことができます。

コマンドは文字列、もしくは文字列の配列で指定します。
文字列で指定した場合は [[m:Kernel.#spawn]] で
プロセスを起動する際に shell 経由で起動されます。
文字列の配列で指定すると shell を経由せずに起動されます。

--- command=(cmd)
サービスを起動するためのコマンドを指定するための [[c:Hash]] を
設定します。

@param cmd コマンドを設定した Hash
@see [[m:DRb::ExtServManager.command]]

--- new -> DRb::ExtServManager
DRb::ExtServManager オブジェクトを生成して返します。

これで生成したオブジェクトの [[m:DRb::ExtServManager#service]] を
リモートプロセスから呼び出すことでサービスの仲介を実現します。

== Instance Methods
#@# --- regist(name, ro) -> ()
#@# used internally

--- service(name) -> DRb::ExtServ
name で指定したサービスに関連付けられた [[c:DRb::ExtServ]] 
オブジェクトを返します。

サービスを提供するプロセスが起動していない場合は、[[m:DRb::ExtServManager.command]] 
で指定したプロセスを起動し、そのプロセスが [[c:DRb::ExtServ]] オブジェクトが
[[m:DRb::ExtServ.new]] によって ExtServManager に登録されるのを待ちます。
その後、登録されたオブジェクトを返します。

すでにプロセスが起動していた場合は、登録されている DRb::ExtServ オブジェクトを
返します。

[[c:DRb::ExtServ#stop_service]] でサービスを停止すると、登録されている
DRb::ExtServ は削除され、プロセスは停止します。

@param name サービス名文字列

#@# --- unregist(name) -> ()
#@# used internally

--- uri -> String|nil
サービス起動時にプロセスを spawn する時に渡す URI を返します。

デフォルトは nil で、これは [[m:DRb.#uri]] を用いることを意味します。

@see [[m:DRb::ExtServManager#uri=]]

--- uri=(uri)
サービス起動時にプロセスを spawn する時に渡す URI を設定します。

@see [[m:DRb::ExtServManager#uri]]
