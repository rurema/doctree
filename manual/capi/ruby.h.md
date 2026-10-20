### MACRO type* ALLOC(type)

type 型のメモリを割り当てる。

### MACRO type* ALLOC_N(type, n)

type 型のメモリを n 個割り当てる。

### MACRO type* ALLOCA_N(type, n)

type 型のメモリを n 個スタックフレームに割り当てる。
このメモリは関数が終わると自動的に解放される。

### MACRO int BUILTIN_TYPE(VALUE obj)

obj の構造体型 ID を返します。
[`SPECIAL_CONST_P(obj)`](f:SPECIAL_CONST_P) が真のオブジェクトに対して使うと落ちます。

### void Check_Type(VALUE val, int typeflag)

val の構造体型フラグが typeflag でなければ例外 TypeError を発生します。val は即値の VALUE であっても構いません。

### MACRO VALUE CHR2FIX(char x)

char 型の整数 x を Ruby の Fixnum に変換します。

### MACRO VALUE CLASS_OF(VALUE obj)

obj のクラスを返します。
この場合の「クラス」とは C レベルのクラス、つまり RBasic 構造体の klass メンバの値です。
また、構造体を持たない Fixnum などに対しても正常に働きます。

### MACRO void CLONESETUP(VALUE clone, VALUE obj)

OBJSETUP() の変種。
clone を、obj から clone で作ったオブジェクトとして初期化します。

#%until 4.1
### MACRO void Data_Get_Struct(VALUE obj, type, type *svar)

Ruby のオブジェクト obj から type 型へのポインタをとりだし svar に代入します。

```c title="使用例"
struct mytype {
    int i;
    char *s;
};

VALUE
my_i(VALUE self)
{
    struct mytype *m;
    Data_Get_Struct(self, struct mytype, m);
    return INT2NUM(m->i);
}
```

Ruby 4.1 で削除されました。[feature:21768]
#%end

#%until 4.1
### MACRO VALUE Data_Make_Struct(VALUE klass, type, RUBY_DATA_FUNC mark, RUBY_DATA_FUNC free, type *svar)

type 型の構造体をヒープに割り当ててそれへのポインタを
svar に代入し、クラス klass のインスタンスである
Ruby のオブジェクトを生成し、それを返します。mark
free はそれぞれマーク用・解放用の関数へのポインタです。
どちらも、必要ないときはかわりに 0 を渡します。

また RUBY_DATA_FUNC の定義は以下のようです。

```c
typedef void (*RUBY_DATA_FUNC)(void *st)
```

第一引数 st には svar の値が渡されます。

```c title="使用例"
struct mytype {
    int i;
    char *s;
};

VALUE
my_s_new(klass)
    VALUE klass;
{
    struct mytype *dummy;
    return Data_Make_Struct(MyClass, struct mytype,
                            mark_my, free_my, dummy);
}
```

Ruby 4.1 で削除されました。[feature:21768]
#%end

### MACRO void *DATA_PTR(VALUE dta)

実際は struct RData* 型である dta から、それがラップしているポインタを取り出します。

#%until 4.1
### MACRO VALUE Data_Wrap_Struct(VALUE klass, RUBY_DATA_FUNC mark, RUBY_DATA_FUNC free, void *sval)

C の構造体 sval をラップして klass クラスのインスタンスである Ruby オブジェクトを生成し、それを返します。
mark、free はそれぞれ sval のマーク用・解放用の関数へのポインタです。どちらも、必要ないときはかわりに 0 を渡します。

また RUBY_DATA_FUNC の定義は以下のようです。

```c
typedef void (*RUBY_DATA_FUNC)(void *st)
```

第一引数 st には sval が渡されます。

```c title="使用例"
struct mytype {
    int i;
    char *s;
};

VALUE
my_s_new(klass)
    VALUE klass;
{
    struct mytype *m = malloc(sizeof(struct mytype));
    m->i = 0;
    m->s = 0;
    return Data_Wrap_Struct(MyClass, 0, free_my, m);
}
```

Ruby 4.1 で削除されました。[feature:21768]
#%end

### MACRO void DUPSETUP(dup, obj)

OBJSETUP() の変種。
dup を、obj から dup で作ったオブジェクトとして初期化します。

### MACRO int FIX2INT(VALUE x)

Fixnum を int に変換します。
返り値が int の範囲から外れる場合は RangeError が発生します。

### MACRO long FIX2LONG(VALUE x)

Fixnum を long に変換します。
Fixnum は常に long に収まります。

### MACRO unsigned int FIX2UINT(VALUE x)

Fixnum を unsigned int に変換します。
返り値が unsigned int の範囲から外れる場合は RangeError が発生します。

### MACRO unsigned long FIX2ULONG(VALUE x)

Fixnum を unsigned long に変換します。
範囲のチェックは行われません。負の Fixnum を渡した場合は例外にはならず、
2 の補数表現をそのまま unsigned long として解釈した大きな値を返します。

### MACRO int FIXABLE(long f)

f が Fixnum の範囲に収まっているなら真。

- **SEE** [f:FIXNUM_MIN], [f:FIXNUM_MAX], [f:FIXNUM_P],
     [f:POSFIXABLE], [f:NEGFIXABLE]

### MACRO long FIXNUM_MAX

Fixnum にできる整数の上限値。

- **SEE** [f:FIXNUM_MIN], [f:FIXNUM_P], [f:FIXABLE],
     [f:POSFIXABLE], [f:NEGFIXABLE]

### MACRO long FIXNUM_MIN

Fixnum にできる整数の下限値。

- **SEE** [f:FIXNUM_MAX], [f:FIXNUM_P], [f:FIXABLE],
     [f:POSFIXABLE], [f:NEGFIXABLE]

### MACRO int FIXNUM_P(VALUE obj)

obj が Fixnum のインスタンスのとき真。

- **SEE** [f:FIXNUM_MIN], [f:FIXNUM_MAX], [f:FIXABLE],
     [f:POSFIXABLE], [f:NEGFIXABLE]

### MACRO int FL_ABLE(VALUE x)

x が即値の VALUE でなければ真。

### MACRO void FL_REVERSE(VALUE x, int f)

x のフラグ f を反転する。

### MACRO void FL_SET(VALUE x, int f)

x に対してフラグ f をセットする。

### MACRO int FL_TEST(VALUE x, int f)

x のフラグ f が立っていたら真。

### MACRO void FL_UNSET(VALUE x, int f)

x のフラグ f をクリアする。

#%since 4.1
### MACRO int HAVE_RB_LEN_T

`rb_len_t` と `rb_ulen_t`、および [f:LEN2NUM] や [f:NUM2LEN]、[f:PRIdLEN] などのマクロが使えることを示すマクロです。
値は `1` です。
古い版もサポートする拡張ライブラリは、これが未定義のときに `typedef long rb_len_t;` やマクロを自前で定義して代用できます。

- **SEE** [f:rb_len_t], [f:rb_ulen_t]
#%end

### MACRO VALUE ID2SYM(ID id)

id を Symbol に変換します。

### MACRO int IMMEDIATE_P(VALUE obj)

obj が即値でかつ真な値であるとき真。
すなわち現在の実装では
obj が Symbol か Fixnum のインスタンスであるか、 Qtrue のとき真。

### MACRO VALUE INT2FIX(int i)

Fixnum におさまることが自明な整数を Fixnum に変換します。
なお、Fixnum の幅は long の幅 - 1 です。

### MACRO VALUE INT2NUM(int i)

任意の整数を [c:Integer] に変換します。
INT2FIX と異なり、Fixnum におさまらない整数も扱えます。

```c title="例"
VALUE num = INT2NUM(42); //(Cの整数値42をRubyのオブジェクトに変換)
```

### MACRO int ISALNUM(char c)

### MACRO int ISALPHA(char c)

### MACRO int ISASCII(char c)

### MACRO int ISDIGIT(char c)

cが'0'から'9'のとき真。それ以外は偽。

### MACRO int ISLOWER(char c)

### MACRO int ISPRINT(char c)

### MACRO int ISSPACE(char c)

### MACRO int ISUPPER(char c)

### MACRO int ISXDIGIT(char c)

cが’0’から’9’、’a’から’f’、’A’から’F’のとき真。それ以外は偽。

#%since 4.1
### MACRO VALUE LEN2NUM(rb_len_t n)

`rb_len_t` の値 `n` を Fixnum か Bignum に変換します。
`rb_len_t` が `long` の環境では [f:LONG2NUM]、64 ビットの mswin では [f:LL2NUM] と同じです。

- **SEE** [f:rb_len_t], [f:NUM2LEN], [f:ULEN2NUM]
#%end

### MACRO VALUE LL2NUM(long long v)

```c title="例"
long long n = 42;
VALUE num = LL2NUM(n); // (long longの整数42をRubyのオブジェクトに変換)
```

### MACRO VALUE LONG2FIX(long i)

INT2FIX と同じです。

### MACRO VALUE LONG2NUM(long v)

### MACRO int MEMCMP(p1, p2, type, n)

type 型のメモリ領域 p1 と p2 の先頭 n 個を比較する。
p1 が p2 の最初の n 個より小さい、等しい、大きいとき、それぞれ正、0、負の値を返す。

### MACRO void MEMCPY(p1, p2, type, n)

type 型のメモリ領域 p2 のうち先頭の n 個を p1 にコピーする。

### MACRO void MEMMOVE(p1, p2, type, n)

type 型のメモリ領域 p2 のうち先頭の n 個を p1 に移動する。

### MACRO void MEMZERO(p, type, n)

type 型のメモリ領域 p をゼロクリアする。 n は要素数。

### MACRO int NEGFIXABLE(long f)

f が Fixnum の下限値以上ならば真。

- **SEE** [f:FIXNUM_MIN], [f:FIXNUM_MAX], [f:FIXNUM_P],
     [f:FIXABLE], [f:POSFIXABLE]

#%until 3.4
### MACRO void NEWOBJ(obj, int typeflag)
#%end

### MACRO int NIL_P(VALUE obj)

obj が Qnil のとき真。

### MACRO char NUM2CHR(VALUE x)

### MACRO double NUM2DBL(VALUE x)

### MACRO int NUM2INT(VALUE x)

x を int 型の整数に変換します。

x が [c:Integer]、[c:Float] オブジェクトのいずれでもない場合は x.to_int による暗黙の型変換を試みます。

- **raise** `TypeError` -- x が nil の場合か、暗黙の型変換が成功しなかった場合に発生します。

- **raise** `RangeError` -- x が int 型で表現できる値の範囲外であった場合に発生します。

#%since 4.1
### MACRO rb_len_t NUM2LEN(VALUE x)

`x` を `rb_len_t` に変換します。
`rb_len_t` が `long` の環境では [f:NUM2LONG]、64 ビットの mswin では `NUM2LL` と同じです。
`rb_len_t` の範囲に収まらないときは `RangeError` が発生します。

- **SEE** [f:rb_len_t], [f:LEN2NUM]
#%end

### MACRO long NUM2LONG(VALUE x)

x を long 型の整数に変換します。

x が [c:Integer]、[c:Float] オブジェクトのいずれでもない場合は x.to_int による暗黙の型変換を試みます。

- **raise** `TypeError` -- x が nil の場合か、暗黙の型変換が成功しなかった場合に発生します。

- **raise** `RangeError` -- x が long 型で表現できる値の範囲外であった場合に発生します。

### MACRO unsigned int NUM2UINT(VALUE x)

x を unsigned int 型の整数に変換します。

x が [c:Integer]、[c:Float] オブジェクトのいずれでもない場合は x.to_int による暗黙の型変換を試みます。

- **raise** `TypeError` -- x が nil の場合か、暗黙の型変換が成功しなかった場合に発生します。

- **raise** `RangeError` -- x が unsigned int 型で表現できる値の範囲外であった場合に発生します。

### MACRO unsigned long NUM2ULONG(VALUE x)

x を unsigned long 型の整数に変換します。

x が [c:Integer]、[c:Float] オブジェクトのいずれでもない場合は x.to_int による暗黙の型変換を試みます。

- **raise** `TypeError` -- x が nil の場合か、暗黙の型変換が成功しなかった場合に発生します。

- **raise** `RangeError` -- x が unsigned long 型で表現できる値の範囲外であった場合に発生します。

### MACRO short NUM2SHORT(VALUE x)

x を short 型の整数に変換します。

x が [c:Integer]、[c:Float] オブジェクトのいずれでもない場合は x.to_int による暗黙の型変換を試みます。

- **raise** `TypeError` -- x が nil の場合か、暗黙の型変換が成功しなかった場合に発生します。

- **raise** `RangeError` -- x が short 型で表現できる値の範囲外であった場合に発生します。

### MACRO unsigned short NUM2USHORT(VALUE x)

x を unsigned short 型の整数に変換します。

x が [c:Integer]、[c:Float] オブジェクトのいずれでもない場合は x.to_int による暗黙の型変換を試みます。

- **raise** `TypeError` -- x が nil の場合か、暗黙の型変換が成功しなかった場合に発生します。

- **raise** `RangeError` -- x が unsigned short 型で表現できる値の範囲外であった場合に発生します。

### MACRO void OBJ_FREEZE(VALUE x)

### MACRO int OBJ_FROZEN(VALUE x)

#%until 4.1
### MACRO void OBJ_INFECT(VALUE dest, VALUE src)

src に汚染マークが付いていたら dest も汚染する。

Ruby 4.1 で削除されました。[feature:21768]
#%end

#%until 4.1
### MACRO void OBJ_TAINT(VALUE x)

x に汚染マークを付ける。

Ruby 4.1 で削除されました。[feature:21768]
#%end

#%until 4.1
### MACRO int OBJ_TAINTED(VALUE x)

x に汚染マークが付いていたら真。

Ruby 4.1 で削除されました。[feature:21768]
#%end

### MACRO void OBJSETUP(obj, VALUE klass, int typeflag)

obj をクラス klass とフラグ typeflag で初期化する。

### MACRO int POSFIXABLE(long f)

f が Fixnum の上限値以下ならば真。

- **SEE** [f:FIXNUM_MIN], [f:FIXNUM_MAX], [f:FIXNUM_P],
     [f:FIXABLE], [f:NEGFIXABLE]

#%since 4.1
### MACRO PRIdLEN

`rb_len_t` の値を `printf` 系の関数で出力するための書式指定子です。
`PRIdLEN`、`PRIiLEN`、`PRIoLEN`、`PRIuLEN`、`PRIxLEN`、`PRIXLEN` があり、それぞれ `d`、`i`、`o`、`u`、`x`、`X` 変換に対応します。
`"%" PRIdLEN` のように書式文字列に連結して使います。
`rb_len_t` の幅に合わせて、`long` の環境では `"l"`、64 ビットの mswin では 64 ビット整数用の接頭辞が付きます。

- **SEE** [f:rb_len_t]
#%end

### MACRO struct RArray *RARRAY(VALUE obj)

obj を struct RArray* にキャストする。
本当は obj が struct RArray* でないとしてもキャストしてしまう。

### VALUE rb_fix_new(long v)

### VALUE rb_int_new(long v)

#%since 4.1
### int rb_len2int(rb_len_t n)

`rb_len_t` の値 `n` を `int` に変換します。
`int` に収まらないときは `RangeError` が発生します。
[f:RSTRING_LENINT] などが使います。

- **SEE** [f:rb_len_t], [f:rb_len2long]

### long rb_len2long(rb_len_t n)

`rb_len_t` の値 `n` を `long` に変換します。
`long` に収まらないときは [f:rb_out_of_long] によって `RangeError` が発生します。
`rb_len_t` が `long` の環境では常に成功します。
64 ビットの mswin で、長さを `long` で保持している拡張ライブラリが使います。
[feature:22400]

- **SEE** [f:rb_len_t], [f:rb_len2int]

### MACRO rb_len_t RB_LEN_MAX

`rb_len_t` が取りうる最大値です。
`long` の環境では `LONG_MAX`、64 ビットの mswin では `INT64_MAX` です。

- **SEE** [f:rb_len_t], [f:RB_LEN_MIN], [f:RB_ULEN_MAX]

### MACRO rb_len_t RB_LEN_MIN

`rb_len_t` が取りうる最小値です。
`long` の環境では `LONG_MIN`、64 ビットの mswin では `INT64_MIN` です。

- **SEE** [f:rb_len_t], [f:RB_LEN_MAX]

### typedef long rb_len_t

`String` や `Array`、`MatchData` の長さや添字を表す符号付き整数型です。
`long` ですが、64 ビットの mswin (Visual C++ でビルドした 64 ビット Windows 版) では `long` が 32 ビットのままポインタが 64 ビットなので、`int64_t` として定義されます。
32 ビットの mswin と MinGW 版では `long` です。
[f:RSTRING_LEN] や `rb_range_beg_len` など、長さを受け渡す C API はこの型を使います。
拡張ライブラリはこれらの長さを `long` ではなく `rb_len_t` で保持してください。
64 ビットの mswin では、長さを `long` で保持すると 2GiB で切り詰められ、`rb_range_beg_len` などの出力引数に `long *` を渡すとコンパイルエラーになります。
`long` が必要なときは [f:rb_len2long] で変換してください。
また 64 ビットの mswin では ABI も変わるため、拡張ライブラリの再ビルドが必要です。
古い版もサポートする拡張ライブラリは、[f:HAVE_RB_LEN_T] が未定義のときに `typedef long rb_len_t;` などで代用できます。
extconf.rb からは `RbConfig::SIZEOF["rb_len_t"]` で大きさを取得できます。
なお 64 ビットの mswin でも Fixnum の範囲 ([f:FIXNUM_MAX]) は 31 ビットのままなので、[f:LEN2NUM] の結果は `2**30` 以上で Bignum になります。
[feature:22400]

- **SEE** [f:rb_ulen_t], [f:SIZEOF_RB_LEN_T], [f:HAVE_RB_LEN_T], [f:LEN2NUM], [f:NUM2LEN]

### void rb_out_of_long(SIGNED_VALUE num)

`num` が `long` の範囲に収まらないことを示す `RangeError` を発生させます。

- **SEE** [f:rb_len2long]
#%end

### VALUE rb_uint_new(unsigned int v)

#%since 4.1
### MACRO rb_ulen_t RB_ULEN_MAX

`rb_ulen_t` が取りうる最大値です。
`unsigned long` の環境では `ULONG_MAX`、64 ビットの mswin では `UINT64_MAX` です。

- **SEE** [f:rb_ulen_t], [f:RB_LEN_MAX]

### typedef unsigned long rb_ulen_t

`rb_len_t` と同じ幅の符号なし整数型です。
`unsigned long` ですが、64 ビットの mswin では `uint64_t` です。

- **SEE** [f:rb_len_t], [f:ULEN2NUM]
#%end

### MACRO struct RBasic *RBASIC(VALUE obj)

### MACRO struct RBignum *RBIGNUM(VALUE obj)

### MACRO struct RClass *RCLASS(VALUE obj)

### MACRO struct RData *RDATA(VALUE obj)

### MACRO type* REALLOC_N(var, type, n)

type 型のメモリ領域 var のサイズを n 個に変更する。

### MACRO struct RFile *RFILE(VALUE obj)

### MACRO struct RFloat *RFLOAT(VALUE obj)

### MACRO struct RHash *RHASH(VALUE obj)

### MACRO st_table *RHASH_TBL(VALUE h)

`h` の内容を持つ `st_table` を返します。
`h` の実装が `st_table` であるとは限らないため、必要なときに作成されます。

#%since 4.1
Ruby 4.1 から非推奨です。[feature:22232]
#%end

### MACRO struct RClass *RMODULE(VALUE obj)

### MACRO struct RObject *ROBJECT(VALUE obj)

### MACRO struct RRegexp *RREGEXP(VALUE obj)

### MACRO struct RString *RSTRING(VALUE obj)

引数 obj を RString 構造体にキャストして返します。

- **param** `obj` -- Rubyの文字列オブジェクトを指定します。

### MACRO long RSTRING_LEN(RString str)

引数 str の表す文字列のバイト数を返します。

- **param** `str` -- RString 構造体を指定します。

- **SEE** [f:RSTRING_LENINT]

### MACRO int RSTRING_LENINT(RString str)

引数 str の表す文字列のバイト数をint型にキャストして返します。

- **param** `str` -- RString 構造体を指定します。

- **SEE** [f:RSTRING_LEN]

### MACRO char* RSTRING_PTR(RString str)

引数 str の表す文字列のポインタの先頭を返します。

- **param** `str` -- RString 構造体を指定します。

- **SEE** [f:RSTRING_END]

### MACRO char* RSTRING_END(RString str)

引数 str の表す文字列のポインタの末尾を返します。

- **param** `str` -- RString 構造体を指定します。

- **SEE** [f:RSTRING_PTR]

### MACRO struct RStruct *RSTRUCT(VALUE obj)

### MACRO int RTEST(VALUE obj)

obj が Qfalse でも Qnil でもないとき真。

### MACRO RUBY_DATA_FUNC(func)

任意の関数へのポインタ func を struct RData の dmark/dfree の値として適する型に強制キャストします。

### MACRO RUBY_METHOD_FUNC(func)

任意の関数へのポインタ func を Ruby のメソッドの実体として適する型に強制キャストします。

#%since 3.3
### MACRO RUBY_TYPED_EMBEDDABLE

`rb_data_type_t` の `flags` に指定するフラグです。
Ruby 3.3 で追加され、4.1 で公開 API として文書化されました。
[feature:21853]
Ruby は C の構造体を `malloc` で別に確保せず、オブジェクトのスロットに直接埋め込むことがあります。
ポインタをたどる回数や `malloc` の負荷が減り、場合によってはメモリ使用量も減ります。
ただし保証ではなく、構造体がスロットに収まらないときなどは埋め込まれません。

埋め込み可能にするには次の制限を守る必要があります。

- 構造体へのポインタや構造体の内部を指すポインタを保持してはいけません。GC のコンパクションで無効になります。オブジェクトがスタック上にある間だけ、渡して使えます。C 側で生成したオブジェクトは `RB_GC_GUARD` で保護してください (Ruby から引数として渡されたオブジェクトなら不要です)。
- [f:DATA_PTR]、`RTYPEDDATA_DATA`、`TypedData_Wrap_Struct` は使えません (`TypedData_Wrap_Struct` は `TypeError` になります)。`RTYPEDDATA_GET_DATA` か `TypedData_Get_Struct` を使います。
- `dfree` で構造体そのものを free してはいけません。`RUBY_DEFAULT_FREE` は指定できます。
- `RUBY_TYPED_FREE_IMMEDIATELY` も指定する必要があります (指定がないと `TypeError` になります)。

構造体の大きさが可変のときは、`TypedData_Make_Struct` の代わりに `rb_data_typed_object_zalloc` を使えます。
#%end

### MACRO SafeStringValue(v)

[f:StringValue] と同じく、val が String でなければ to_str メソッドを使って String に変換します。同時に rb_check_safe_str() によるチェックも行います。

#%since 4.1
### MACRO int SIZEOF_RB_LEN_T

`rb_len_t` の大きさをバイト単位で表すマクロです。
`long` の環境では `SIZEOF_LONG` と同じで、64 ビットの mswin では `8` です。
`typedef` はプリプロセッサから見えないため、`#if SIZEOF_RB_LEN_T > SIZEOF_LONG` のように、`rb_len_t` が `long` より広いかどうかの判定に使えます。

- **SEE** [f:rb_len_t]
#%end

### MACRO int SPECIAL_CONST_P(VALUE obj)

obj が実体の構造体を持たないとき真。
現時点で真になるのは Qnil, Qtrue, Qfalse と、
Fixnum, Symbol のインスタンス。

### MACRO void StringValue(VALUE val)

val が String でなければ to_str メソッドを使って String に変換します。

このマクロに渡した VALUE は ruby の GC から確実に保護されます。

### MACRO char *StringValuePtr(VALUE val)

val が String でなければ to_str メソッドを使って String に変換し、その実体のポインタを返します。

このマクロに渡した VALUE は ruby の GC から確実に保護されます。

### MACRO int SYM2ID(VALUE symbol)

Symbol symbol を数値に変換します。
Ruby 1.4 では、[`FIX2INT(symbol)`](f:FIX2INT)と同じです。

### MACRO int SYMBOL_P(VALUE obj)

obj が Symbol のインスタンスのとき真。

### MACRO int TYPE(VALUE obj)

obj の構造体型 ID を返します。

### MACRO VALUE UINT2NUM(unsigned int i)

任意の整数を Fixnum か Bignum に変換します。

#%since 4.1
### MACRO VALUE ULEN2NUM(rb_ulen_t n)

`rb_ulen_t` の値 `n` を Fixnum か Bignum に変換します。
`rb_ulen_t` が `unsigned long` の環境では [f:ULONG2NUM]、64 ビットの mswin では [f:ULL2NUM] と同じです。

- **SEE** [f:rb_ulen_t], [f:LEN2NUM]
#%end

### MACRO VALUE ULL2NUM(unsigned long long n)

### MACRO VALUE ULONG2NUM(unsigned long n)
