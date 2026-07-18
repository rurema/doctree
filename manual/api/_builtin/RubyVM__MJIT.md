---
library: _builtin
since: "2.6.0"
until: "3.3"
---
# module RubyVM::MJIT

Ruby の JIT (Just-in-time compiler) 関連のモジュールです。

Ruby 2.6 で実験的機能として導入された MJIT (Method-based JIT) コンパイラを制御します。
コマンドラインオプション `--jit`(3.0)/`--mjit`(3.1 以降)で有効化します。

MJIT は Ruby 3.3 で削除され、このモジュールも同時に削除されました。
3.3 以降は YJIT(`RubyVM::YJIT`)や RJIT が JIT コンパイラとして提供されています。

なお、開発版の Ruby では 2021 年 1 月から 12 月にかけての一時期、
このモジュールが `RubyVM::JIT` にリネームされていたことがありますが
([feature:17490])、Ruby 3.1.0 のリリース前に `RubyVM::MJIT` へ
戻されており、`RubyVM::JIT` という名前が正式リリースに存在したことは
ありません。

## Singleton Methods

### def enabled? -> bool

JIT が有効かどうかを返します。

- **SEE** [m:RubyVM::MJIT.pause], [m:RubyVM::MJIT.resume]

### def pause(wait: true) -> bool

MJIT を一時停止します。

- **param** `wait` -- 真のときは JIT キューが空になるまで待ちます。
- **return** -- 停止したときは true を、すでに停止していたときは false を返します。
- **raise** `RuntimeError` -- JIT が有効ではないときに発生します。

- **SEE** [m:RubyVM::MJIT.enabled?], [m:RubyVM::MJIT.resume]

### def resume -> bool

[m:RubyVM::MJIT.pause] で一時停止した JIT を再開します。

- **return** -- 再開したときは true を、すでに動いているときは false を返します。
- **raise** `RuntimeError` -- JIT が有効ではないときに発生します。
- **raise** `RuntimeError` -- JIT の再開に失敗した時に発生します。

- **SEE** [m:RubyVM::MJIT.enabled?], [m:RubyVM::MJIT.pause]
