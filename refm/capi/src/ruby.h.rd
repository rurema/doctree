--- MACRO type* ALLOC(type)

type 型のメモリを割り当てる。

--- MACRO type* ALLOC_N(type, n)

type 型のメモリを n 個割り当てる。

--- MACRO type* ALLOCA_N(type, n)

type 型のメモリを n 個スタックフレームに割り当てる。
このメモリは関数が終わると自動的に解放される。

--- MACRO int BUILTIN_TYPE(VALUE obj)

obj の構造体型 ID を返します。
[[f:SPECIAL_CONST_P]](obj) が真のオブジェクトに対して使うと落ちます。

--- void Check_SafeStr(VALUE v)

古い API です。[[f:SafeStringValue]] を使ってください。

--- void Check_Type(VALUE val, int typeflag)

val の構造体型フラグが typeflag でなければ
例外 TypeError を発生します。val は即値の VALUE であっても
構いません。

--- MACRO VALUE CHR2FIX(char x)

char 型の整数 x を Ruby の Fixnum に変換します。

--- MACRO VALUE CLASS_OF(VALUE obj)

obj のクラスを返します。
この場合の「クラス」とは C レベルのクラス、
つまり RBasic 構造体の klass メンバの値です。
また、構造体を持たない Fixnum などに対しても正常に働きます。

--- MACRO void CLONESETUP(VALUE clone, VALUE obj)

OBJSETUP() の変種。
clone を、obj から clone で作った
オブジェクトとして初期化します。

--- MACRO void Data_Get_Struct(VALUE obj, type, type *svar)

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

--- MACRO VALUE Data_Make_Struct(VALUE klass, type, RUBY_DATA_FUNC mark, RUBY_DATA_FUNC free, type *svar)

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

--- MACRO void *DATA_PTR(VALUE dta)

実際は struct RData* 型である dta から、
それがラップしているポインタを取り出します。

--- MACRO VALUE Data_Wrap_Struct(VALUE klass, RUBY_DATA_FUNC mark, RUBY_DATA_FUNC free, void *sval)

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

--- MACRO void DUPSETUP(dup, obj)

OBJSETUP() の変種。
dup を、obj から dup で作った
オブジェクトとして初期化します。

--- MACRO int FIX2INT(VALUE x)

Fixnum を int に変換します。
返り値が int の範囲から外れる場合は RangeError が発生します。

--- MACRO long FIX2LONG(VALUE x)

Fixnum を long に変換します。
Fixnum は常に long に収まります。

--- MACRO unsigned int FIX2UINT(VALUE x)

Fixnum を unsigned int に変換します。
返り値が unsigned int の範囲から外れる場合は RangeError が発生します。

--- MACRO unsigned long FIX2ULONG(VALUE x)

Fixnum を unsigned long に変換します。
Fixnum は常に unsigned long に収まります。

--- MACRO int FIXABLE(long f)

f が Fixnum の範囲に収まっているなら真。

--- MACRO long FIXNUM_MAX

Fixnum にできる整数の上限値。

--- MACRO long FIXNUM_MIN

Fixnum にできる整数の下限値。

--- MACRO int FIXNUM_P(VALUE obj)

obj が Fixnum のインスタンスのとき真。

--- MACRO int FL_ABLE(VALUE x)

x が即値の VALUE でなければ真。

--- MACRO void FL_REVERSE(VALUE x, int f)

x のフラグ f を反転する。

--- MACRO void FL_SET(VALUE x, int f)

x に対してフラグ f をセットする。

--- MACRO int FL_TEST(VALUE x, int f)

x のフラグ f が立っていたら真。

--- MACRO void FL_UNSET(VALUE x, int f)

x のフラグ f をクリアする。

--- MACRO VALUE ID2SYM(ID id)

id を Symbol に変換します。

--- MACRO int IMMEDIATE_P(VALUE obj)

obj が即値でかつ真な値であるとき真。
すなわち現在の実装では
obj が Symbol か Fixnum のインスタンスであるか、 Qtrue のとき真。

--- MACRO VALUE INT2FIX(int i)

Fixnum におさまることが自明な整数を Fixnum に変換します。
なお、Fixnum の幅は long の幅 - 1 です。

--- MACRO VALUE INT2NUM(int i)

任意の整数を Fixnum か Bignum に変換します。

--- MACRO int ISALNUM(char c)

--- MACRO int ISALPHA(char c)

--- MACRO int ISASCII(char c)

--- MACRO int ISDIGIT(char c)

--- MACRO int ISLOWER(char c)

--- MACRO int ISPRINT(char c)

--- MACRO int ISSPACE(char c)

--- MACRO int ISUPPER(char c)

--- MACRO int ISXDIGIT(char c)

--- MACRO VALUE LL2NUM(long long v)

--- MACRO VALUE LONG2FIX(long i)

INT2FIX と同じです。

--- MACRO VALUE LONG2NUM(long v)

--- MACRO int MEMCMP(p1, p2, type, n)

type 型のメモリ領域 p1 と p2 の先頭 n 個を比較する。
p1 が p2 の最初の n 個より小さい、等しい、大きいとき、そ
れぞれ正、0、負の値を返す。

--- MACRO void MEMCPY(p1, p2, type, n)

type 型のメモリ領域 p2 のうち先頭の n 個を p1 にコピーする。

--- MACRO void MEMMOVE(p1, p2, type, n)

type 型のメモリ領域 p2 のうち先頭の n 個を p1 に移動する。

--- MACRO void MEMZERO(p, type, n)

type 型のメモリ領域 p をゼロクリアする。 n は要素数。

--- MACRO int NEGFIXABLE(long f)

f が Fixnum の下限値以上ならば真。

--- MACRO void NEWOBJ(obj, int typeflag)

--- MACRO int NIL_P(VALUE obj)

obj が Qnil のとき真。

--- MACRO char NUM2CHR(VALUE x)

--- MACRO double NUM2DBL(VALUE x)

--- MACRO int NUM2INT(VALUE x)

x を int 型の整数に変換します。

x が [[c:Fixnum]]、[[c:Float]]、[[c:Bignum]] オブジェクトのいずれでもな
い場合は x.to_int による暗黙の型変換を試みます。

x が nil の場合か、暗黙の型変換が成功しなかった場合は [[c:TypeError]]
が発生します。

x が int 型で表現できる値の範囲外であった場合は [[c:RangeError]] が発
生します。

--- MACRO long NUM2LONG(VALUE x)

x を long 型の整数に変換します。

x が [[c:Fixnum]]、[[c:Float]]、[[c:Bignum]] オブジェクトのいずれでもな
い場合は x.to_int による暗黙の型変換を試みます。

x が nil の場合か、暗黙の型変換が成功しなかった場合は [[c:TypeError]]
が発生します。

x が long 型で表現できる値の範囲外であった場合は [[c:RangeError]] が発
生します。

--- MACRO unsigned int NUM2UINT(VALUE x)

--- MACRO unsigned long NUM2ULONG(VLAUE x)

--- MACRO void OBJ_FREEZE(VALUE x)

--- MACRO int OBJ_FROZEN(VALUE x)

--- MACRO void OBJ_INFECT(VALUE dest, VALUE src)

src に汚染マークが付いていたら dest も汚染する。

--- MACRO void OBJ_TAINT(VALUE x)

x に汚染マークを付ける。

--- MACRO int OBJ_TAINTED(VALUE x)

x に汚染マークが付いていたら真。

--- MACRO void OBJSETUP(obj, VALUE klass, int typeflag)

obj をクラス klass とフラグ typeflag で初期化する。
$SAFE >= 3 のときは無条件で汚染する。

--- MACRO int POSFIXABLE(long f)

f が Fixnum の上限値以下ならば真。

--- MACRO struct RArray *RARRAY(VALUE obj)

obj を struct RArray* にキャストする。
本当は obj が struct RArray* でないとしてもキャストしてしまう。

--- VALUE rb_fix_new(long v)

--- VALUE rb_int_new(long v)

--- int rb_safe_level(void)

現在のセーフレベルを返します。

--- VALUE rb_uint_new(unsigned int v)

--- MACRO struct RBasic *RBASIC(VALUE obj)

--- MACRO struct RBignum *RBIGNUM(VALUE obj)

--- MACRO struct RClass *RCLASS(VALUE obj)

--- MACRO struct RData *RDATA(VALUE obj)

--- MACRO type* REALLOC_N(var, type, n)

type 型のメモリ領域 var のサイズを n 個に変更する。

--- MACRO struct RFile *RFILE(VALUE obj)

--- MACRO struct RFloat *RFLOAT(VALUE obj)

--- MACRO struct RHash *RHASH(VALUE obj)

--- MACRO struct RClass *RMODULE(VALUE obj)

--- MACRO struct RObject *ROBJECT(VALUE obj)

--- MACRO struct RRegexp *RREGEXP(VALUE obj)

--- MACRO struct RString *RSTRING(VALUE obj)

--- MACRO struct RStruct *RSTRUCT(VALUE obj)

--- MACRO int RTEST(VALUE obj)

obj が Qfalse でも Qnil でもないとき真。

--- MACRO RUBY_DATA_FUNC(func)

任意の関数へのポインタ func を struct RData の dmark/dfree の
値として適する型に強制キャストします。

--- MACRO RUBY_METHOD_FUNC(func)

任意の関数へのポインタ func を Ruby のメソッドの実体として適する
型に強制キャストします。

--- MACRO SafeStringValue(v)

[[f:StringValue]] と同じく、val が String でなければ to_str メソッドを
使って String に変換します。同時に rb_check_safe_str() によるチェックも
行います。

--- MACRO int SPECIAL_CONST_P(VALUE obj)

obj が実体の構造体を持たないとき真。
現時点で真になるのは Qnil, Qtrue, Qfalse と、
Fixnum, Symbol のインスタンス。

--- MACRO char *STR2CSTR(VALUE str)

Ruby のオブジェクト str から C の文字列を取り出します。
str が String でない場合は to_str によって変換を試みます。

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

--- MACRO void StringValue(VALUE val)

val が String でなければ to_str メソッドを使って String に変換します。

このマクロに渡した VALUE は ruby の GC から確実に保護されます。

--- MACRO char *StringValuePtr(VALUE val)

val が String でなければ to_str メソッドを使って String に変換し、
その実体のポインタを返します。

このマクロに渡した VALUE は ruby の GC から確実に保護されます。

--- MACRO int SYM2ID(VALUE symbol)

Symbol symbol を数値に変換します。
1.4では、[[f:FIX2INT]](symbol)と同じです。

--- MACRO int SYMBOL_P(VALUE obj)

obj が Symbol のインスタンスのとき真。

--- MACRO int TYPE(VALUE obj)

obj の構造体型 ID を返します。

--- MACRO VALUE UINT2NUM(unsigned int i)

任意の整数を Fixnum か Bignum に変換します。

--- MACRO VALUE ULL2NUM(unsigned long long n)

--- MACRO VALUE ULONG2NUM(unsigned long n)

