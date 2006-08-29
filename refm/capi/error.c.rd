
: void rb_raise(VALUE err, const char *fmt, ...)
    クラス ((|err|)) の例外を発生します。((|fmt|)) とその後の引数は、
    (({printf})) と同じ形式でエラーメッセージを表します。

: void rb_fatal(const char *fmt, ...)
    あらゆる例外処理をスキップして即座にインタプリタが終了します。
    ((|fmt|)) とその後の引数は (({printf})) と同じ形式でエラー
    メッセージを表現します。

: rb_exit(int status)
    ステータス ((|status|)) でインタプリタを終了させます。
