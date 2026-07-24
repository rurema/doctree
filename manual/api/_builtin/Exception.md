---
library: _builtin
---
# class Exception < Object

全ての例外の祖先のクラスです。

## Class Methods

### def new(error_message = nil)       -> Exception
### def exception(error_message = nil) -> Exception

例外オブジェクトを生成して返します。

- **param** `error_message` -- エラーメッセージを表す文字列を指定します。このメッセージは
                     属性 [m:Exception#message] の値になり、デフォルトの例外ハンドラで表示されます。

```ruby title="例"
e = Exception.new("some message")
p e         # => #<Exception: some message>
p e.message # => "some message"
```

```ruby title="例"
e = Exception.exception("some message")
p e         # => #<Exception: some message>
p e.message # => "some message"
```

### def to_tty? -> bool

$stderr が変更されておらず、$stderr.tty? が真の場合は true を返します。

- **SEE** [m:Exception#full_message]

## Instance Methods

### def exception                   -> self
### def exception(error_message)    -> Exception

引数を指定しない場合は self を返します。引数を指定した場合 自身のコピー
を生成し [m:Exception#message] 属性を error_message にして返します。

[m:Kernel?.raise] は、実質的に、例外オブジェクトの exception
メソッドの呼び出しです。

- **param** `error_message` -- エラーメッセージを表す文字列を指定します。

```ruby title="例"
begin
  # ...        # 何か処理
rescue => e
  raise e.exception("an error occurs during hogehoge process")  # 詳しいエラーメッセージ
end
```

### def backtrace    -> [String]

バックトレース情報を返します。

デフォルトでは

#@since 3.4
  - "#{sourcefile}:#{sourceline}:in '#{method}'"
    (メソッド内の場合)
#@else
  - "#{sourcefile}:#{sourceline}:in `#{method}`"
    (メソッド内の場合)
#@end
  - "#{sourcefile}:#{sourceline}"
    (トップレベルの場合)

という形式の [c:String] の配列です。

```ruby title="例"
def methd
  raise
end

begin
  methd
rescue => e
  p e.backtrace
end

#@since 3.4
#=> ["filename.rb:2:in 'Object#methd'", "filename.rb:6"]
#@else
#=> ["filename.rb:2:in `methd'", "filename.rb:6"]
#@end
```

- **SEE** [m:Exception#backtrace_locations]

### def backtrace_locations -> [Thread::Backtrace::Location]

バックトレース情報を返します。[m:Exception#backtrace]に似ていますが、
[c:Thread::Backtrace::Location] の配列を返す点が異なります。

現状では [m:Exception#set_backtrace] によって戻り値が変化する事はあり
ません。

```ruby title="例: test.rb"
require "date"
def check_long_month(month)
  return if Date.new(2000, month, -1).day == 31
  raise "#{month} is not long month"
end

def get_exception
  return begin
    yield
  rescue => e
    e
  end
end

e = get_exception { check_long_month(2) }
p e.backtrace_locations
#@since 3.4
# => ["test.rb:4:in 'check_long_month'", "test.rb:15:in 'block in <main>'", "test.rb:9:in 'get_exception'", "test.rb:15:in '<main>'"]
#@else
# => ["test.rb:4:in `check_long_month'", "test.rb:15:in `block in <main>'", "test.rb:9:in `get_exception'", "test.rb:15:in `<main>'"]
#@end
```

- **SEE** [m:Exception#backtrace]

### def message    -> String
### def to_s       -> String

エラーメッセージをあらわす文字列を返します。

```ruby title="例"
begin
  1 + nil
rescue => e
  p e.message   #=>  "nil can't be coerced into Fixnum"
end
```

### def set_backtrace(errinfo)    -> nil | String | [String]

バックトレース情報に errinfo を設定し、設定されたバックトレース
情報を返します。

#@since 3.4
- **param** `errinfo` -- nil、[c:String]、[c:String] の配列、あるいは [c:Thread::Backtrace::Location] の配列のいずれかを指定します。
#@else
- **param** `errinfo` -- nil、[c:String] あるいは [c:String] の配列のいずれかを指定します。
#@end

```ruby title="例"
begin
  begin
    raise "inner"
  rescue
    raise "outer"
  end
rescue
#@since 3.4
  p $!.backtrace # => ["/path/to/test.rb:5:in 'rescue in <main>'", "/path/to/test.rb:2:in '<main>'"]
#@else
  p $!.backtrace # => ["/path/to/test.rb:5:in `rescue in <main>'", "/path/to/test.rb:2:in `<main>'"]
#@end
  $!.set_backtrace(["dummy1", "dummy2"])
  p $!.backtrace # => ["dummy1", "dummy2"]
end
```

### def inspect -> String

self のクラス名と message を文字列にして返します。

```ruby title="例"
begin
  raise "exception"
rescue
  p $!.inspect # => "#<RuntimeError: exception>"
end
```

### def ==(other)    -> bool
{: since=""}

自身と指定された other のクラスが同じであり、
message と backtrace が == メソッドで比較して
等しい場合に true を返します。そうでない場合に false を返します。

- **param** `other` -- 自身と比較したいオブジェクトを指定します。
             自身と異なるクラスのオブジェクトを指定した場合は
             [m:Exception#exception] を実行して変換を試みます。

```ruby title="例"
require "date"
def check_long_month(month)
  return if Date.new(2000, month, -1).day == 31
  raise "#{month} is not long month"
end

def get_exception
  return begin
    yield
  rescue => e
    e
  end
end

results = [2, 2, 4].map { |e | get_exception { check_long_month(e) } }
p results.map { |e| e.class }
# => [RuntimeError, RuntimeError, RuntimeError]
p results.map { |e| e.message }
# => ["2 is not long month", "2 is not long month", "4 is not long month"]

# class, message, backtrace が同一のため true になる
p results[0] == results[1]    # => true

# class, backtrace が同一だが、message がことなるため false になる
p results[0] == results[2]    # => false
```

#@#: rdoc でも表示していないため省略。
#@#: #@since 2.0.0
#@#: --- respond_to? -> bool
#@#:
#@#: nodoc
#@#:
#@#: --- respond_to_missing? -> bool
#@#:
#@#: nodoc
#@#:
#@#: #@end

### def cause -> Exception | nil

self の前の例外(self が rescue 節や ensure 節の中で発生した例外の場合、
その前に発生していた元々の例外)を返します。存在しない場合は nil を返し
ます。

```ruby title="例"
begin
  begin
    raise "inner"
  rescue
    raise "outer"
  end
rescue
  p $!       # => #<RuntimeError: outer>
  p $!.cause # => #<RuntimeError: inner>
end
```

### def full_message(highlight: true, order: :bottom)  -> String

例外の整形された文字列を返します。

返される文字列は Ruby が捕捉されなかった例外を標準エラー出力に出力するときと
同じ形式です。
そのため、メソッド呼び出し時に $stderr が変更されておらず、$stderr.tty? が真の場合は
エスケープシーケンスによる文字装飾がついています。

- **param** `highlight` -- エスケープシーケンスによる文字装飾をつけるかどうかを指定します。
                 デフォルト値は [m:Exception.to_tty?] の返り値と同じです。

- **param** `order` -- :top か :bottom で指定する必要があります。
             バックトレースの一番奥がエラーメッセージの上(top)か下(bottom)かを指定します。
             デフォルト値は [m:Exception.to_tty?] が真なら :bottom で偽なら :top です。

```ruby title="例"
begin
  raise "test"
rescue => e
#@since 3.4
  p e.full_message   # => "\e[1mTraceback \e[m(most recent call last):\ntest.rb:2:in '<main>': \e[1mtest (\e[4;1mRuntimeError\e[m\e[1m)\n\e[m"
#@else
  p e.full_message   # => "\e[1mTraceback \e[m(most recent call last):\ntest.rb:2:in `<main>': \e[1mtest (\e[4;1mRuntimeError\e[m\e[1m)\n\e[m"
#@end
  $stderr = $stdout
#@since 3.4
  p e.full_message   # => "test.rb:2:in '<main>': test (RuntimeError)\n"
#@else
  p e.full_message   # => "test.rb:2:in `<main>': test (RuntimeError)\n"
#@end
  $stderr = STDERR
#@since 3.4
  p e.full_message   # => "\e[1mTraceback \e[m(most recent call last):\ntest.rb:2:in '<main>': \e[1mtest (\e[4;1mRuntimeError\e[m\e[1m)\n\e[m"
#@else
  p e.full_message   # => "\e[1mTraceback \e[m(most recent call last):\ntest.rb:2:in `<main>': \e[1mtest (\e[4;1mRuntimeError\e[m\e[1m)\n\e[m"
#@end
end
```

- **SEE** [m:Exception.to_tty?]
