---
library: _builtin
since: "4.1"
---
# module Ruby::Prism

インタプリタに組み込まれた prism パーサを提供するモジュールです。
Ruby 4.1 で導入されました。[bug:22379]

実行中のプログラムを解析したパーサそのものを使って、Ruby プログラムを解析できます。
[lib:prism] の `Prism` モジュールとは独立していて、API は同じ構成です。
たとえば `Ruby::Prism.parse` は [m:Prism?.parse] に対応します。
このページには各メソッドのエントリを置いていません。メソッドの詳細は [lib:prism] のエントリを参照してください。

構文木のノードは `Ruby::Prism::Node` のサブクラスです。ノードに共通の API は [c:Prism::Node] と同じです。

このモジュールは、最初に参照したときに自動的に読み込まれます。`require "ruby/prism"` で明示的に読み込むこともできます。

`Ruby::Prism::VERSION` で、組み込まれている prism のバージョンが分かります。

API は Ruby の minor バージョン間で変わる可能性があります。実行中のインタプリタのパーサが必要な場合以外は、[lib:prism] を使ってください。

[m:Method#syntax_tree]・[m:UnboundMethod#syntax_tree]・[m:Proc#syntax_tree]・[m:Thread::Backtrace::Location#syntax_tree]・[m:RubyVM::InstructionSequence#syntax_tree] は、このモジュールのノードを返します。
`require "prism"` した prism gem の `Prism` とは別のモジュールで、ノードのクラスも別です。

```ruby title="例"
result = Ruby::Prism.parse("def m = 1")
p result.class                          # => Ruby::Prism::ParseResult
p result.value.class                    # => Ruby::Prism::ProgramNode
node = result.value.statements.body.first
p node.class                            # => Ruby::Prism::DefNode
p node.slice                            # => "def m = 1"

def m; end
p method(:m).syntax_tree.class          # => Ruby::Prism::DefNode

require "prism"
p Prism.equal?(Ruby::Prism)             # => false
p -> { 42 }.syntax_tree.is_a?(Prism::LambdaNode)       # => false
p -> { 42 }.syntax_tree.is_a?(Ruby::Prism::LambdaNode) # => true
```
