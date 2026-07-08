---
library: rake
include:
  - Comparable
  - Singleton
---
# class Rake::EarlyTime

このクラスは全てのタイムスタンプより前の時刻をあらわします。

## Public Instance Methods

### def <=>(other) -> -1

必ず -1 を返します。

- **param** `other` -- 比較対象のオブジェクト

- **return** -- -1 を返します。

#@#noexample

### def to_s -> String

"<EARLY TIME>" という文字列を返します。

#@#noexample
