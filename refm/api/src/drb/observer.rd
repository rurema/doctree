DRb 用の修正をした [[c:Observable]] 
([[c:DRb::DRbObservable]])
を定義するライブラリ。

= module DRb::DRbObservable
include Observable

DRb 用の修正をした [[c:Observable]] モジュールです。
通常の Observable と同様に利用します。

詳しくは Observable のリファレンスを見てください。

[[m:Observable#notify_observers]] で
各オブザーバに更新を通知したときに例外を発生させた
オブジェクトをオブザーバのリストから削除します。
またその例外は破棄されます。

つまり、このモジュールは、エラーを起こしたオブザーバは
無視してしまうのが適切な場合に用います。
