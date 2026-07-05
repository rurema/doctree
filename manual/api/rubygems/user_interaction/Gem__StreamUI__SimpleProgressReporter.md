---
library: rubygems/user_interaction
---
# class Gem::StreamUI::SimpleProgressReporter

シンプルな表示を行う進捗報告のクラスです。

## Singleton Methods

### def new(out_stream, size, initial_message, terminal_message = nil)

このクラスを初期化します。

- **param** `out_stream` -- 出力ストリームを指定します。

- **param** `size` -- 処理する全体の数です。

- **param** `initial_message` -- 初期化が終わったときに表示するメッセージを指定します。

- **param** `terminal_message` -- 終了時に表示するメッセージです。

## Public Instance Methods

### def count -> Integer

[m:Gem::StreamUI::SimpleProgressReporter#updated] が呼び出された回数を返します。

### def done -> nil

終了メッセージを表示します。

### def updated(message) -> nil

ドットを表示します。

- **param** `message` -- 指定しても意味がありません。

