---
library: rake
---
# class Rake::InvocationChain

循環したタスクの呼び出しを検出するためのクラスです。

```ruby title="例"
a = Rake::InvocationChain::EMPTY
b = a.append('task_a').append('task_b')
p b.to_s  # => "TOP => task_a => task_b"
  
a.append('task_a').append('task_b').append('task_a') # => 例外発生
```

## Public Instance Methods

### def append(task_name) -> Rake::InvocationChain

与えられたタスク名を追加して新しい [c:Rake::InvocationChain] を返します。

- **param** `task_name` -- 追加するタスク名を指定します。

- **raise** `RuntimeError` -- 循環したタスクの呼び出しを検出した場合に発生します。

```ruby
# Rakefile での記載例とする

task default: :test_rake_app
task :test_rake_app do
  invocation_chain= Rake::InvocationChain.new("task_a", Rake::InvocationChain::EMPTY)
  p invocation_chain.append("task_b") # => LL("task_b", "task_a")
end
```

### def member?(task_name) -> bool

与えられたタスク名が自身に含まれる場合は真を返します。
そうでない場合は偽を返します。

- **param** `task_name` -- タスク名を指定します。

```ruby
# Rakefile での記載例とする

task default: :test_rake_app
task :test_rake_app do
  invocation_chain = Rake::InvocationChain.new("task_a", Rake::InvocationChain::EMPTY)
  p invocation_chain.member?("task_a") # => true
  p invocation_chain.member?("task_b") # => false
end
```

### def to_s -> String

トップレベルのタスクから自身までの依存関係を文字列として返します。

```ruby
# Rakefile での記載例とする

task default: :test_rake_app
task :test_rake_app do
  invocation_chain= Rake::InvocationChain.new("task_a", Rake::InvocationChain::EMPTY)
  p invocation_chain.to_s # => "TOP => task_a"
end
```

## Singleton Methods

### def new(task_name, tail)

与えられたタスク名と一つ前の [c:Rake::InvocationChain] を用いて自身を初期化します。

- **param** `task_name` -- タスク名を指定します。

- **param** `tail` -- 一つ前の [c:Rake::InvocationChain] を指定します。

```ruby
# Rakefile での記載例とする

task default: :test_rake_app
task :test_rake_app do
  tail = Rake::InvocationChain.new("task_a", Rake::InvocationChain::EMPTY)
  p tail.to_s # => "TOP => task_a"
  b = Rake::InvocationChain.new("task_b", tail)
  p b.to_s # => "TOP => task_a => task_b"
end
```

### def append(task_name, chain) -> Rake::InvocationChain

与えられたタスク名を第二引数の [c:Rake::InvocationChain] に追加します。

- **param** `task_name` -- タスク名を指定します。

- **param** `chain` -- 既に存在する [c:Rake::InvocationChain] のインスタンスを指定します。

```ruby
# Rakefile での記載例とする

task default: :test_rake_app
task :test_rake_app do
  chain = Rake::InvocationChain::EMPTY
  b = Rake::InvocationChain.append("task_a", chain)
  p b.to_s # => "TOP => task_a"
end
```

## Constants

### const EMPTY -> Rake::InvocationChain::EmptyInvocationChain

[c:Rake::InvocationChain::EmptyInvocationChain] のインスタンスを表します。

# class Rake::InvocationChain::EmptyInvocationChain

呼び出し関係のトップレベルを表します。

## Public Instance Methods

### def member?(task_name) -> bool

偽を返します。

#@#noexample

### def append(task_name) -> Rake::InvocationChain

与えられた値を追加した [c:Rake::InvocationChain] を返します。

- **param** `task_name` -- 追加する値を指定します。

#@#noexample

### def to_s -> String

'TOP' という文字列を返します。

#@#noexample
