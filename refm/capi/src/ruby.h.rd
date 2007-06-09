--- type* ALLOC(type)

type 型のメモリを割り当てる。

--- type* ALLOC_N(type, n)

type 型のメモリを n 個割り当てる。

--- type* ALLOCA_N(type, n)

type 型のメモリを n 個スタックフレームに割り当てる。
このメモリは関数が終わると自動的に解放される。

--- int BUILTIN_TYPE(VALUE obj)

obj の構造体型 ID を返します。
[[f:SPECIAL_CONST_P(obj)]] が真のオブジェクトに対して使うと落ちます。

--- void Check_SafeStr(VALUE v)

古い API です。[[f:SafeStringValue]] を使ってください。

--- void Check_Type(VALUE val, int typeflag)

val の構造体型フラグが typeflag でなければ
例外 TypeError を発生します。val は即値の VALUE であっても
構いません。

--- VALUE CHR2FIX(char x)

char 型の整数 x を Ruby の Fixnum に変換します。

--- VALUE CLASS_OF(VALUE obj)

obj のクラスを返します。
この場合の「クラス」とは C レベルのクラス、
つまり RBasic 構造体の klass メンバの値です。
また、構造体を持たない Fixnum などに対しても正常に働きます。

--- void CLONESETUP(VALUE clone, VALUE obj)

OBJSETUP() の変種。
clone を、obj から clone で作った
オブジェクトとして初期化します。

--- void Data_Get_Struct(VALUE obj, type, type *svar)

Ruby のオブジェクト obj から type 型へのポインタを
とりだし svar に代入します。

使用例

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

--- VALUE Data_Make_Struct(VALUE klass, type, RUBY_DATA_FUNC mark, RUBY_DATA_FUNC free, type *svar)

type 型の構造体をヒープに割り当ててそれへのポインタを
svar に代入し、クラス klass のインスタンスである
Ruby のオブジェクトを生成し、それを返します。mark
free はそれぞれマーク用・解放用の関数へのポインタです。
どちらも、必要ないときはかわりに 0 を渡します。

また RUBY_DATA_FUNC の定義は以下のようです。

    typedef void (*RUBY_DATA_FUNC)(void *st)

第一引数 st には svar の値が渡されます。

使用例

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

--- void *DATA_PTR(VALUE dta)

実際は struct RData* 型である dta から、
それがラップしているポインタを取り出します。

--- VALUE Data_Wrap_Struct(VALUE klass, RUBY_DATA_FUNC mark, RUBY_DATA_FUNC free, void *sval)

C の構造体 sval をラップして klass クラスの
インスタンスである Ruby オブジェクトを生成し、それを返します。
mark、free はそれぞれ sval のマーク用・解放用の
関数へのポインタです。どちらも、必要ないときはかわりに 0 を渡します。

また RUBY_DATA_FUNC の定義は以下のようです。

    typedef void (*RUBY_DATA_FUNC)(void *st)

第一引数 st には sval が渡されます。

使用例

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

--- void DUPSETUP(dup, obj)

OBJSETUP() の変種。
dup を、obj から dup で作った
オブジェクトとして初期化します。

--- int FIX2INT(VALUE x)

Fixnum を int に変換します。
返り値が int の範囲から外れる場合は RangeError が発生します。

--- long FIX2LONG(VALUE x)

Fixnum を long に変換します。
返り値が long の範囲から外れる場合は RangeError が発生します。

--- unsigned int FIX2UINT(VALUE x)

Fixnum を unsigned int に変換します。
返り値が unsigned int の範囲から外れる場合は RangeError が発生します。

--- unsigned long FIX2ULONG(VALUE x)

Fixnum を unsigned long に変換します。
返り値が unsigned long の範囲から外れる場合は RangeError が発生します。

--- int FIXABLE(long f)

f が Fixnum の範囲に収まっているなら真。

--- long FIXNUM_MAX

Fixnum にできる整数の上限値。

--- long FIXNUM_MIN

Fixnum にできる整数の下限値。

--- int FIXNUM_P(VALUE obj)

obj が Fixnum のインスタンスのとき真。

--- int FL_ABLE(VALUE x)

x が即値の VALUE でなければ真。

--- void FL_REVERSE(VALUE x, int f)

x のフラグ f を反転する。

--- void FL_SET(VALUE x, int f)

x に対してフラグ f をセットする。

--- int FL_TEST(VALUE x, int f)

x のフラグ f が立っていたら真。

--- void FL_UNSET(VALUE x, int f)

x のフラグ f をクリアする。

--- VALUE ID2SYM(ID id)

id を Symbol に変換します。

--- int IMMEDIATE_P(VALUE obj)

obj がポインタでないとき真。すなわち現在の実装では
Symbol か Fixnum のインスタンスであるとき真。

--- VALUE INT2FIX(int i)

31ビット以内におさまる整数を Fixnum に変換します。

--- VALUE INT2NUM(long i)

任意の整数を Fixnum か Bignum に変換します。

--- int ISALNUM(char c)

--- int ISALPHA(char c)

--- int ISASCII(char c)

--- int ISDIGIT(char c)

--- int ISLOWER(char c)

--- int ISPRINT(char c)

--- int ISSPACE(char c)

--- int ISUPPER(char c)

--- int ISXDIGIT(char c)

--- VALUE LL2NUM(long long v)

--- VALUE LONG2FIX(long i)

--- VALUE LONG2NUM(long v)

--- int MEMCMP(p1, p2, type, n)

type 型のメモリ領域 p1 と p2 の先頭 n 個を比較する。
p1 が p2 の最初の n 個より小さい、等しい、大きいとき、そ
れぞれ正、0、負の値を返す。

--- void MEMCPY(p1, p2, type, n)

type 型のメモリ領域 p2 のうち先頭の n 個を p1 にコピーする。

--- void MEMMOVE(p1, p2, type, n)

type 型のメモリ領域 p2 のうち先頭の n 個を p1 に移動する。

--- void MEMZERO(p, type, n)

type 型のメモリ領域 p をゼロクリアする。 n は要素数。

--- int NEGFIXABLE(long f)

--- NEWOBJ(obj, int typeflag)

--- int NIL_P(VALUE obj)

obj が Qnil のとき真。

--- char NUM2CHR(VALUE x)

--- double NUM2DBL(VALUE x)

--- int NUM2INT(VALUE x)

--- long NUM2LONG(VALUE x)

--- unsigned int NUM2UINT(VALUE x)

--- unsigned long NUM2ULONG(VLAUE x)

--- void OBJ_FREEZE(VALUE x)

--- int OBJ_FROZEN(VALUE x)

--- void OBJ_INFECT(VALUE dest, VALUE src)

src に汚染マークが付いていたら dest も汚染する。

--- void OBJ_TAINT(VALUE x)

x に汚染マークを付ける。

--- int OBJ_TAINTED(VALUE x)

x に汚染マークが付いていたら真。

--- void OBJSETUP(obj, VALUE klass, int typeflag)

obj をクラス klass とフラグ typeflag で初期化する。
$SAFE >= 3 のときは無条件で汚染する。

--- int POSFIXABLE(long f)

f が Fixnum の上限値以下ならば真。

--- struct RArray *RARRAY(VALUE obj)

obj を struct RArray* にキャストする。
本当は obj が struct RArray* でないとしてもキャストしてしまう。

--- VALUE rb_fix_new(long v)

--- VALUE rb_int_new(long v)

--- int rb_safe_level(void)

現在のセーフレベルを返します。

--- VALUE rb_uint_new(unsigned int v)

--- struct RBasic *RBASIC(VALUE obj)

--- struct RBignum *RBIGNUM(VALUE obj)

--- struct RClass *RCLASS(VALUE obj)

--- struct RData *RDATA(VALUE obj)

--- type* REALLOC_N(var, type, n)

type 型のメモリ領域 var のサイズを n 個に変更する。

--- struct RFile *RFILE(VALUE obj)

--- struct RFloat *RFLOAT(VALUE obj)

--- struct RHash *RHASH(VALUE obj)

--- struct RClass *RMODULE(VALUE obj)

--- struct RObject *ROBJECT(VALUE obj)

--- struct RRegexp *RREGEXP(VALUE obj)

--- struct RString *RSTRING(VALUE obj)

--- struct RStruct *RSTRUCT(VALUE obj)

--- int RTEST(VALUE obj)

obj が Qfalse でも Qnil でもないとき真。

--- RUBY_DATA_FUNC(func)

任意の関数へのポインタ func を struct RData の dmark/dfree の
値として適する型に強制キャストします。

--- RUBY_METHOD_FUNC(func)

任意の関数へのポインタ func を Ruby のメソッドの実体として適する
型に強制キャストします。

--- SafeStringValue(v)

[[f:StringValue]] と同じく、val が String でなければ to_str メソッドを
使って String に変換します。同時に rb_check_safe_str() によるチェックも
行います。

--- int SPECIAL_CONST_P(VALUE obj)

obj が実体の構造体を持たないとき真。現時点で真になるのは
Qnil Qtrue Qfalse と、
Fixnum／Symbol のインスタンス。

--- char *STR2CSTR(VALUE str)

Ruby のオブジェクト str から C の文字列を取り出します。
str が String でない場合は to_str によって
変換を試みます。

返り値を free したり直接書き換えたりしてはいけません。

STR2CSTR は、与えられたオブジェクトが文字列でなく to_str メソッ
ドを持つ場合、内部で to_str を呼び出して暗黙の型変換を行い、
それが保持する文字列ポインタを返します。
しかし、このAPIでは暗黙の型変換結果となるオブジェクトがどこからも
保持されないため、注意して使用しないと結果が GC される可能性があります。

Ruby 1.7 以降では代わりに [[f:StringValuePtr]] を使用します。こちら
は、引数の参照先が暗黙の型変換の結果に置き換わるため変換結果が GC
されません。(Ruby 1.7 では、STR2CSTR() は、obsolete です)

[[f:StringValue]] は、引数が to_str による暗黙の型変換を期待する
場合に使用します。

--- StringValue(VALUE val)

val が String でなければ to_str メソッドを使って String に変換します。

このマクロに渡した VALUE は ruby の GC から確実に保護されます。

--- char *StringValuePtr(VALUE val)

val が String でなければ to_str メソッドを使って String に変換し、
その実体のポインタを返します。

このマクロに渡した VALUE は ruby の GC から確実に保護されます。

--- int SYM2ID(VALUE symbol)

Symbol symbol を数値に変換します。
1.4では、[[f:FIX2INT]](symbol)と同じです。

--- int SYMBOL_P(VALUE obj)

obj が Symbol のインスタンスのとき真。

--- int TYPE(VALUE obj)

obj の構造体型 ID を返します。

--- VALUE UINT2NUM(unsigned long i)

任意の整数を Fixnum か Bignum に変換します。

--- VALUE ULL2NUM(unsigned long long n)

--- VALUE ULONG2NUM(unsigned long n)

--- VALUE UINT2FIX(unsigned int i)

unsigned int を Fixnum に変換します。
