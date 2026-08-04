---
library: reline
---
# object Reline::HISTORY

Reline で入力した内容(ヒストリ)にアクセスするための定数です。

[c:Array] のサブクラスである Reline::History クラスのインスタンスで、通常の配列と同じように履歴へアクセスできます。例えば
`Reline::HISTORY[0]` で最初の入力内容を、`Reline::HISTORY.to_a`
で全履歴を文字列の配列として取得できます。

[m:Reline.readline] や [m:Reline.readmultiline] の引数 add_hist
に真を指定すると、入力した文字列がここに追加されます。

[c:Array] と異なる点は以下の通りです。

- 要素を追加するとき(`push`・`<<` など)、inputrc の `set history-size`
  で設定した履歴サイズを超えないよう、古い履歴から削除されます。履歴サイズが
  0 のときは何も記録されず、負の値のときは無制限です(デフォルトは無制限)。
- 追加する文字列のエンコーディングは Reline の内部エンコーディングに変換されます。
- `to_s` は固定の文字列 `"HISTORY"` を返します。

```ruby title="例: 入力のたびにヒストリを配列として表示する"
require 'reline'

while buf = Reline.readline("> ", true)
  p Reline::HISTORY.to_a
  print("-> ", buf, "\n")
end
```
