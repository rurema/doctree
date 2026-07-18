---
library: openssl
---
# reopen Integer
## Instance Methods

### def to_bn -> OpenSSL::BN

Integer を同じ数を表す [c:OpenSSL::BN] のオブジェクトに
変換します。

```ruby
require 'openssl'

pp 5.to_bn     #=> #<OpenSSL::BN 5>
pp (-5).to_bn  #=> #<OpenSSL::BN -5>
```

なお、実装は、以下のようになっています。

```ruby
class Integer
  def to_bn
    OpenSSL::BN.new(self)
  end
end
```

- **SEE** [m:OpenSSL::BN.new], [m:OpenSSL::BN#to_i]
