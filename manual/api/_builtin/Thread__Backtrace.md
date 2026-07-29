---
library: _builtin
---
# class Thread::Backtrace < Object

バックトレースの内部表現を表すクラスです。

このクラスのオブジェクトを直接扱うことはありません。
実行中のプログラムのバックトレースに関する設定を、クラスメソッドで取得できます。

バックトレースの個々のフレームは [c:Thread::Backtrace::Location] で表されます。

#%since 3.1
## Class Methods

### def limit -> Integer

コマンドラインオプション `--backtrace-limit` で指定された、
バックトレースを表示する行数の上限を返します。

指定がない場合は -1 を返します。この場合、表示される行数は制限されません。

0 以上の値が指定されている場合、処理されなかった例外が表示されるときや
[m:Exception#full_message] が返す文字列で、バックトレースがその行数までに
省略されます。省略された分は「... 2 levels...」のように表示されます。

省略されるのは表示だけで、[m:Exception#backtrace] が返す配列は省略されません。

```ruby title="例: backtrace_limit.rb"
def level3
  raise "error"
end

def level2
  level3
end

def level1
  level2
end

p Thread::Backtrace.limit
level1
```

#%since 3.4

```
$ ruby backtrace_limit.rb
-1
backtrace_limit.rb:2:in 'Object#level3': error (RuntimeError)
	from backtrace_limit.rb:6:in 'Object#level2'
	from backtrace_limit.rb:10:in 'Object#level1'
	from backtrace_limit.rb:14:in '<main>'

$ ruby --backtrace-limit=1 backtrace_limit.rb
1
backtrace_limit.rb:2:in 'Object#level3': error (RuntimeError)
	from backtrace_limit.rb:6:in 'Object#level2'
	 ... 2 levels...
```

#%else

```
$ ruby backtrace_limit.rb
-1
backtrace_limit.rb:2:in `level3': error (RuntimeError)
	from backtrace_limit.rb:6:in `level2'
	from backtrace_limit.rb:10:in `level1'
	from backtrace_limit.rb:14:in `<main>'

$ ruby --backtrace-limit=1 backtrace_limit.rb
1
backtrace_limit.rb:2:in `level3': error (RuntimeError)
	from backtrace_limit.rb:6:in `level2'
	 ... 2 levels...
```

#%end

- **SEE** [m:Exception#full_message], [m:Exception#backtrace]
#%end
