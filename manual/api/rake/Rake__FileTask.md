---
library: rake
---
# class Rake::FileTask < Rake::Task

ファイルタスクは時間に基づいた依存関係を解決できるタスクです。

このタスクの事前タスクのいずれか一つのタイムスタンプがこのタスクの
タイムスタンプよりも新しければ、与えられたアクションを用いてファイルを再作成します。


## Public Instance Methods

### def needed? -> bool

このタスクが必要である場合は真を返します。
そうでない場合は偽を返します。

このタスクで作成しようとしているファイルが存在しない場合や、
このタスクで作成しようとしているファイルが古い場合に真を返します。

```ruby
# Rakefile での記載例とする

task default: "test.txt"
file "test.txt" do |task|
  Rake.application.options.build_all = false
  p task.needed? # => true
  IO.write("test.txt", "test")
  p task.needed? # => false
end
```

### def timestamp -> Time | Rake::LateTime

ファイルタスクのタイムスタンプを返します。

```ruby
# Rakefile での記載例とする

task default: "test.txt"
file "test.txt" do |task|
  Rake.application.options.build_all = false
  p task.timestamp # => #<Rake::LateTime:0x2ba58f0>
end
```

## Singleton Methods

### def scope_name(scope, task_name) -> String

ファイルタスクはスコープを無視します。
