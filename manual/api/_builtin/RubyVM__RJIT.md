---
library: _builtin
since: "3.3"
until: "4.0"
---
# module RubyVM::RJIT

Ruby の JIT (Just-in-time compiler) 関連のモジュールです。

Ruby 3.3 で MJIT に代わって導入された、Ruby で書かれた実験的な JIT コンパイラ RJIT を制御します。
コマンドラインオプション `--rjit` で有効化します。

RJIT は本番環境での利用を想定したものではなく、主に JIT コンパイラの実験や開発のためのものです。
RJIT は Ruby 4.0 で削除され、このモジュールも同時に削除されました。

## Singleton Methods

### def RubyVM::RJIT.enable -> nil

`--rjit-disable` オプション付きで起動した場合に、JIT コンパイルを開始します。

`--rjit` オプションなしで起動している場合は何も行わず、[m:RubyVM::RJIT.enabled?] も false のままです。

- **SEE** [m:RubyVM::RJIT.enabled?]

### def RubyVM::RJIT.enabled? -> bool

`--rjit` オプション付きで起動したかどうかを返します。

`--rjit-disable` オプションを併用した場合も true を返します。

```ruby title="例"
# ruby --rjit -e 'p RubyVM::RJIT.enabled?' # => true
# ruby -e 'p RubyVM::RJIT.enabled?'        # => false
p RubyVM::RJIT.enabled?
```

- **SEE** [m:RubyVM::RJIT.enable]
