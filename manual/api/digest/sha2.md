---
type: library
require:
  - digest
---
FIPS PUB 180-2に記述されているNIST (the US' National Institute of
Standards and Technology) の以下のアルゴリズムを実装するクラスを提供するライブラリです。

  - SHA-256 Secure Hash Algorithm
  - SHA-384 Secure Hash Algorithm
  - SHA-512 Secure Hash Algorithm

# class Digest::SHA256 < Digest::Base

FIPS PUB 180-2に記述されているNIST (the US' National Institute of
Standards and Technology) の SHA-256 Secure Hash Algorithmを実装するクラスです。

# class Digest::SHA384 < Digest::Base

FIPS PUB 180-2に記述されているNIST (the US' National Institute of
Standards and Technology) の SHA-384 Secure Hash Algorithmを実装するクラスです。

# class Digest::SHA512 < Digest::Base

FIPS PUB 180-2に記述されているNIST (the US' National Institute of
Standards and Technology) の SHA-512 Secure Hash Algorithmを実装するクラスです。

# class Digest::SHA2 < Digest::Class
## Class Methods
### def Digest::SHA2.new(bitlen = 256) -> Digest::SHA2

与えられた bitlen に対応する SHA2 ハッシュを生成するためのオブジェクトを内部で設定して自身を初期化します。

- **param** `bitlen` -- ハッシュの長さを指定します。256, 384, 512 が指定可能です。

- **raise** `ArgumentError` -- bitlen に 256, 384, 512 以外の値を指定した場合に発生します。

## Instance Methods

### def block_length -> Integer

ダイジェストのブロック長を返します。

### def digest_length -> Integer

ダイジェストのハッシュ値のバイト長を返します。

### def update(str) -> self
### def <<(str) -> self

文字列 str を追加して内部状態を更新し、`self` を返します。

複数回 update を呼ぶことは、文字列を連結してから update を呼ぶことと同じです。

- **param** `str` -- 追加する文字列を指定します。

```ruby title="例"
require 'digest/sha2'

digest = Digest::SHA2.new
digest.update("ru")
digest << "by"
p digest.hexdigest # => "b9138194ffe9e7c8bb6d79d1ed56259553d18d9cb60b66e3ba5aa2e5b078055a"
```

- **SEE** [m:Digest::Base#update]

### def reset -> self

内部状態を初期状態(`new` した直後と同様の状態)に戻し、`self` を返します。

```ruby title="例"
require 'digest/sha2'

digest = Digest::SHA2.new
digest.update("ruby")
digest.reset
p digest.hexdigest # => "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
```

- **SEE** [m:Digest::Base#reset]

