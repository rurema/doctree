---
library: rake
include:
  - RakeFileUtils
---
# reopen Kernel

## Private Instance Methods

### def task(*args){ ... } -> Rake::Task

Rake タスクを定義します。

- **param** `args` -- タスク名と依存タスクを指定します。

```ruby title="例"
task :clobber => [:clean] do
  rm_rf "html"
end
```

- **SEE** [m:Rake::Task.define_task]


### def file(*args){ ... } -> Rake::FileTask

ファイルタスクを定義します。

- **param** `args` -- ファイル名と依存ファイル名を指定します。

```ruby title="例"
file "config.cfg" => ["config.template"] do
  open("config.cfg", "w") do |outfile|
    open("config.template") do |infile|
      while line = infile.gets
        outfile.puts line
      end
    end
  end
end
```

- **SEE** [m:Rake::Task.define_task]

### def file_create(*args){ ... } -> Rake::FileCreationTask

ファイルを作成するタスクを定義します。

主に [m:Kernel?.directory] を定義するために使用します。

### def directory(dir) -> ()

与えられたディレクトリを作成するタスクを定義します。

- **param** `dir` -- 作成するディレクトリを指定します。

```ruby title="例"
directory 'testdata/doc'
```


### def multitask(args){ ... } -> Rake::MultiTask

事前タスクを並列実行するタスクを定義します。

与えられた事前タスクを実行する順序は不定です。

```ruby title="例"
multitask :deploy => [:deploy_gem, :deploy_rdoc]
```

### def namespace(name = nil){ ... } -> Rake::NameSpace

新しい名前空間を作成します。

与えられたブロックを評価する間は、その名前空間を使用します。

```ruby title="例"
ns = namespace "nested" do
  task :run
end
task_run = ns[:run] # find :run in the given namespace.
```

- **SEE** [m:Rake::TaskManager#in_namespace]

### def rule(*args){|t| ... } -> Rake::Task

自動的に作成するタスクのためのルールを定義します。

- **param** `args` -- ルールに与えるパラメータを指定します。

```ruby title="例"
rule '.o' => '.c' do |t|
  sh %{cc -o #{t.name} #{t.source}}
end
```

### def desc(description) -> String

直後の Rake タスクの説明を登録します。

- **param** `description` -- 直後のタスクの説明を指定します。

```ruby title="例"
desc "Run the Unit Tests"
task :test => [:build] do
  runtests
end
```

### def import(*filenames)

分割された Rakefile をインポートします。

インポートされたファイルは、現在のファイルが完全にロードされた後でロードされます。
このメソッドはインポートするファイルのどこで呼び出されてもかまいません。
また、インポートされるファイル内に現れるオブジェクトはインポートするファイル内で定義
されているオブジェクトに依存していてもかまいません。

このメソッドは依存関係を定義したファイルを読み込むのによく使われます。

- **param** `filenames` -- インポートする Rakefile を指定します。

```ruby title="例"
import ".depend", "my_rules"
```


