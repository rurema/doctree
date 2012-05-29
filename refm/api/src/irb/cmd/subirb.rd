require irb/cmd/nop
require irb/ext/multi-irb

irb 中の irb、irb_jobs、irb_fg、irb_kill コマンドのための拡張を定義した
サブライブラリです。

このライブラリで定義されているメソッドはユーザが直接使用するものではあ
りません。

= class IRB::ExtendCommand::IrbCommand < IRB::ExtendCommand::Nop

irb 中の irb コマンドのための拡張を定義したクラスです。

== Instance Methods

--- execute(*obj) -> IRB::Irb

新しいサブ irb インタプリタを起動します。

@param obj 新しいサブ irb インタプリタで self にするオブジェクトを指定
           します。省略した場合は irb を起動したときの main オブジェク
           トを self にします。

= class IRB::ExtendCommand::Jobs < IRB::ExtendCommand::Nop

irb 中の irb_jobs コマンドのための拡張を定義したクラスです。

== Instance Methods

--- execute -> IRB::JobManager

サブ irb のリストを返します。

= class IRB::ExtendCommand::Foreground < IRB::ExtendCommand::Nop

irb 中の irb_fg コマンドのための拡張を定義したクラスです。

== Instance Methods

--- execute(*obj) -> IRB::Irb

指定したサブ irb に移動します。

@param obj 移動するサブ irb を識別する以下のいずれかのオブジェクトを指定します。

 * irb インタプリタ番号
 * irb オブジェクト
 * スレッド ID
 * 各インタプリタの self (「irb(obj)」で起動した時の obj)

= class IRB::ExtendCommand::Kill < IRB::ExtendCommand::Nop

irb 中の irb_kill コマンドのための拡張を定義したクラスです。

== Instance Methods

--- execute(*obj) -> object

指定したサブ irb を停止します。

@param obj 停止するサブ irb を識別する以下のいずれかのオブジェクトを指定します。

 * irb インタプリタ番号
 * irb オブジェクト
 * スレッド ID
 * 各インタプリタの self (「irb(obj)」で起動した時の obj)
