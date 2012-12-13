
drb 通信を中継するゲートウェイ([[c:DRb::GW]])と、
中継に必要なオブジェクト識別子変換クラス([[c:DRb::GWIdConv]])、
および [[c:DRb::DRbObject]] への拡張が含まれています。

このライブラリを利用することで直接通信することが不可能であるような
2つのプロセスが中継プロセスを経て drb によりやりとりできるようになります。

drb による通信とは、オブジェクトをプロセス間でやりとりすること、
およびそのメソッドを呼び出すことです。
中継プロセスが保持している DRb::GW オブジェクトに
それ以外のプロセスがオブジェクトを登録したり、登録済みの
オブジェクトを取り出すことでオブジェクトをやりとりします。
そしてそのオブジェクトのメソッドを呼び出すことで
中継プロセスを経由した通信ができます。


以下の URL も参照してください。
 * [[url:http://www2a.biglobe.ne.jp/~seki/ruby/drbssh.html]]

=== Example
この例は drb/gw.rb に含まれているものです。

foo.rb
  require 'drb/drb'
  
  class Foo
    include DRbUndumped
    def initialize(name, peer=nil)
      @name = name
      @peer = peer
    end
  
    def ping(obj)
      puts "#{@name}: ping: #{obj.inspect}"
      @peer.ping(self) if @peer
    end
  end

gw_b.rb
  require 'drb/drb'
  require 'drb/gw'
  require 'drb/unix'
  
  DRb.install_id_conv(DRb::GWIdConv.new)
  
  front = DRb::GW.new
  
  s1 = DRb::DRbServer.new('drbunix:/tmp/gw_b_a', front)
  s2 = DRb::DRbServer.new('drbunix:/tmp/gw_b_c', front)
  
  s1.thread.join
  s2.thread.join

gw_a.rb
  require 'drb/unix'
  require_relative 'foo'
  
  obj = Foo.new('a')
  DRb.start_service("drbunix:/tmp/gw_a", obj)
  
  robj = DRbObject.new_with_uri('drbunix:/tmp/gw_b_a')
  robj[:a] = obj
  
  DRb.thread.join

gw_c.rb
  require 'drb/unix'
  require_relative 'foo'
  
  foo = Foo.new('c', nil)
  
  DRb.start_service("drbunix:/tmp/gw_c", nil)
  
  robj = DRbObject.new_with_uri("drbunix:/tmp/gw_b_c")
  
  puts "c->b"
  a = robj[:a]
  sleep 2
  
  a.ping(foo)
  
  DRb.thread.join

これを、gw_b, gw_a, gw_c の順に起動すると、gw_b を経由して
gw_a と gw_c が通信します。
  

= class DRb::GW

drb 通信中継のためのゲートウェイです。

中継プロセス上のこのオブジェクトに、各リモートプロセスが
中継を望むオブジェクトを登録します。そして別のプロセスがそれを取りだすことで
(中継された)通信を開始します。インターフェースは [[c:Hash]] に似ています。

詳しくは [[lib:drb/gw]] の例を見てください。

== Class Methods

--- new -> DRb::GW
新たな GW オブジェクトを生成します。

== Instance Methods

--- [](key) -> object
登録したオブジェクトを取り出します。

@param key オブジェクトを取り出すためのキー

--- []=(key, v)
オブジェクトを登録します。

key はリモートに渡すことのできる、
ハッシュのキーとして妥当なオブジェクトならなんでもかまいません(文字列など)。

@param key オブジェクトを取り出すためのキー
@param v 登録するオブジェクト

= class DRb::GWIdConv < DRb::DRbIdConv

DRb::DRbIdConv に drb 通信の中継に必要な拡張をしたもの。

詳しくは [[lib:drb/gw]] の例を見てください。


