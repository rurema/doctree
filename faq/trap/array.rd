= trap::Array

* Array.new([size[, val]])

  初期値 ((|val|)) は、そのコピーで初期化するわけではないことに注
  意してください。以下のようにすべての要素は同じオブジェクトを指し
  ます。

    ary = Array.new(3, "foo")
    p ary   # => ["foo", "foo", "foo"]
    ary.each {|v| p v.object_id}
    # => 537713734
         537713734
         537713734

  したがって、このような配列の要素のうち1つを破壊的に変更すれば、
  すべての要素が変更されます。

    ary = Array.new(3, "foo")
    ary[0].replace "bar"
    p ary
    # => ["bar", "bar", "bar"]

  これを避けるには例えば以下のようにします。

    ary = Array.new(3).collect { "foo" }
    ary[0].replace "bar"
    p ary
    # => ["bar", "foo", "foo"]

  ((<ruby 1.7 feature>)): version 1.7 では、ブロックを指定することでこ
  れを避けることができます。

    ary = Array.new(3) { "foo" }
    p ary   # => ["foo", "foo", "foo"]
    ary.each {|v| p v.object_id}
    # => 537770556
         537770436
         537770424

* self * times

  Array.new と同様です。

    ary = ["foo"] * 3
    ary[0].replace "bar"
    p ary
    # => ["bar", "bar", "bar"]

* Array#fill(val)

  Array.new と同様です。

    ary = Array.new(3).fill("foo")
    ary[0].replace "bar"
    p ary
    # => ["bar", "bar", "bar"]

  ((<ruby 1.7 feature>)): Array.new と同様、ブロックでこれを避けること
  ができます。

    ary = Array.new(3).fill { "foo" }
    ary[0].replace "bar"
    p ary
    # => ["bar", "foo", "foo"]

* Array#<=>

  Arrayは(({<=>}))メソッドを持っていますが、Comparableではありません。
  (((<ruby-list:18470>)),((<ruby-dev:8261>)),((<ruby-dev:2173>)))

* Array#uniq

  ((<Object/hash>))メソッドと((<Object/eql?>))を再定義していないクラスの
  オブジェクトを要素として持つ場合、思ったほど要素が減らないことがあります。

    [Hash.new, Hash.new].uniq #=> [{}, {}]
