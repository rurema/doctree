### VALUE rb_sprintf(const char *fmt, ...)

`fmt` に従って整形した文字列を、新しい [c:String] として作成します。
Ruby 独自の `sprintf(3)` で、ロケールに依存しません。

書式は `%[flags][width][.precision][length]conversion` の形で、次のものが使えます。

- フラグ -- 空白、`#`、`+`、`-`、`0`
- 幅 -- 0 以上の 10 進整数と `*`
- 精度 -- 0 以上の 10 進整数と `*`
- 長さ修飾子 -- `L`、`h`、`t`、`z`、`l`、`ll`、`q`(`_WIN32` では `I` も使えます)
- 変換指定 -- `A`、`D`、`E`、`G`、`O`、`U`、`X`、`a`、`c`、`d`、`e`、`f`、`g`、`i`、`n`、`o`、`p`、`s`、`u`、`x`、`%`

さらに、任意の Ruby のオブジェクトを文字列にできる `PRIsVALUE` マクロが使えます。
`"%"PRIsVALUE` は `to_s` の結果を出力し、`+` フラグを付けた `"%+"PRIsVALUE` は `inspect` の結果を出力します。
`"%i"` と衝突するので、整数には `"%d"` を使ってください。

```c title="使用例"
rb_sprintf("|%"PRIsVALUE"|", Qtrue); // => "|true|"
rb_sprintf("%+"PRIsVALUE, rb_stdin);  // => "#<IO:<STDIN>>"
```

- **param** `fmt` -- `printf` のような書式文字列です。
- **param** `...` -- 書式に埋め込む値です。
- **return** -- 整形した結果の新しい [c:String] です。

### VALUE rb_str_catf(VALUE dst, const char *fmt, ...)

[f:rb_sprintf] と同じ書式で整形した結果を、文字列 `dst` の末尾に追加します。
新しい文字列を作る代わりに、指定した文字列に出力します。
`rb_str_append(dst, rb_sprintf(fmt, ...))` と同じ結果になります。

- **param** `dst` -- 追加先の [c:String] です。
- **param** `fmt` -- `printf` のような書式文字列です。
- **param** `...` -- 書式に埋め込む値です。
- **return** -- 引数の `dst` です。
- **raise** `TypeError` -- `dst` が [c:String] でないとき。

### VALUE rb_str_vcatf(VALUE dst, const char *fmt, va_list ap)

[f:rb_str_catf] と同じですが、値を `va_list` で渡します。
[f:rb_vsprintf] の結果を、新しい文字列を作る代わりに、指定した文字列の末尾に追加します。
`rb_str_append(dst, rb_vsprintf(fmt, ap))` と同じ結果になります。

- **param** `dst` -- 追加先の [c:String] です。
- **param** `fmt` -- `printf` のような書式文字列です。
- **param** `ap` -- 書式に埋め込む値です。
- **return** -- 引数の `dst` です。
- **raise** `TypeError` -- `dst` が [c:String] でないとき。

### VALUE rb_vsprintf(const char *fmt, va_list ap)

[f:rb_sprintf] と同じですが、値を `va_list` で渡します。
`fmt` に従って整形した文字列を、新しい [c:String] として作成します。

- **param** `fmt` -- `printf` のような書式文字列です。
- **param** `ap` -- 書式に埋め込む値です。
- **return** -- 整形した結果の新しい [c:String] です。
