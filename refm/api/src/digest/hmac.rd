require digest

キー付きハッシュアルゴリズム HMAC(Keyed-Hashing for Message Authentication code)
の実装の一つを提供するライブラリです。

このライブラリは 2.2.0 で削除されました。また、2.2.0 以前でも実験的な実装なので [[lib:openssl]] に含まれている [[c:OpenSSL::HMAC]] を使ってください。

HMAC は [[RFC:2104]] で定義されています。

=== 例

  require 'digest/hmac'

  # one-liner example
  puts Digest::HMAC.hexdigest("data", "hash key", Digest::SHA1)

  # rather longer one
  hmac = Digest::HMAC.new("foo", Digest::RMD160)

  buf = ""
  while stream.read(16384, buf)
    hmac.update(buf)
  end

  puts hmac.bubblebabble

= class Digest::HMAC < Digest::Class

キー付きハッシュアルゴリズム HMAC の実装の一つを提供するクラスです。

== Class Methods

--- new(key, digester) -> Digest::HMAC

与えられて鍵とアルゴリズムをもとにして自身を初期化します。

@param key 秘密鍵を指定します。

@param digester ダイジェストを生成するためのクラスを指定します。

== Instance Methods

--- block_length -> Integer

ダイジェストのブロック長を返します。

--- digest_length -> Integer

ダイジェストのハッシュ値のバイト長を返します。

#@#--- update(text)
#@# maybe nodoc

#@#--- reset
#@# maybe nodoc

#@#--- inspect
#@# maybe nodoc
