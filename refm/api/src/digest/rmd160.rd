require digest

= class Digest::RMD160 < Digest::Base

Hans Dobbertin, Antoon Bosselaers, Bart Preneel によって設計された
RIPEMD-160 ハッシュ関数を実装するクラス。

== Class Methods

--- new([str])
--- digest(str)
--- hexdigest(str)
#@todo

[[c:Digest::Base]] のページを参照のこと。

== Instance Methods

--- dup
--- clone
--- digest
--- hexdigest
--- to_s
--- update(str)
--- <<(str)
--- ==(md)
--- ==(str)
#@todo

[[c:Digest::Base]] のページを参照のこと。
