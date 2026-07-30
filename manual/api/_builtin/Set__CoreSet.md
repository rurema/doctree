---
library: _builtin
since: "4.0"
---
# class Set::CoreSet < Set

[c:Set] のサブクラスを、互換レイヤを挟まずに作るための継承元です。

Ruby 4.0 で Set は C で再実装され、一部のメソッドの振る舞いが変わりました。
Set を直接継承すると、古い実装との互換性のための互換レイヤが自動的に
組み込まれます。互換性が不要な場合は、代わりに Set::CoreSet を継承すると、
互換レイヤを挟まないぶん効率的です。

独自のメソッドや定数は持たず、機能はすべて [c:Set] から継承します。

```ruby
class MyCoreSet < Set::CoreSet; end
p MyCoreSet[[1, 2, 3]]  # => MyCoreSet[[1, 2, 3]]
```

- **SEE** [ref:c:Set#subclass]
