---
library: psych
---
# class Psych::Visitors

Psych 内部で利用する各種 Visitor class を保持しているモジュール。

# class Psych::Visitors::Visitor

Psych 内部で利用する、Visitor パターンのための 抽象クラス。

# class Psych::Visitors::YAMLTree < Psych::Visitors::Visitor

Ruby オブジェクトから YAML の AST を構築するためのクラスです。

### 例

```ruby
require 'psych'

builder = Psych::Visitors::YAMLTree.create
builder << { :foo => 'bar' }
builder << ["baz", "bazbaz"]
p builder.tree # => #<Psych::Nodes::Stream ... > A stream containing two documents
puts builder.tree.to_yaml
# =>
# ---
# :foo: bar
# ---
# - baz
# - bazbaz
```

## Class Methods
### def Psych::Visitors::YAMLTree.create(options = {}, emitter = nil) -> Psych::Visitors::YAMLTree
### def Psych::Visitors::YAMLTree.new(emitter, ss, options) -> Psych::Visitors::YAMLTree

YAMLTree オブジェクトを生成します。

options には構築される YAML AST に設定されるオプション設定を指定します。
[m:Psych.dump] と同じオプションが指定できます。

emitter には AST の構築に使われる [c:Psych::TreeBuilder] オブジェクトを渡します。

ss は Ruby の [c:String] が YAML document 上で quote が必要かどうかを判定するための [c:Psych::ScalarScanner] オブジェクトを渡します。

emitter, ss は通常デフォルトのものから変える必要はないでしょう。
create では emitter を省略すると [c:Psych::TreeBuilder] が、ss には [c:Psych::ScalarScanner] が用意されます。
new は 3 つの引数がすべて必須です。

- **param** `options` -- オプション
- **param** `emitter` -- AST の構築に使う [c:Psych::TreeBuilder] オブジェクト
- **param** `ss` -- 文字列に quote が必要かどうかを判定するための [c:Psych::ScalarScanner] オブジェクト

## Instance Methods
### def started -> bool
### def started? -> bool

[m:Psych::Visitors::YAMLTree#start] をすでに呼び出しているならば真を返します。

まだならば偽を返します。

### def finished -> bool
### def finished? -> bool

[m:Psych::Visitors::YAMLTree#finish] をすでに呼び出しているならば真を返します。

まだならば偽を返します。

### def start(encoding = Nodes::Stream::UTF8) -> Psych::Nodes::Stream

Ruby オブジェクトから YAML AST への変換のための準備をします。

[m:Psych::Visitors::YAMLTree#push] が呼び出されたとき、まだこのメソッドが呼び出されていなければ push メソッドがこのメソッドを呼び出し、変換の準備をします。

encoding には以下のいずれかを指定できます。
  - [m:Psych::Nodes::Stream::UTF8]
  - [m:Psych::Nodes::Stream::UTF16BE]
  - [m:Psych::Nodes::Stream::UTF16LE]

- **param** `encoding` -- YAML AST に設定するエンコーディング

### def finish -> Psych::Nodes::Stream|nil

変換を終了し、構築した AST を返します。

このメソッドは2回呼び出さないでください。

- **SEE** [m:Psych::Visitors::YAMLTree#tree]

### def tree -> Psych::Nodes::Stream|nil

変換を終了し、構築した AST を返します。

内部で finish を呼び出し、変換処理を終了します。

このメソッドを2回以上呼ぶと、2回目以降は nil を返します。

- **SEE** [m:Psych::Visitors::YAMLTree#finish]

### def push(object)
### def <<(object)

変換対象の Ruby オブジェクトを追加します。

- **param** `object` -- YAML AST へ変換する Ruby オブジェクト

#%# accept and visit_* is used internally. Not documented here.
#%# --- accept(target)
#%# #@todo

#%# = class Psych::Visitors::ToRuby
#%# YAML AST を traverse して Ruby オブジェクトを生成するクラス
#%# Psych::Nodes::Node#to_ruby を使うべきなのでこれに関するドキュメントはなし

#%# = class Psych::Visitors::DepthFirst
#%# YAML AST を traverse して block を call するクラス
#%# Psych::Nodes::Node#each を使うべき

#%# = class Psych::Visitors::Emitter
#%# YAML AST を traverse して Psych::Emitter に適切なイベントを
#%# 送ることで YAML document を生成するクラス
#%# Psych::Nodes::Node#to_yaml を使うべき

#%# = class Psych::Visitors::JSONTree < Psych::Visitors::YAMLTree
#%# Ruby オブジェクトから JSON 用の AST を構築するためのクラスです。
#%#
#%# AST は YAML 用の AST と同様 [[c:Psych::Nodes::Node]] のサブクラスに
#%# よって表現されます。しかし JSON と YAML の仕様の違い(基本的に
#%# YAML のほうが rich なデータ型を持っています。例えば JSON には
#%# Symbol を表現する方法がなく、文字列ど同一視されます)を
#%# ごまかすための仕組みが含まれています。
#%#
#%# 実際問題としてこれを直接は使わない気がするのでドキュメントは書きません。
#%#
#%# == Class Methods
#%# --- new(options = {}, emitter = Psych::JSON::TreeBuilder.new)
#%#
#%# JSON の仕様は YAML の仕様の subset と見なせることを使って
#%# JSON の処理をしている。
