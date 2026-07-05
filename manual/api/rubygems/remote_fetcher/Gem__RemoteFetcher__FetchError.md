---
library: rubygems/remote_fetcher
---
# class Gem::RemoteFetcher::FetchError < Gem::Exception

[c:Gem::RemoteFetcher] での処理で発生する IO や HTTP の例外をラップする例外クラスです。

## Singleton Methods

### def new(message, uri) -> Gem::RemoteFetcher::FetchError

この例外クラスを初期化します。

- **param** `message` -- メッセージを指定します。

- **param** `uri` -- 問題が発生した URI を指定します。


## Instance Methods

### def uri -> URI

問題が発生した URI を返します。

#@#--- to_s -> String
#@# nodoc
#@#例外の情報を文字列として返します。
