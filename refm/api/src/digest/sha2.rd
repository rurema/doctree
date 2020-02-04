require digest

FIPS PUB 180-2に記述されているNIST (the US' National Institute of
Standards and Technology) の以下のアルゴリズムを実装するクラスを提供す
るライブラリです。

  * SHA-256 Secure Hash Algorithm
  * SHA-384 Secure Hash Algorithm
  * SHA-512 Secure Hash Algorithm

= class Digest::SHA256 < Digest::Base

FIPS PUB 180-2に記述されているNIST (the US' National Institute of
Standards and Technology) の SHA-256 Secure Hash Algorithmを
実装するクラスです。


= class Digest::SHA384 < Digest::Base

FIPS PUB 180-2に記述されているNIST (the US' National Institute of
Standards and Technology) の SHA-384 Secure Hash Algorithmを
実装するクラスです。


= class Digest::SHA512 < Digest::Base

FIPS PUB 180-2に記述されているNIST (the US' National Institute of
Standards and Technology) の SHA-512 Secure Hash Algorithmを
実装するクラスです。

= class Digest::SHA2 < Digest::Class
== Class Methods
--- new(bitlen = 256) -> Digest::SHA2

与えられた bitlen に対応する SHA2 ハッシュを生成するためのオブジェクト
を内部で設定して自身を初期化します。

@param bitlen ハッシュの長さを指定します。256, 384, 512 が指定可能です。

@raise ArgumentError bitlen に 256, 384, 512 以外の値を指定した場合に発生します。

== Instance Methods

--- block_length -> Integer

ダイジェストのブロック長を返します。

--- digest_length -> Integer

ダイジェストのハッシュ値のバイト長を返します。

