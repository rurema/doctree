---
library: json
---
# class JSON::JSONError < StandardError

JSON のエラーのための基底クラスです。

## Singleton Methods

#%until 4.0
### def JSON::JSONError.wrap(exception) -> JSON::JSONError

任意の例外 exception を [c:JSON::JSONError] でラップして返します。

exception のクラス名とメッセージを元にしたメッセージを持つ新しい JSON::JSONError の
インスタンスを作成し、exception のバックトレースをそのまま引き継いで返します。

- **param** `exception` -- ラップする例外を指定します。

```ruby title="例"
require "json"

begin
  raise "boom"
rescue => e
  wrapped = JSON::JSONError.wrap(e)
  wrapped.class                    # => JSON::JSONError
  wrapped.message                  # => "Wrapped(RuntimeError): \"boom\""
  wrapped.backtrace == e.backtrace # => true
end
```

#%end

