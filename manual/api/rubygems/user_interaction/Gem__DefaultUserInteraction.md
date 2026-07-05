---
library: rubygems/user_interaction
---
# module Gem::DefaultUserInteraction

このモジュールはデフォルトの [c:Gem::UserInteraction] を定義しています。

## Singleton Methods

### def ui -> Gem::ConsoleUI

デフォルトの UI を返します。

### def ui=(new_ui)

デフォルトの UI を新しくセットします。

デフォルトの UI を明確にセットしたことがなければ、シンプルなコンソールベースの
[c:Gem::UserInteraction] を自動的に使用します。

- **param** `new_ui` -- 新しい UI を指定します。

### def use_ui(new_ui){ ... }
#@# -> discard

与えられたブロックを評価している間だけ UI として new_ui を使用します。

- **param** `new_ui` -- 新しい UI を指定します。

## Public Instance Methods

### def ui -> Gem::ConsoleUI

デフォルトの UI を返します。

- **SEE** [m:Gem::DefaultUserInteraction.ui]

### def ui=(new_ui)

デフォルトの UI を新しくセットします。

- **param** `new_ui` -- 新しい UI を指定します。

- **SEE** [m:Gem::DefaultUserInteraction.ui=]

### def use_ui(new_ui){ ... }
#@# -> discard

与えられたブロックを評価している間だけ UI として new_ui を使用します。

- **param** `new_ui` -- 新しい UI を指定します。

- **SEE** [m:Gem::DefaultUserInteraction.use_ui]

