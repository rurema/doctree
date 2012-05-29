[[lib:shell]] で使用する例外を定義したライブラリです。

= module Shell::Error
extend Exception2MessageMapper

[[lib:shell]] で使用する例外のための名前空間です。

= class Shell::Error::CantApplyMethod < StandardError

メソッドを適用できないときに発生する例外です。

= class Shell::Error::CantDefine < StandardError

コマンドを定義出来ないときに発生する例外です。

= class Shell::Error::CommandNotFound < StandardError

コマンドが見つからないときに発生する例外です。

= class Shell::Error::DirStackEmpty < StandardError

空のディレクトリスタックから要素を取り出そうとしたときに発生する例外です。
