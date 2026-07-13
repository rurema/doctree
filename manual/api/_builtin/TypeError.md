---
library: _builtin
---
# class TypeError < StandardError

メソッドの引数に期待される型ではないオブジェクトや、期待される振る舞いを持たないオブジェクトが渡された時に発生します。

なお、型は合っていても値が期待されるものではない場合は、TypeError ではなく [c:ArgumentError] が発生します。

- **SEE** [c:ArgumentError]
