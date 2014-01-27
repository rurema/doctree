Rubyで実装されたタプルスペース(Tuple Space)を扱うためのライブラリです。

タプルスペースとは並列プログラムにおける一つのパターンです。
並列プログラミングにおいては、ロックのような同期処理が必須ですが、
適切な同期処理を実現することは困難をともないます。
このパターンにおいては、複数の並列単位(スレッド/プロセス)間の通信をすべて
タプルスペースという領域を経由して行います。これによって
プロセス間の通信トポロジーを単純化し、問題を簡単化します。
タプルスペースに対しては、タプルを書き込む(write)、取り出す(take)、
タプルの要素を覗き見る(read)
という操作のみが利用できます。可能な操作を限定し、定型化することで
安全な同期処理を実現します。rinda においてはタプルとは
配列もしくはハッシュテーブルを意味します。
タプルを取り出すときにはパターンを指定して、それにマッチした
もののみを取り出すことができます。特にタプルの第1要素最初の要素を
限定することで必要なタプルのみを取り出します。

タプルスペースそのものの実装は [[lib:rinda/tuplespace]] でなされています。
このライブラリはタプルスペースへのアクセス機能等を提供します。

=== 参考
  * [[url:http://www.druby.org/ilikeruby/rinda.html]]
  * [[url:http://www2a.biglobe.ne.jp/~seki/ruby/d208.html]]

===[a:tuplepattern] タプルのパターンについて
[[m:Rinda::TupleSpace#take]] や [[m:Rinda::TupleSpaceProxy#take]] などでは
取り出したいタプルを指定するため、パターンをメソッドの引数に渡す必要があります。

パターンは配列、もしくはハッシュテーブルのいずれかです。
配列によるパターンは配列によるタプルにのみ、
ハッシュテーブルによるパターンはハッシュテーブルによるタプルにのみ、
それぞれマッチします。

パターンが配列の場合は、長さが同じ配列タプルにのみマッチします。
そしてパターン配列の各要素が対応する配列タプルの各要素にマッチする
場合にパターンがタプルにマッチします。
各要素に関しては以下が成立する場合にマッチします。
  * パターン側の要素が nil である (つまり nil はワイルドカード)
  * 「パターン側の要素 == タプル側の要素」 が成立する(例えば2つの文字列が等しい)
  * 「パターン側の要素 === タプル側の要素」 が成立する(例えばパターン側に正規表現を指定し、
    タプル側がマッチする文字列である場合。別の例としてパターン側にクラスを指定し、
    タプル側がそのインスタンスである場合)

パターンがハッシュテーブルの場合、キーと値のペアの個数が一致し、
キーの集合が一致し、それぞれのキーに対応する値がマッチする
場合にパターンがタプルにマッチします。値のマッチのルールは
配列の各要素に関するマッチのルールと同じです。

=== 例
この例では、rinda_ts.rb を起動したプロセスがタプルスペースを提供します。

rindas.rb はタプルスペースに書き込まれたクエリ('sum' というキーのタプル)
を取り出し、それを2倍したものを応答として('ans'というキーのタプル)
タプルスペースに書き込みます。

一方 rindac.rb はクエリ('sum' というキーのタプル)をタプルスペースに書き込み、
その応答('ans'というキーのタプル)をタプルスペースから取り出して表示します。

例の動かしかたは以下の通りです。
  # まず、rinda_ts.rb を動かす
  ruby rinda_ts.rb druby://localhost:40121
  
  # rinda_ts.rb を動かしたまま、rindas.rbを動かす
  # 複数の rindas.rb を同時に動かしてもよい。
  # 別のターミナルで:
  ruby rindas.rb druby://localhost:40121
  
  # rindac.rb を動かし、クエリをタプルスペースに書き込む
  ruby rindac.rb druby://localhost:40121
  # on rindas.rb terminal
  do_it(1)
  do_it(2)
  do_it(3)
  do_it(4)
  do_it(5)
  do_it(6)
  do_it(7)
  do_it(8)
  do_it(9)
  do_it(10)
  # on rindac.rb terminal
  [1, 2]
  [2, 4]
  [3, 6]
  [4, 8]
  [5, 10]
  [6, 12]
  [7, 14]
  [8, 16]
  [9, 18]
  [10, 20]

rindas.rb や rindac.rb を同時に複数動かすと、タプルスペースの並列性の問題に
ついてのよりよい理解が得られます。例えば rindas.rb を複数動かすと、
rindac.rb からのクエリを複数の rindas.rb が分散して処理します。
複数の rindac.rb を動かしても、応答が混ざったりせず、rindac.rb に適切に
応答が返されます。これは DRb.uri を使うことで rindac.rb のプロセスを
一意に同定しているからです。

  # rinda_ts.rb
  require 'drb/drb'
  require 'rinda/tuplespace'
  
  uri = ARGV.shift
  DRb.start_service(uri, Rinda::TupleSpace.new)
  puts DRb.uri
  DRb.thread.join


  # rindas.rb
  require 'drb/drb'
  require 'rinda/rinda'
  
  def do_it(v)
    puts "do_it(#{v})"
    v + v
  end
  
  uri = ARGV.shift || raise("usage: #{$0} <server_uri>")
  
  DRb.start_service
  ts = Rinda::TupleSpaceProxy.new(DRbObject.new(nil, uri))
  
  while true
    r = ts.take(['sum', nil, nil])
    v = do_it(r[2])
    ts.write(['ans', r[1], r[2], v])
  end


  # rindac.rb
  require 'drb/drb'
  require 'rinda/rinda'
  
  uri = ARGV.shift || raise("usage: #{$0} <server_uri>")
  
  DRb.start_service
  ts = Rinda::TupleSpaceProxy.new(DRbObject.new(nil, uri))
  
  (1..10).each do |n|
    ts.write(['sum', DRb.uri, n])
  end
  
  (1..10).each do |n|
    ans = ts.take(['ans', DRb.uri, n, nil])
    p [ans[2], ans[3]]
  end

この例は ruby の配布物の sample/drb/rinda{_ts,s,c}.rb と同じものです。

= module Rinda
[[lib:rinda/rinda]] および [[lib:rinda/tuplespace]] の名前空間を提供する
モジュール。


#@include(Rinda__DRbObjectTemplate)
#@include(Rinda__InvalidHashTupleKey)
#@include(Rinda__RequestCanceledError)
#@include(Rinda__RequestExpiredError)
#@include(Rinda__RindaError)
#@include(Rinda__SimpleRenewer)
#@include(Rinda__Tuple)
#@include(Rinda__Template)
#@include(Rinda__TupleSpaceProxy)
