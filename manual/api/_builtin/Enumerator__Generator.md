---
library: _builtin
---
# class Enumerator::Generator < Object

[m:Enumerator.new] で内部的に使われるクラスで、直接使うものではありません。

## Instance Methods

### def each(*args) { ... } -> object

[m:Enumerator.new] で使われるメソッドです。

新しく生成した [c:Enumerator::Yielder] オブジェクトを先頭に、それ以降に引数 args
を続けたものを引数として、[m:Enumerator.new] に渡したブロックを実行します。
ブロックの実行結果をそのまま返します。

