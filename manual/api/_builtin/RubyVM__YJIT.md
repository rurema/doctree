---
library: _builtin
since: "3.1"
---
# module RubyVM::YJIT

YJIT (Yet Another Ruby JIT) の制御・情報取得のためのモジュールです。

YJIT は CRuby に組み込まれた JIT (Just-in-time compiler) コンパイラで、
Ruby 3.1 で実験的機能として導入されました([feature:18229])。
Ruby 3.2 で「実験的」の位置づけが外れ、Ruby 3.3 では実行時に有効化する
[m:RubyVM::YJIT.enable] が追加されるなど、以降のバージョンでも
統計収集(`--yjit-stats`)やコンパイルログ(`--yjit-log`)まわりの
機能追加が続いています。

有効化するには以下のいずれかの方法を使います。

* コマンドラインオプション `--yjit`
* 環境変数 `RUBY_YJIT_ENABLE`
* (Ruby 3.3 以降) [m:RubyVM::YJIT.enable] による実行時の有効化

このモジュールは、YJIT が対応していないプラットフォームでは
定義されないことがあります。

なお、Ruby 4.0 で導入された新しい JIT コンパイラである ZJIT は
`RubyVM::ZJIT` という別のモジュールで提供されており、
`RubyVM::YJIT` とは別物です。

#@if(version < "3.3")
- **SEE** [c:RubyVM::MJIT]
#@end

## Singleton Methods

### def enabled? -> bool

YJIT が有効かどうかを返します。

```ruby
RubyVM::YJIT.enabled? # => false
```

JIT の有効・無効はコマンドラインオプションや環境変数など実行環境に依存するため、
実行結果は環境によって異なります。

- **SEE** [m:RubyVM::YJIT.enable]

### def stats_enabled? -> bool

`--yjit-stats` が指定されているなど、統計情報の収集が有効かどうかを返します。

- **SEE** [m:RubyVM::YJIT.runtime_stats], [m:RubyVM::YJIT.reset_stats!], [m:RubyVM::YJIT.enable]

#@since 3.4
### def log_enabled? -> bool

`--yjit-log` が指定されているなど、コンパイルログの収集が有効かどうかを返します。

- **SEE** [m:RubyVM::YJIT.log], [m:RubyVM::YJIT.enable]
#@end

### def reset_stats! -> nil

`--yjit-stats` で収集した統計情報を破棄します。

- **SEE** [m:RubyVM::YJIT.runtime_stats], [m:RubyVM::YJIT.stats_enabled?]

#@since 3.3
#@if("4.0" <= version)
### def enable(stats: false, log: false, mem_size: nil, call_threshold: nil) -> bool
#@end
#@if("3.4" <= version and version < "4.0")
### def enable(stats: false, log: false) -> bool
#@end
#@if(version < "3.4")
### def enable(stats: false) -> bool
#@end

実行時に YJIT を有効化します。

- **param** `stats` -- 統計収集の設定です。`false` なら収集しません。`true` なら収集し、
  終了時に結果を表示します。`:quiet` なら収集しますが、終了時には表示しません。
#@since 3.4
- **param** `log` -- コンパイルログ収集の設定です。指定できる値は `stats` と同様です。
  (Ruby 3.4 で追加されたキーワード引数です)
#@end
#@since 4.0
- **param** `mem_size` -- YJIT が使用するメモリ量の上限を MB 単位(1 から 2048 の範囲)で指定します。
  `nil` の場合はデフォルト値を使います。(Ruby 4.0 で追加されたキーワード引数です)
- **param** `call_threshold` -- JIT コンパイルを開始するまでのメソッド呼び出し回数のしきい値を指定します。
  `nil` の場合はデフォルト値を使います。(Ruby 4.0 で追加されたキーワード引数です)
#@end
#@since 4.0
- **return** -- 有効化したときは true を返します。すでに YJIT が有効な場合や、
  ZJIT (`RubyVM::ZJIT`) が有効になっている場合は false を返します。
- **raise** `ArgumentError` -- `mem_size` や `call_threshold` に不正な値を指定した場合に発生します。
#@else
- **return** -- 有効化したときは true を返します。すでに YJIT が有効な場合は false を返します。
#@end

```ruby
RubyVM::YJIT.enable # => true
```

JIT の有効・無効はビルドオプションや実行環境に依存するため、実行結果は環境によって異なります。

- **SEE** [m:RubyVM::YJIT.enabled?]
#@end

#@since 3.2
### def dump_exit_locations(filename) -> Integer

`--yjit-trace-exits` を指定して収集した、サイドイグジット(exit)が発生した位置の情報を
Marshal 形式で `filename` にダンプします。ダンプしたファイルは Stackprof で読み込んで解析できます。

- **param** `filename` -- ダンプ先のファイル名。
- **return** -- ファイルに書き込んだバイト数を返します。
- **raise** `ArgumentError` -- `--yjit-trace-exits` が有効になっていない場合に発生します。

#@#noexample 実行環境に依存するため
#@end

#@if("3.4" <= version)
### def runtime_stats(key = nil) -> Hash | object | nil
#@end
#@if("3.3" <= version and version < "3.4")
### def runtime_stats(context: false) -> Hash | nil
#@end
#@if(version < "3.3")
### def runtime_stats -> Hash | nil
#@end

`--yjit-stats` コマンドラインオプションを指定して収集した統計情報を返します。

#@since 3.4
- **param** `key` -- Symbol を指定すると、そのキーに対応する値のみを返します。
  (Ruby 3.4 で追加された引数です)
- **return** -- `key` を指定しない場合は統計情報のハッシュを返します。`key` を指定した場合は
  対応する値を返します。統計収集が無効な場合は `nil` を返します。
- **raise** `TypeError` -- `key` に Symbol 以外(`nil` を除く)を指定した場合に発生します。
#@else
#@if("3.3" <= version and version < "3.4")
- **param** `context` -- true を指定すると、コンパイルコンテキストに関する統計も含めます。
#@end
- **return** -- 統計情報のハッシュを返します。統計収集が無効な場合は `nil` を返します。
#@end

統計情報の内容(キー)はバージョンによって増減します。詳細はビルド時の設定や
コマンドラインオプションに依存するため、本ページでは個々のキーの説明は省略します。

#@#noexample 実行環境に依存するため

- **SEE** [m:RubyVM::YJIT.stats_enabled?], [m:RubyVM::YJIT.reset_stats!]

#@since 3.3
### def stats_string -> String

[m:RubyVM::YJIT.runtime_stats] の内容を人が読める形式に整形した文字列を返します。
`--yjit-stats` が有効なとき以外は空文字列を返します。

#@#noexample 実行環境に依存するため

- **SEE** [m:RubyVM::YJIT.runtime_stats]
#@end

#@since 3.4
### def log -> [[Time, String]] | nil

`--yjit-log` で収集したコンパイルログを返します。配列の各要素は、
コンパイルした日時とコンパイル対象を表す文字列との組です。
ログ収集が無効な場合は `nil` を返します。

#@#noexample 実行環境に依存するため

- **SEE** [m:RubyVM::YJIT.log_enabled?], [m:RubyVM::YJIT.enable]
#@end

#@since 3.2
### def code_gc -> nil

コンパイル済みのコードを破棄してメモリを解放します。以降、必要に応じて再度コンパイルが行われます。
#@end
