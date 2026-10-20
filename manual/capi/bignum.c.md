### int rb_integer_pack(VALUE val, void *words, size_t numwords, size_t wordsize, size_t nails, int flags)

整数 `val` を、`words` と `numwords` で指定したバッファに書き出します。
書き出す形式は `wordsize`、`nails`、`flags` で指定します。
`flags` に `INTEGER_PACK_2COMP` を指定すると 2 の補数表現で書き出します。
指定しないと `val` の絶対値を書き出し、符号は返り値で返します。
あふれたときは、バッファには下位のワードが書き出されます。

- **param** `val` -- 書き出す整数です。`to_int` メソッドを持つオブジェクトでも構いません。
- **param** `words` -- 書き出し先のバッファです。
- **param** `numwords` -- `words` のワード数です。
- **param** `wordsize` -- 1 ワードあたりのバイト数です。
- **param** `nails` -- 1 ワードあたりの詰め物のビット数です。各ワードの上位 `nails` ビットは 0 で埋められます。
- **param** `flags` -- `INTEGER_PACK_` で始まる定数の論理和です。
- **return** -- 符号とあふれの状態です。
- **raise** `TypeError` -- `val` が `to_int` メソッドを持たないとき。

`flags` に指定できる主な定数は次のとおりです。

- `INTEGER_PACK_MSWORD_FIRST` -- 最上位のワードを先頭に書き出します。
- `INTEGER_PACK_LSWORD_FIRST` -- 最下位のワードを先頭に書き出します。
- `INTEGER_PACK_MSBYTE_FIRST` -- ワード内の最上位のバイトを先頭に書き出します。
- `INTEGER_PACK_LSBYTE_FIRST` -- ワード内の最下位のバイトを先頭に書き出します。
- `INTEGER_PACK_NATIVE_BYTE_ORDER` -- 実行環境のバイト順に合わせて、`INTEGER_PACK_MSBYTE_FIRST` か `INTEGER_PACK_LSBYTE_FIRST` のどちらかになります。
- `INTEGER_PACK_2COMP` -- 2 の補数表現を使います。
- `INTEGER_PACK_LITTLE_ENDIAN` -- `INTEGER_PACK_LSWORD_FIRST|INTEGER_PACK_LSBYTE_FIRST` の省略形です。
- `INTEGER_PACK_BIG_ENDIAN` -- `INTEGER_PACK_MSWORD_FIRST|INTEGER_PACK_MSBYTE_FIRST` の省略形です。
- `INTEGER_PACK_FORCE_GENERIC_IMPLEMENTATION` -- 汎用の実装を使います。テストとデバッグ用です。

`INTEGER_PACK_2COMP` を指定しないときの返り値は次のとおりです。
ここで `N` は `numwords*(wordsize*CHAR_BIT-nails)` です。

- `-2` -- 負の数であふれました。`val <= -2**N` です。
- `-1` -- 負の数で、あふれていません。`-2**N < val < 0` です。
- `0` -- `val` は 0 です。
- `1` -- 正の数で、あふれていません。`0 < val < 2**N` です。
- `2` -- 正の数であふれました。`2**N <= val` です。

`INTEGER_PACK_2COMP` を指定したときは、`-2` が `val < -2**N`、`-1` が `-2**N <= val < 0` になり、ほかは同じです。
`-2**N` は 2 の補数表現では表せますが絶対値では表せないため、`INTEGER_PACK_2COMP` を指定したときは `-1` を、指定しないときは `-2` を返します。
