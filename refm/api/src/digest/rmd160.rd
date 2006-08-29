= Digest::RMD160

Hans Dobbertin, Antoon Bosselaers, Bart Preneel によって設計された 
RIPEMD-160 ハッシュ関数を実装するクラス。

== 使いかた

  require 'digest/rmd160'

== スーパークラス:

* ((<Digest::Base>))

== クラスメソッド:

--- Digest::RMD160.new([str])
--- Digest::RMD160.digest(str)
--- Digest::RMD160.hexdigest(str)

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
