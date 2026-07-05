---
library: timeout
alias:
#@until 3.1
  - TimeoutError
#@end
---
# class Timeout::Error < RuntimeError

[lib:timeout] で定義される例外クラスです。
関数 timeout がタイムアウトすると発生します。

[lib:timeout] を使うライブラリを作成する場合は、ユーザが指定した
timeout を捕捉しないようにライブラリ内で Timeout::Error のサブクラスを
定義して使用した方が無難です。
#@#((-注: version 1.6 では、[[unknown:ruby-list:33352]] のパッチが必要です。
#@#このパッチは 1.7 に取り込まれました[[unknown:ruby-list:33391]]-))

```````````
==> foo.rb <==
require 'timeout.rb'
class Foo
  FooTimeoutError = Class.new(Timeout::Error)
  def longlongtime_method
    Timeout.timeout(100, FooTimeoutError) {
       ...
    }
  end
end

==> main.rb <==
require 'foo'
Timeout.timeout(5) {
  Foo.new.longlongtime_method
}
```````````

#@# nodoc
#@# = class Timeout::ExitException < Exception
