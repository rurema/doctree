---
require:
  - date
---
Ruby の組み込みクラスのいくつかを YAML に変換するためのサブライブラリで
す。

# reopen Class

## Instance Methods

### def to_yaml(opts = {}) -> String

例外を発生します。

- **param** `opts` -- YAMLドキュメント出力の際のオプションを指定しますが使われません。

- **raise** `TypeError` --

```ruby
require 'yaml'
  
begin
  cc = Class.new
  cc.to_yaml
rescue
  p $!
  #=> #<TypeError: can't dump anonymous class Class>
end
```

# reopen Object

## Class Methods

### def yaml_tag_subclasses? -> true

常に true を返します。

ライブラリ内部で使用します。

## Instance Methods

### def taguri -> String

自身のタグ URI を返します。

### def taguri=(val)

自身のタグ URI を val に設定します。

- **param** `val` -- タグ URI を文字列で指定します。

### def to_yaml(opts = {}) -> String

自身を YAML ドキュメントに変換します。

- **param** `opts` -- YAML ドキュメント出力の際のオプションを指定します。
            オプションの詳細は [m:Syck::Emitter#reset] を参照し
            てください。

```ruby
require 'yaml'
  
h = {
  :ugo => 17,
  :hoge => "fuga",
}
  
print h.to_yaml
#=> ---
#=> :ugo: 17
#=> :hoge: fuga
  
class MyDog
  attr_accessor :name, :age
end
  
c = MyDog.new
c.name = "Pochi"
c.age = 3
print c.to_yaml
#=> --- !ruby/object:MyDog
#=> age: 3
#=> name: Pochi
```

### def to_yaml_style -> nil

nilを返します。

- **return** -- nilを返します。

```ruby title="例"
require 'yaml'
  
p to_yaml_style
#=> nil
a = []
p a.to_yaml_style
#=> nil
```

### def to_yaml_properties -> [String]

自身のインスタンス変数の一覧を文字列の配列で返します。

- **return** -- 自身のインスタンス変数名の配列

```ruby
require 'yaml'
  
h = {
  :ugo => 17,
  :hoge => "fuga",
}
  
p h.to_yaml_properties
#=> []
class MyDog
  attr_accessor :name, :age
end
  
c = MyDog.new
c.name = "Pochi"
c.age = 3
p c.to_yaml_properties
#=> ["@age", "@name"]
```

# reopen Hash

## Class Methods

### def yaml_tag_subclasses? -> true

常に true を返します。

ライブラリ内部で使用します。

## Instance Methods

### def taguri -> String

自身のタグ URI を返します。

### def taguri=(val)

自身のタグ URI を val に設定します。

- **param** `val` -- タグ URI を文字列で指定します。

### def to_yaml(opts = {}) -> String

自身を YAML ドキュメントに変換します。

- **param** `opts` -- YAML ドキュメント出力の際のオプションを指定します。
            オプションの詳細は [m:Syck::Emitter#reset] を参照し
            てください。

```text
require 'yaml'
print({"foo" => "bar"}.to_yaml)
# => ---
foo: bar
```

### def yaml_initialize(tag, val)

ライブラリ内部で使用します。

# reopen Struct

## Class Methods

### def yaml_new(klass, tag, val)

ライブラリ内部で使用します。

### def yaml_tag_class_name -> String

自身のクラス名から Struct:: をのぞいた文字列を返します。

- **return** -- 自身のクラス名から Struct::をのぞいた文字列

```ruby
require 'yaml'
  
YStruct = Struct.new("YStruct", :name)
p YStruct.yaml_tag_class_name
#=> "YStruct"
```

### def yaml_tag_subclasses? -> true

常に true を返します。

ライブラリ内部で使用します。

### def yaml_tag_read_class(name) -> String

引数 name に Struct:: を加えた文字列を返します。

- **param** `name` -- 構造体の名前を指定します。

- **return** -- 引数 name に Struct:: を加えた文字列。

```ruby
require 'yaml'
  
YStruct = Struct.new("YStruct", :name)
p YStruct.yaml_tag_read_class("YStruct")
#=> "Struct::YStruct"
```

## Instance Methods

### def taguri -> String

自身のタグ URI を返します。

### def taguri=(val)

自身のタグ URI を val に設定します。

- **param** `val` -- タグ URI を文字列で指定します。

### def to_yaml(opts = {}) -> String

自身を YAML ドキュメントに変換します。

- **param** `opts` -- YAML ドキュメント出力の際のオプションを指定します。
            オプションの詳細は [m:Syck::Emitter#reset] を参照し
            てください。

```text
require 'yaml'
Foo = Struct.new(:bar, :baz)
print Foo.new("bar", "baz").to_yaml
# => --- !ruby/struct:Foo
bar: bar
baz: baz
```

# reopen Array

## Class Methods

### def yaml_tag_subclasses? -> true

常に true を返します。

ライブラリ内部で使用します。

## Instance Methods

### def taguri -> String

自身のタグ URI を返します。

### def taguri=(val)

自身のタグ URI を val に設定します。

- **param** `val` -- タグ URI を文字列で指定します。

### def to_yaml(opts = {}) -> String

自身を YAML ドキュメントに変換します。

- **param** `opts` -- YAML ドキュメント出力の際のオプションを指定します。
            オプションの詳細は [m:Syck::Emitter#reset] を参照し
            てください。

```ruby
require 'yaml'
print [1, 2, 3].to_yaml
# => ---
- 1
- 2
- 3
```

### def yaml_initialize(tag, val)

ライブラリ内部で使用します。

# reopen Exception

## Class Methods

### def yaml_new(klass, tag, val)

ライブラリ内部で使用します。

### def yaml_tag_subclasses? -> true

常に true を返します。

ライブラリ内部で使用します。

## Instance Methods

### def taguri -> String

自身のタグ URI を返します。

### def taguri=(val)

自身のタグ URI を val に設定します。

- **param** `val` -- タグ URI を文字列で指定します。

### def to_yaml(opts = {}) -> String

自身を YAML ドキュメントに変換します。

- **param** `opts` -- YAML ドキュメント出力の際のオプションを指定します。
            オプションの詳細は [m:Syck::Emitter#reset] を参照し
            てください。

# reopen String

## Class Methods

### def yaml_new(klass, tag, val)

ライブラリ内部で使用します。

### def yaml_tag_subclasses? -> true

常に true を返します。

ライブラリ内部で使用します。

## Instance Methods

### def is_complex_yaml? -> Integer | nil

自身が複数行になるキーを含むような YAML である場合に真になる値を返しま
す。

例: ["Detroit Tigers", "Chicago cubs"] をキーとする場合

```ruby
require 'yaml'
s = <<EOS
? 
  - Detroit Tigers
  - Chicago cubs
: 
  - 2001-07-23
EOS
p s.is_complex_yaml? # => 2
p YAML.load(s) # => {["Detroit Tigers", "Chicago cubs"]=>[#<Date: 4904227/2,0,2299161>]}
```

### def is_binary_data? -> true | nil

自身が ASCII 文字以外の文字列を含む場合に true を返します。

この値が true になる場合、self.to_yaml した結果、"!binary ..." というよ
うな文字列を返します。

```text
require 'yaml'
print "テスト".to_yaml
# => --- !binary |
44OG44K544OI
```

### def taguri -> String

自身のタグ URI を返します。

### def taguri=(val)

自身のタグ URI を val に設定します。

- **param** `val` -- タグ URI を文字列で指定します。

### def to_yaml(opts = {}) -> String

自身を YAML ドキュメントに変換します。

- **param** `opts` -- YAML ドキュメント出力の際のオプションを指定します。
            オプションの詳細は [m:Syck::Emitter#reset] を参照し
            てください。

```ruby
require 'yaml'
print "foo".to_yaml # => --- foo
```

# reopen Symbol

## Class Methods

### def yaml_new(klass, tag, val)

ライブラリ内部で使用します。

### def yaml_tag_subclasses? -> true

常に true を返します。

ライブラリ内部で使用します。

## Instance Methods

### def taguri -> String

自身のタグ URI を返します。

### def taguri=(val)

自身のタグ URI を val に設定します。

- **param** `val` -- タグ URI を文字列で指定します。

### def to_yaml(opts = {}) -> String

自身を YAML ドキュメントに変換します。

- **param** `opts` -- YAML ドキュメント出力の際のオプションを指定します。
            オプションの詳細は [m:Syck::Emitter#reset] を参照し
            てください。

```ruby
require 'yaml'
print :foo.to_yaml # => --- :foo
```

# reopen Range

## Class Methods

### def yaml_new(klass, tag, val)

ライブラリ内部で使用します。

### def yaml_tag_subclasses? -> true

常に true を返します。

ライブラリ内部で使用します。

## Instance Methods

### def taguri -> String

自身のタグ URI を返します。

### def taguri=(val)

自身のタグ URI を val に設定します。

- **param** `val` -- タグ URI を文字列で指定します。

### def to_yaml(opts = {}) -> String

自身を YAML ドキュメントに変換します。

- **param** `opts` -- YAML ドキュメント出力の際のオプションを指定します。
            オプションの詳細は [m:Syck::Emitter#reset] を参照し
            てください。

```text
require 'yaml'
print (1..10).to_yaml
# => --- !ruby/range
begin: 1
end: 10
excl: false
```

# reopen Regexp

## Class Methods

### def yaml_new(klass, tag, val)

ライブラリ内部で使用します。

### def yaml_tag_subclasses? -> true

常に true を返します。

ライブラリ内部で使用します。

## Instance Methods

### def taguri -> String

自身のタグ URI を返します。

### def taguri=(val)

自身のタグ URI を val に設定します。

- **param** `val` -- タグ URI を文字列で指定します。

### def to_yaml(opts = {}) -> String

自身を YAML ドキュメントに変換します。

- **param** `opts` -- YAML ドキュメント出力の際のオプションを指定します。
            オプションの詳細は [m:Syck::Emitter#reset] を参照し
            てください。

```ruby
require 'yaml'
print /foo|bar/.to_yaml # => --- !ruby/regexp /foo|bar/
```

# reopen Time

## Class Methods

### def yaml_new(klass, tag, val)

ライブラリ内部で使用します。

### def yaml_tag_subclasses? -> true

常に true を返します。

ライブラリ内部で使用します。

## Instance Methods

### def taguri -> String

自身のタグ URI を返します。

### def taguri=(val)

自身のタグ URI を val に設定します。

- **param** `val` -- タグ URI を文字列で指定します。

### def to_yaml(opts = {}) -> String

自身を YAML ドキュメントに変換します。

- **param** `opts` -- YAML ドキュメント出力の際のオプションを指定します。
            オプションの詳細は [m:Syck::Emitter#reset] を参照し
            てください。

```ruby
require 'yaml'
print Time.now.to_yaml # => --- 2011-12-31 02:17:31.192322 +09:00
```

# reopen Date

## Class Methods

### def yaml_tag_subclasses? -> true

常に true を返します。

ライブラリ内部で使用します。

## Instance Methods

### def taguri -> String

自身のタグ URI を返します。

### def taguri=(val)

自身のタグ URI を val に設定します。

- **param** `val` -- タグ URI を文字列で指定します。

### def to_yaml(opts = {}) -> String

自身を YAML ドキュメントに変換します。

- **param** `opts` -- YAML ドキュメント出力の際のオプションを指定します。
            オプションの詳細は [m:Syck::Emitter#reset] を参照し
            てください。

```ruby
require 'yaml'
print Date.today.to_yaml # => --- 2011-12-31
```

# reopen Integer

## Class Methods

### def yaml_tag_subclasses? -> true

常に true を返します。

ライブラリ内部で使用します。

## Instance Methods

### def taguri -> String

自身のタグ URI を返します。

### def taguri=(val)

自身のタグ URI を val に設定します。

- **param** `val` -- タグ URI を文字列で指定します。

### def to_yaml(opts = {}) -> String

自身を YAML ドキュメントに変換します。

- **param** `opts` -- YAML ドキュメント出力の際のオプションを指定します。
            オプションの詳細は [m:Syck::Emitter#reset] を参照し
            てください。

```ruby
require 'yaml'
print 1.to_yaml # => --- 1
print -1.to_yaml # => --- -1
```

# reopen Float

## Class Methods

### def yaml_tag_subclasses? -> true

常に true を返します。

ライブラリ内部で使用します。

## Instance Methods

### def taguri -> String

自身のタグ URI を返します。

### def taguri=(val)

自身のタグ URI を val に設定します。

- **param** `val` -- タグ URI を文字列で指定します。

### def to_yaml(opts = {}) -> String

自身を YAML ドキュメントに変換します。

- **param** `opts` -- YAML ドキュメント出力の際のオプションを指定します。
            オプションの詳細は [m:Syck::Emitter#reset] を参照し
            てください。

```ruby
require 'yaml'
print 1.0.to_yaml        # => --- 1.0
print -1.0.to_yaml       # => --- -1.0
print (1.0/0.0).to_yaml  # => --- .Inf
print (-1.0/0.0).to_yaml # => --- -.Inf
print (0.0/0.0).to_yaml  # => --- .NaN
```

# reopen TrueClass

## Class Methods

### def yaml_tag_subclasses? -> true

常に true を返します。

ライブラリ内部で使用します。

## Instance Methods

### def taguri -> String

自身のタグ URI を返します。

### def taguri=(val)

自身のタグ URI を val に設定します。

- **param** `val` -- タグ URI を文字列で指定します。

### def to_yaml(opts = {}) -> String

自身を YAML ドキュメントに変換します。

- **param** `opts` -- YAML ドキュメント出力の際のオプションを指定します。
            オプションの詳細は [m:Syck::Emitter#reset] を参照し
            てください。

```ruby
require 'yaml'
print true.to_yaml # => --- true
```

# reopen FalseClass

## Class Methods

### def yaml_tag_subclasses? -> true

常に true を返します。

ライブラリ内部で使用します。

## Instance Methods

### def taguri -> String

自身のタグ URI を返します。

### def taguri=(val)

自身のタグ URI を val に設定します。

- **param** `val` -- タグ URI を文字列で指定します。

### def to_yaml(opts = {}) -> String

自身を YAML ドキュメントに変換します。

- **param** `opts` -- YAML ドキュメント出力の際のオプションを指定します。
            オプションの詳細は [m:Syck::Emitter#reset] を参照し
            てください。

```ruby
require 'yaml'
print false.to_yaml # => --- false
```

# reopen NilClass

## Class Methods

### def yaml_tag_subclasses? -> true

常に true を返します。

ライブラリ内部で使用します。

## Instance Methods

### def taguri -> String

自身のタグ URI を返します。

### def taguri=(val)

自身のタグ URI を val に設定します。

- **param** `val` -- タグ URI を文字列で指定します。

### def to_yaml(opts = {}) -> String

自身を YAML ドキュメントに変換します。

- **param** `opts` -- YAML ドキュメント出力の際のオプションを指定します。
            オプションの詳細は [m:Syck::Emitter#reset] を参照し
            てください。

```ruby
require 'yaml'
print nil.to_yaml # => ---
```
