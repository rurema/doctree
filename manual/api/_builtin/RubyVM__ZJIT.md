---
library: _builtin
since: "4.0"
---
# module RubyVM::ZJIT

ZJIT の制御・情報取得のためのモジュールです。

ZJIT は CRuby に組み込まれたメソッド単位の JIT (Just-in-time compiler) コンパイラで、
Ruby 4.0 で実験的機能として導入されました。Ruby 4.0 の時点ではインタプリタより速いものの
[c:RubyVM::YJIT] ほど速くはなく、本番環境での利用は推奨されていません。

有効化するには以下のいずれかの方法を使います。

- コマンドラインオプション `--zjit`
- [m:RubyVM::ZJIT.enable] による実行時の有効化

YJIT と ZJIT を同時に有効にすることはできません。

このモジュールは、ZJIT が対応していないプラットフォームや、ZJIT を含めずにビルドされた Ruby
(ビルドには Rust 1.85.0 以降が必要です)では定義されません。
このモジュールの内容は処理系の実装に強く依存し、標準ライブラリと比べて API が安定していない
可能性があります。

- **SEE** [c:RubyVM::YJIT]

## Singleton Methods

### def RubyVM::ZJIT.enabled? -> bool

ZJIT が有効かどうかを返します。

```ruby
RubyVM::ZJIT.enabled? # => false
```

JIT の有効・無効はコマンドラインオプションなど実行環境に依存するため、実行結果は環境によって異なります。

- **SEE** [m:RubyVM::ZJIT.enable]

### def RubyVM::ZJIT.enable -> bool

実行時に ZJIT を有効化します。

- **return** -- 有効化したときは `true` を返します。すでに ZJIT が有効な場合は `false` を返します。
  YJIT が有効になっている場合は "Only one JIT can be enabled at the same time." という警告を出力して `false` を返します。

```ruby
RubyVM::ZJIT.enable # => true
```

JIT の有効・無効はビルドオプションや実行環境に依存するため、実行結果は環境によって異なります。

- **SEE** [m:RubyVM::ZJIT.enabled?], [m:RubyVM::YJIT.enable]

### def RubyVM::ZJIT.stats_enabled? -> bool

統計収集(`--zjit-stats`)が有効かどうかを返します。

- **SEE** [m:RubyVM::ZJIT.stats]

### def RubyVM::ZJIT.stats(target_key = nil) -> Hash | object | nil

ZJIT の統計情報を返します。

`--zjit-stats` で統計収集を有効にしている場合、統計情報のカウンタ名をキーとするハッシュを返します。
`target_key` を指定した場合は、そのキーに対応する値だけを返します(該当するキーが無ければ `nil`)。
統計収集が有効でない場合は `nil` を返します。

- **param** `target_key` -- 取得したい統計情報のキーをシンボルで指定します。

```ruby
# ruby --zjit-stats で実行した場合
RubyVM::ZJIT.stats.keys.first(3)  # => [:compiled_iseq_count, :failed_iseq_count, :compile_time_ns]
RubyVM::ZJIT.stats(:compiled_iseq_count) # => 12
```

統計情報のキーの構成は処理系のバージョンによって変わります。

- **SEE** [m:RubyVM::ZJIT.stats_string], [m:RubyVM::ZJIT.reset_stats!]

### def RubyVM::ZJIT.stats_string -> String | nil

ZJIT の統計情報の要約を、`--zjit-stats` で終了時に表示されるのと同じ形式の文字列で返します。

統計収集が有効でない場合は `nil` を返します。

#%#noexample 実行環境に依存するため

- **SEE** [m:RubyVM::ZJIT.stats]

### def RubyVM::ZJIT.reset_stats! -> nil

`--zjit-stats` で収集した統計情報を破棄します。

ZJIT が有効なときにだけ呼び出してください。

- **SEE** [m:RubyVM::ZJIT.stats]

### def RubyVM::ZJIT.trace_exit_locations_enabled? -> bool

サイドイグジット(exit)の発生位置の収集(`--zjit-trace-exits`)が有効かどうかを返します。

#%until 4.1
### def RubyVM::ZJIT.exit_locations -> Hash | nil

`--zjit-trace-exits` を指定して収集した、サイドイグジットが発生した位置の情報を
Stackprof で読める形式のハッシュにして返します。

`--zjit-trace-exits` が有効になっていない場合は `nil` を返します。

#%#noexample 実行環境に依存するため

- **SEE** [m:RubyVM::ZJIT.dump_exit_locations]

### def RubyVM::ZJIT.dump_exit_locations(filename) -> Integer

`--zjit-trace-exits` を指定して収集した、サイドイグジットが発生した位置の情報を
Marshal 形式で `filename` にダンプします。ダンプしたファイルは Stackprof で読み込んで解析できます。

- **param** `filename` -- ダンプ先のファイル名。
- **return** -- ファイルに書き込んだバイト数を返します。
- **raise** `ArgumentError` -- `--zjit-trace-exits` が有効になっていない場合に発生します。

#%#noexample 実行環境に依存するため

- **SEE** [m:RubyVM::ZJIT.exit_locations]
#%end

#%since 4.1
### def RubyVM::ZJIT.induce_compile_failure! -> nil

呼び出し箇所を含むコードのコンパイルを失敗させるよう ZJIT に指示します。

ZJIT に認識させるには、呼び出しを `::RubyVM::ZJIT.induce_compile_failure!` とそのまま書く必要があります。
他の書き方はコンパイル時に検出できません。

このメソッド自体は、ZJIT が呼び出しを認識したかどうかに関わらず、実行しても何もしません。
ZJIT の開発・テスト用のメソッドです。

### def RubyVM::ZJIT.induce_side_exit! -> nil

呼び出し箇所でコンパイル済みコードからサイドイグジットするよう ZJIT に指示します。

ZJIT に認識させるには、呼び出しを `::RubyVM::ZJIT.induce_side_exit!` とそのまま書く必要があります。
他の書き方はコンパイル時に検出できません。

このメソッド自体は、ZJIT が呼び出しを認識したかどうかに関わらず、実行しても何もしません。
ZJIT の開発・テスト用のメソッドです。

### def RubyVM::ZJIT.induce_breakpoint! -> nil

呼び出し箇所にブレークポイント命令を出力するよう ZJIT に指示します。

ZJIT に認識させるには、呼び出しを `::RubyVM::ZJIT.induce_breakpoint!` とそのまま書く必要があります。
他の書き方はコンパイル時に検出できません。

ZJIT の開発・テスト用のメソッドです。
#%end
