require digest

= class Digest::SHA256 < Digest::Base

FIPS PUB 180-2に記述されているNIST (the US' National Institute of
Standards and Technology) の SHA-256 Secure Hash Algorithmを
実装するクラス。


= class Digest::SHA384 < Digest::Base

FIPS PUB 180-2に記述されているNIST (the US' National Institute of
Standards and Technology) の SHA-384 Secure Hash Algorithmを
実装するクラス。


= class Digest::SHA512 < Digest::Base

FIPS PUB 180-2に記述されているNIST (the US' National Institute of
Standards and Technology) の SHA-512 Secure Hash Algorithmを
実装するクラス。

#@since 1.8.6
= class Digest::SHA2 < Digest::Class
== Class Methods
--- new(bitlen = 256)
Creates a new SHA2 hash object with a given bit length.
#@end
