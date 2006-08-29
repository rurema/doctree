= Digest::MD5

RFC1321に記述されているRSA Data Security, Inc. の MD5 Message-Digest
Algorithmを実装するクラス。

== 使いかた

  require 'digest/md5'

== スーパークラス:

* ((<Digest::Base>))

== クラスメソッド:

--- Digest::MD5.new([str])
--- Digest::MD5.digest(str)
--- Digest::MD5.hexdigest(str)

    ((<Digest::Base>)) のページを参照のこと。

== メソッド:

--- dup
--- clone
--- digest
--- hexdigest
--- to_s
--- update(str)
--- self << str
--- self == md
--- self == str

    ((<Digest::Base>)) のページを参照のこと。
