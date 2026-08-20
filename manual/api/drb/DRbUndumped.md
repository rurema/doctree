---
library: drb
alias:
  - DRbUndumped
---
# module DRb::DRbUndumped

このモジュールをインクルードしたクラスのインスタンスはネットワーク越しに参照渡しで渡されるようになります。
値渡し出来ないオブジェクトを [lib:drb] と一緒に使う時に有用です。

また [`Marshal.dump(obj)`](m:Marshal?.dump) が必ず失敗するようになります。
