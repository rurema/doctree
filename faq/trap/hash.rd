= Hash

* Hash.new([])は同じ[]を参照するので…。

  Hash.new(val) は、ハッシュのデフォルトオブジェクトに val を設定しま
  す。値が設定されていないハッシュの参照はこのデフォルトオブジェクトを
  返しているだけです。

    h = Hash.new([])
    h[0] << 0
    h[1] << 1
    p h         #=> {}
    p h.default #=> [0, 1]

  上記で、<< はデフォルトオブジェクトを破壊的に変更するだけで、h[0] など
  に影響を与えません。+= などの破壊的でないメソッドで再代入する必要が有り
  ます。

    h = Hash.new([])
    h[0] += [0]
    h[1] += [1]
    p h         #=> {0=>[0], 1=>[1]}
    p h.default #=> []

  また、このようなミスを防ぐためにも初期値は freeze しておくのが無難です。

    h = Hash.new([].freeze)
    h[0] += [0]
    h[1] << 1
    => -:3:in `<<': can't modify frozen array (TypeError)

* ((<Object/inspect>))ではデフォルトオブジェクトが表示されません。

    h = Hash.new(0)
    p h         #=> {}
    p h.default #=> 0

* ((<Object/hash>))メソッドと((<Object/eql?>))を再定義していないクラスの
  オブジェクトをキーとして使うと予想外の結果になることがあります。

    h = Hash.new
    h[//] = 1
    h[//] #=> nil

* キーとなるオブジェクトが変化した場合は((<Hash/rehash>))を呼ぶ必要が
  あります。

    a = [1]
    h = {a=>:a}
    p h[[1]] #=> :a
    a.push 2
    p h[[1,2]] #=> nil
    h.rehash
    p h[[1,2]] #=> :a

  文字列をキーにする場合は、文字列のコピーを ((<Object/freeze>)) した
  ものがキーとして使われるのでキーを書き換えることができず、
  ((<Hash/rehash>)) を呼ぶ必要性は生じません。

    a = "aaa"
    h = {a=>:a}
    p h["aaa"] #=> :a

    p [a, a.object_id, a.frozen?]                      # => ["aaa", 537759798, false]
    h.keys.each {|k| p [k, k.object_id, k.frozen?]}    # => ["aaa", 537756858, true]

    a << "bbb"
    p h["aaa"]    #=> :a
    p h["aaabbb"] #=> nil
    h.rehash
    p h["aaa"]    #=> :a
    p h["aaabbb"] #=> nil
