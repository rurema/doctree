---
library: _builtin
---
# class ArgumentError < StandardError

引数の数があっていないときや、数は合っていて、期待される振る舞いを持ってはいるが、期待される値ではないときに発生します。

なお、期待される型ではないオブジェクトが渡された場合は、ArgumentError ではなく [c:TypeError] が発生します。

例:

`````
Time.at       # => wrong number of arguments (given 0, expected 1..2) (ArgumentError)
`````
`````
Array.new(-1) # => negative array size (ArgumentError)
`````

など

- **SEE** [c:TypeError]
