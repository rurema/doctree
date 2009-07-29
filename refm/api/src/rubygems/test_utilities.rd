require rubygems
require rubygems/remote_fetcher

テストで使用するクラスやメソッドを定義しています。

= class Gem::FakeFetcher

[[c:Gem::RemoteFetcher]] を置き換えるテスト用のクラスです。

使用例が見たい場合はテストコードを参照してください。

= reopen Gem::RemoteFetcher

== Singleton Methods

--- fetcher=(fetcher)

テスト用のメソッドです。

= class TempIO

テスト用に [[c:Tempfile]] をラップします。

[[c:StringIO]] と同じインタフェイスを持っていますが、
データを書き込む先は [[c:Tempfile]] になっています。
