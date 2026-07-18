---
library: _builtin
---
# class LocalJumpError < StandardError

ブロックを伴わずに呼び出されたメソッドの中で yield を実行すると発生します。

```ruby
def call_block
  yield 42
end
call_block  # => no block given (yield) (LocalJumpError)
```

また、[c:Proc] オブジェクト内で return や break を実行しようとしたとき、
その飛び先となるはずのメソッド呼び出しがすでに終了している(またはそもそも
存在しない)場合にも発生します。例えば、[c:Proc] オブジェクトを生成した
メソッド呼び出しが終了した後に、その [c:Proc] オブジェクトに対して return を
実行しようとした場合などです。

詳しくは [ref:d:spec/lambda_proc#orphan] を参照してください。

## Instance Methods

### def exit_value -> object

例外 LocalJumpError を発生する原因となった
break や return に渡した値を返します。

```ruby title="意図的に LocalJumpError を起こして exit_value を確認"
def foo
  proc { return 10 }
end
  
begin
  foo.call
rescue LocalJumpError => err
  p err              # => #<LocalJumpError: unexpected return>
  p err.exit_value   # => 10
end

begin
  Proc.new { break 5 }.call
rescue LocalJumpError => err
  p err              # => #<LocalJumpError: break from proc-closure>
  p err.exit_value   # => 5
end
```

### def reason -> Symbol

例外を発生させた原因をシンボルで返します。

返す値は以下のいずれかです。

  - :break
  - :redo
  - :retry
  - :next
  - :return
  - :noreason

```ruby title="意図的に LocalJumpError を起こして reason を確認"
def foo
  proc { return 10 }
end
  
begin
  foo.call
rescue LocalJumpError => err
  p err              # => #<LocalJumpError: unexpected return>
  p err.reason       # => :return
end

begin
  Proc.new { break 5 }.call
rescue LocalJumpError => err
  p err              # => #<LocalJumpError: break from proc-closure>
  p err.reason       # => :break
end
```

