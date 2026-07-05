---
library: irb/ext/save-history
---
# reopen IRB::Context

## Instance Methods

### def init_save_history -> ()

自身の持つ [c:IRB::InputMethod] オブジェクトが irb のヒストリを扱える
ようにします。

- **SEE** [m:IRB::HistorySavingAbility.extended]

### def save_history -> Integer | nil

履歴の最大保存件数を [c:Integer] か nil で返します。

- **return** -- 履歴の最大保存件数を [c:Integer] か nil で返します。0 以下や
        nil を返した場合は追加の保存は行いません。

- **SEE** [ref:lib:irb#history]

### def save_history=(val)

履歴の最大保存件数を val に設定します。

.irbrc ファイル中で IRB.conf[:SAVE_HISTORY] を設定する事でも同様の事が
行えます。

- **param** `val` -- 履歴の最大保存件数を [c:Integer] で指定します。0 以下や
           nil を返した場合は追加の保存は行いません。現在の件数より小さ
           い値を設定した場合は、最新の履歴から指定した件数分のみが保存
           されます。

- **SEE** [ref:lib:irb#history]

### def history_file -> String | nil

履歴ファイルのパスを返します。

- **return** -- 履歴ファイルのパスを [c:String] か nil で返します。nil を返し
        た場合は、~/.irb_history に履歴が保存されます。

- **SEE** [ref:lib:irb#history]

### def history_file=(hist)

履歴ファイルのパスを val に設定します。

.irbrc ファイル中で IRB.conf[:HISTORY_FILE] を設定する事でも同様の事が
行えます。

- **param** `hist` -- 履歴ファイルのパスを文字列で指定します。

- **SEE** [ref:lib:irb#history]

