---
library: _builtin
since: "2.0.0"
---
# class Thread::Backtrace::Location < Object

Ruby のフレームを表すクラスです。

[m:Kernel?.caller_locations] から生成されます。

```ruby title="例1"
# caller_locations.rb
def a(skip)
  caller_locations(skip)
end
def b(skip)
  a(skip)
end
def c(skip)
  b(skip)
end

c(0..2).map do |call|
  puts call.to_s
end
```

```text title="例1の実行結果"
#%since 3.4
caller_locations.rb:2:in 'a'
caller_locations.rb:5:in 'b'
caller_locations.rb:8:in 'c'
#%else
caller_locations.rb:2:in `a'
caller_locations.rb:5:in `b'
caller_locations.rb:8:in `c'
#%end
```

```ruby title="例2"
# foo.rb
class Foo
  attr_accessor :locations
  def initialize(skip)
    @locations = caller_locations(skip)
  end
end

Foo.new(0..2).locations.map do |call|
  puts call.to_s
end
```

```text title="例2の実行結果"
#%since 3.4
init.rb:4:in 'initialize'
init.rb:8:in 'new'
init.rb:8:in '<main>'
#%else
init.rb:4:in `initialize'
init.rb:8:in `new'
init.rb:8:in `<main>'
#%end
```

### 参考

- Ruby VM アドベントカレンダー #4 vm_backtrace.c: <https://www.atdot.net/~ko1/diary/201212.html#d4>

## Instance Methods

### def lineno -> Integer

self が表すフレームの行番号を返します。

例: [c:Thread::Backtrace::Location] の例1を用いた例

```ruby
loc = c(0..1).first
p loc.lineno # => 2
```

### def label -> String

self が表すフレームのラベルを返します。通常、メソッド名、クラス名、モジュール名などで構成されます。

例: [c:Thread::Backtrace::Location] の例1を用いた例

```ruby
loc = c(0..1).first
p loc.label # => "a"
```

- **SEE** [m:Thread::Backtrace::Location#base_label]

### def base_label -> String

self が表すフレームの基本ラベルを返します。通常、
[m:Thread::Backtrace::Location#label] から修飾を取り除いたもので構成されます。

```ruby title="例"
# foo.rb
class Foo
  attr_accessor :locations
  def initialize(skip)
    @locations = caller_locations(skip)
  end
end

Foo.new(0..2).locations.map do |call|
  puts call.base_label
end

# => initialize
# new
# <main>
```

- **SEE** [m:Thread::Backtrace::Location#label]

### def path -> String

self が表すフレームのファイル名を返します。

例: [c:Thread::Backtrace::Location] の例1を用いた例

```ruby
loc = c(0..1).first
p loc.path # => "caller_locations.rb"
```

- **SEE** [m:Thread::Backtrace::Location#absolute_path]

### def absolute_path -> String

self が表すフレームの絶対パスを返します。

```ruby title="例"
# foo.rb
class Foo
  attr_accessor :locations
  def initialize(skip)
    @locations = caller_locations(skip)
  end
end

Foo.new(0..2).locations.map do |call|
  puts call.absolute_path
end

# => /path/to/foo.rb
# /path/to/foo.rb
# /path/to/foo.rb
```

- **SEE** [m:Thread::Backtrace::Location#path]

### def to_s -> String

self が表すフレームを [m:Kernel?.caller] と同じ表現にした文字列を返します。

```ruby title="例"
# foo.rb
class Foo
  attr_accessor :locations
  def initialize(skip)
    @locations = caller_locations(skip)
  end
end

Foo.new(0..2).locations.map do |call|
  puts call.to_s
end

#%since 3.4
# => path/to/foo.rb:5:in 'initialize'
# path/to/foo.rb:9:in 'new'
# path/to/foo.rb:9:in '<main>'
#%else
# => path/to/foo.rb:5:in `initialize'
# path/to/foo.rb:9:in `new'
# path/to/foo.rb:9:in `<main>'
#%end
```

### def inspect -> String

[m:Thread::Backtrace::Location#to_s] の結果を人間が読みやすいような文字列に変換したオブジェクトを返します。

```ruby title="例"
# foo.rb
class Foo
  attr_accessor :locations
  def initialize(skip)
    @locations = caller_locations(skip)
  end
end

Foo.new(0..2).locations.map do |call|
  puts call.inspect
end

#%since 3.4
# => "path/to/foo.rb:5:in 'initialize'"
# "path/to/foo.rb:9:in 'new'"
# "path/to/foo.rb:9:in '<main>'"
#%else
# => "path/to/foo.rb:5:in `initialize'"
# "path/to/foo.rb:9:in `new'"
# "path/to/foo.rb:9:in `<main>'"
#%end
```

#%since 4.1
### def source_range -> Ruby::SourceRange

`self` が表すフレームに対応する Ruby の式の [c:Ruby::SourceRange] を返します。

CRuby では、このメソッドは呼び出されるたびにソースファイルを再度読み込んでパースし直すことで範囲を求めます。読み込みで発生したファイルのエラー(存在しないファイルに対する `Errno::ENOENT` など)はそのまま発生します。

`RubyVM.keep_script_lines = true` を指定すると、ソースファイルをメモリ上に保持し、ファイルシステムからの再読み込みを避けられます。eval したコードのフレームでは、`RubyVM.keep_script_lines = true` を指定していないと範囲を取得できません。

- **raise** `RuntimeError` -- ソースが変更されているなど、範囲を求めるために必要な情報が得られない場合に発生します。
- **raise** `ArgumentError` -- eval したコードのフレームで、`RubyVM.keep_script_lines = true` を指定していない場合に発生します。

```ruby title="例"
loc = caller_locations(0, 1)[0]
range = loc.source_range
p range.path == loc.path         # => true
p range.start_line == loc.lineno # => true
```

- **SEE** [m:Thread::Backtrace::Location#syntax_tree], [m:Proc#source_range]

### def syntax_tree -> Prism::Node | RubyVM::AbstractSyntaxTree::Node | nil

`self` が表すフレームに対応する抽象構文木(AST)のノードを、ソースファイルを再度パースし直すことで返します。

ノードを確実に取得できない場合に nil を返す条件については [m:RubyVM::InstructionSequence#syntax_tree] を参照してください。

このメソッドは実験的なもので、予告なく変更される可能性があります。

```ruby title="例"
node = -> { caller_locations(0, 1)[0] }.call.syntax_tree
p node.is_a?(Prism::CallNode) # => true
p node.name                   # => :caller_locations
```

- **SEE** [m:Thread::Backtrace::Location#source_range], [m:RubyVM::InstructionSequence#syntax_tree]

#%end

