---
library: _builtin
since: "3.4"
---
# class RubyVM::AbstractSyntaxTree::Location < Object

抽象構文木のノード([c:RubyVM::AbstractSyntaxTree::Node])に関連づけられた位置情報を表すクラスです。

[m:RubyVM::AbstractSyntaxTree::Node#locations] で取得できます。

[c:RubyVM::AbstractSyntaxTree] と同様に CRuby の実装の詳細を表す実験的な API であり、予告なしに変更される可能性があります。

## Instance Methods

### def first_column -> Integer

ソースコード中で、この位置情報が指す範囲が始まる列番号を返します。

列番号は0-originで、バイト単位で表されます。

```ruby
loc = RubyVM::AbstractSyntaxTree.parse('1 + 2').locations.first
p loc.first_column # => 0
```

### def first_lineno -> Integer

ソースコード中で、この位置情報が指す範囲が始まる行番号を返します。

行番号は1-originです。

```ruby
loc = RubyVM::AbstractSyntaxTree.parse('1 + 2').locations.first
p loc.first_lineno # => 1
```

### def last_column -> Integer

ソースコード中で、この位置情報が指す範囲が終わる列番号を返します。

列番号は0-originで、バイト単位で表されます。

```ruby
loc = RubyVM::AbstractSyntaxTree.parse('1 + 2').locations.first
p loc.last_column # => 5
```

### def last_lineno -> Integer

ソースコード中で、この位置情報が指す範囲が終わる行番号を返します。

行番号は1-originです。

```ruby
loc = RubyVM::AbstractSyntaxTree.parse('1 + 2').locations.first
p loc.last_lineno # => 1
```
