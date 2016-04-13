
#@since 2.3.0
--- void rb_timespec_now(struct timespec *ts)

現在時刻を取得してその結果を引数 ts で指定した timespec 構造体に格納します。

@param ts timespec 構造体のポインタ

--- VALUE rb_time_timespec_new(const struct timespec *ts, int offset)

引数 ts、offset を元に [[c:Time]] オブジェクトを作成して返します。

@param ts timespec 構造体のポインタ

@param offset 協定世界時との時差(秒)。
              -86400 < offset < 86400 の場合は指定した時差に、INT_MAX
              を指定した場合は地方時、INT_MAX-1 を指定した場合は UTC に
              なります。

@raise ArgumentError offset に上述の範囲以外の値を指定した場合に発生し
                     ます。

#@# c.f. https://bugs.ruby-lang.org/issues/11558
#@end
