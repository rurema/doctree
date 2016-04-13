--- void rb_raise(VALUE err, const char *fmt, ...)

クラス err の例外を発生します。fmt とその後の引数は、
printf と同じ形式でエラーメッセージを表します。

--- void rb_fatal(const char *fmt, ...)

あらゆる例外処理をスキップして即座にインタプリタが終了します。
fmt とその後の引数は printf と同じ形式でエラーメッセージを表現します。

--- void rb_compile_error_with_enc(const char *file, int line, void *enc, const char *fmt, ...)

この関数は 2.3.0 以降で deprecated です。公開関数ですが内部利用のみを想
定しています。外部のライブラリで使用すべきではありません。

--- void rb_compile_error(const char *file, int line, const char *fmt, ...)

この関数は 2.3.0 以降で deprecated です。公開関数ですが内部利用のみを想
定しています。外部のライブラリで使用すべきではありません。

--- void rb_compile_bug(const char *file, int line, const char *fmt, ...)

この関数は 2.3.0 以降で deprecated です。公開関数ですが内部利用のみを想
定しています。外部のライブラリで使用すべきではありません。
