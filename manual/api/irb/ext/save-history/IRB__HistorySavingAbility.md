---
library: irb/ext/save-history
include:
  - Readline
---
# module IRB::HistorySavingAbility

[c:IRB::HistorySavingAbility] を extend したオブジェクトに irb のヒス
トリの読み込み、保存の機能を提供するモジュールです。

## Class Methods

### def extended(obj) -> object

obj に irb のヒストリの読み込み、保存の機能を提供します。

obj を返します。

- **param** `obj` -- [c:IRB::HistorySavingAbility] を extend したオブジェクトです。

## Instance Methods

### def load_history -> ()

irb のヒストリを履歴ファイルから読み込みます。

- **SEE** [ref:lib:irb#history]

### def save_history -> ()

irb のヒストリを履歴ファイルに保存します。

- **SEE** [ref:lib:irb#history]
