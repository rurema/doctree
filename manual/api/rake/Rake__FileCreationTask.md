---
library: rake
---
# class Rake::FileCreationTask < Rake::FileTask

このタスクはファイルが存在しない場合にファイルを作成するタスクです。

対象のファイルが存在する場合は実行されません。

## Public Instance Methods

### def needed? -> bool

ファイルが存在しない場合、真を返します。
そうでない場合は、偽を返します。

#@#noexample FileTask#needed? を参照

- **SEE** [[FileTask#needed?]]

### def timestamp -> Rake::EarlyTime

どんなタイムスタンプよりも前の時刻をあらわすタイムスタンプを返します。

#@#noexample FileTask#timestamp を参照

- **SEE** [[FileTask#timestamp]]
