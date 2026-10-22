### void rb_raise(VALUE err, const char *fmt, ...)

クラス err の例外を発生します。fmt とその後の引数は、
printf と同じ形式でエラーメッセージを表します。

### void rb_fatal(const char *fmt, ...)

あらゆる例外処理をスキップして即座にインタプリタが終了します。
fmt とその後の引数は printf と同じ形式でエラーメッセージを表現します。

### void rb_bug(const char *fmt, ...)

インタプリタをただちに異常終了させます。
インタプリタ自身のバグが原因の状況で呼ばれることを想定した関数で、例外処理も ensure の実行もしません。
可能であれば、内部状態やスタックトレース、レジスタの値をデバッグ用に表示します。

拡張ライブラリからの使用は想定されていません。
後方互換性のために公開されているだけなので、使わずに自分のコードを直してください。
この関数は戻りません。

書式 `fmt` は [f:rb_sprintf] と互換です。
`"%"PRIsVALUE` を使うと、VALUE を `to_s` の結果で(`+` フラグがあれば `inspect` の結果で)出力できます。
`"%i"` と衝突するので、整数には `"%d"` を使ってください。

- **param** `fmt` -- [f:rb_sprintf] と互換の書式文字列です。
- **param** `...` -- 書式に埋め込む値です。

### void rb_warn(const char *fmt, ...)

`fmt` に従って整形した警告メッセージを出力します。
`$VERBOSE` が `nil` のときは何もしません。
`$VERBOSE` が `false` でも出力される点が [f:rb_warning] と異なります。

- **param** `fmt` -- [f:rb_sprintf] と互換の書式文字列です。
- **param** `...` -- 書式に埋め込む値です。

### void rb_warning(const char *fmt, ...)

`fmt` に従って整形した警告メッセージを出力します。
`$VERBOSE` が真のときだけ出力し、それ以外では何もしません。

メッセージは [m:Warning.warn] に渡されます。
標準では、[m:Warning.warn] が標準エラー出力へ書き出します。

- **param** `fmt` -- [f:rb_sprintf] と互換の書式文字列です。
- **param** `...` -- 書式に埋め込む値です。
