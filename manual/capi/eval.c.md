### void rb_alias(VALUE klass, ID def, ID name)

クラス klass に定義されたメソッド name の本体を実体とする新しいメソッド def を定義します。

### VALUE rb_apply(VALUE recv, ID mid, VALUE args)

オブジェクト recv のメソッド mid を引数 args とともに呼び出します。

### void rb_attr(VALUE klass, ID id, int read, int write, int ex)

### void rb_backtrace(void)

### VALUE rb_block_call(VALUE obj, ID mid, int argc, const VALUE *argv, rb_block_call_func_t proc, VALUE data2)

`obj` のメソッド `mid` を、C の関数 `proc` をブロックとして渡して呼び出します。
[f:rb_funcallv] にブロックとして関数を渡せるようにしたものです。

メソッドが `yield` すると、`proc` が呼ばれます。
`proc` は第 1 引数に `yield` された値を、第 2 引数に `data2` を受け取ります。
複数の値が `yield` されたとき、第 1 引数にはそれらを集めた [c:Array] が渡されます。
個々の値は、`proc` の第 3 引数 `argc` と第 4 引数 `argv` から取り出せます。

```c title="使用例"
VALUE
my_own_iterator(RB_BLOCK_CALL_FUNC_ARGLIST(y, c))
{
    ID plus = rb_intern("+");
    return rb_funcall(c, plus, 1, y);
}

VALUE
my_own_method(VALUE self)
{
    ID each = rb_intern("each");
    return rb_block_call(self, each, 0, 0, my_own_iterator, self);
}
```

- **param** `obj` -- メソッドのレシーバです。
- **param** `mid` -- 呼び出すメソッドの名前です。
- **param** `argc` -- `argv` の要素数です。
- **param** `argv` -- メソッドに渡す引数の配列です。
- **param** `proc` -- ブロックとして働く関数です。
- **param** `data2` -- `proc` の第 2 引数として渡される値です。
- **return** -- `obj` のメソッド `mid` の返り値です。

### VALUE rb_block_call_kw(VALUE obj, ID mid, int argc, const VALUE *argv, rb_block_call_func_t proc, VALUE data2, int kw_splat)

[f:rb_block_call] と同じですが、`argv` の最後の要素をキーワード引数として扱うかどうかを `kw_splat` で指定します。

`kw_splat` には次のどれかを指定します。

- `RB_NO_KEYWORDS` -- `argv` の最後はキーワード引数ではありません。
- `RB_PASS_KEYWORDS` -- `argv` の最後はキーワード引数です。
- `RB_PASS_CALLED_KEYWORDS` -- 現在のメソッドがキーワード引数付きで呼ばれていれば、キーワード引数を渡します。

- **param** `obj` -- メソッドのレシーバです。
- **param** `mid` -- 呼び出すメソッドの名前です。
- **param** `argc` -- キーワード引数を含めた引数の個数です。
- **param** `argv` -- メソッドに渡す引数の配列です。
- **param** `proc` -- ブロックとして働く関数です。
- **param** `data2` -- `proc` の第 2 引数として渡される値です。
- **param** `kw_splat` -- キーワード引数の扱いです。
- **return** -- `obj` のメソッド `mid` の返り値です。

### int rb_block_given_p(void)

メソッドがブロック付きで呼ばれていれば true を返します。

### VALUE rb_call_super(int argc, const VALUE *argv)

Rubyレベルでの super です。
現在評価中のメソッドのスーパークラスのメソッドを呼び出します。

### VALUE rb_catch(const char *tag, rb_block_call_func_t proc, VALUE data)

catch と同等の動作を実行します。

まず proc に、yield された値と data を渡して実行します。
その途中で tag が throw されたら rb_catch 全体を終了します。

throw が発生した場合はその値を返します。
throw が発生しなかったときは proc の返り値を返します。

```c
static VALUE
foo_yield(VALUE a, VALUE b)
{
    return rb_yield(b);
}

static VALUE
foo_catch(VALUE obj)
{
    return rb_catch("footag", foo_yield, INT2FIX(2));
}

static VALUE
foo_abort(VALUE obj)
{
    return rb_throw("footag", Qnil);
}

void
Init_foo(void)
{
    VALUE Foo = rb_define_class("Foo", rb_cObject);
    rb_define_method(Foo, "catch", foo_catch, 0);
    rb_define_method(Foo, "abort", foo_abort, 0);
}
```

#%until 3.1
### void rb_clear_cache(void)

メソッドキャッシュをすべて消去します。
#%end

#%until 3.2
### void rb_disable_super(VALUE klass, const char *name)

クラス klass のメソッド name からの super を禁止します。
klass とそのスーパークラスで name というメソッドが定義されていないときは例外 NameError を発生します。
#%end

#%until 3.2
### void rb_enable_super(VALUE klass, const char *name)

クラス klass のメソッド name からの super を許可します。
klass とそのスーパークラスで name というメソッドが定義されていないときは例外 NameError を発生します。
#%end

### VALUE rb_ensure(VALUE (*body)(VALUE), VALUE data1, VALUE (*ensure)(VALUE), VALUE data2)

ensure の C 版です。まず body(data1) を実行し、その途中で例外や exit が起きたとしても ensure(data2) が確実に実行されます ( body() が正常終了しても実行されます)。

### VALUE rb_eval_string(const char *str)

str を Ruby プログラムとしてコンパイル・評価し、その値を返します。

### VALUE rb_eval_string_protect(const char *str, int *state)

str を Ruby プログラムとしてコンパイル・評価し、その値を返します。

コンパイル中または評価中に例外を含む大域脱出が発生した場合は、
state が NULL でなければそれに値が代入され Qnil を返します。

### VALUE rb_eval_string_wrap(const char *str, int *state)

[f:rb_eval_string_protect] と同じですが、スクリプトの評価を無名のモジュールのもとで行います。

### void rb_exc_fatal(VALUE err)

例外オブジェクト err を fatal として投げます。

### void rb_exc_raise(VALUE err)

例外オブジェクト err を投げます。

### void rb_exit(int status)

ステータス status でインタプリタを終了させます。

### void rb_extend_object(VALUE obj, VALUE module)

### VALUE rb_f_abort(int argc, const VALUE *argv)

### VALUE rb_f_exit(int argc, const VALUE *argv)

### VALUE rb_f_require(VALUE obj, VALUE fname)

require の実体。
self == obj として fname を require します。

#%until 3.2
### void rb_frozen_class_p(VALUE klass)
#%end

### VALUE rb_funcall(VALUE recv, ID name, int nargs, ...)

recv に対してメソッド name を呼びだし、メソッドの返り値を返します。プライベートメソッドも呼びだせます。

メソッドへの引数は第四引数以降にあたえ、その数を nargs
に指定します。それら引数はすべて VALUE でなければいけません。

### VALUE rb_funcall2(VALUE recv, ID name, int nargs, VALUE *args)

recv に対してメソッド name を呼びだし、メソッドの返り値を返します。プライベートメソッドも呼びだせます。

メソッドへの引数は VALUE の配列として第四引数にあたえ、その長さを nargs に指定します。

### VALUE rb_funcall3(VALUE recv, ID mid, int argc, const VALUE *argv)

recv に対してメソッド name を呼びだし、メソッドの返り値を返します。

メソッドへの引数は VALUE の配列として第四引数にあたえ、その長さを nargs に指定します。

rb_funcall2 との違いは、プライベートメソッドを呼び出せないことです。

### VALUE rb_funcall_passing_block(VALUE recv, ID mid, int argc, const VALUE *argv)

[f:rb_funcallv_public] と同じですが、現在のメソッドが受け取ったブロックを、呼び出すメソッドのブロックとして渡します。
`foo(x, y, &z)` のようなメソッドが、受け取ったブロックをそのまま別のメソッドへ渡したいときに使います。

```c title="使用例"
/* def foo(x, y, &z)
 *   x.open(y, &z)
 * end
 * に相当する C の関数 */
VALUE
foo_translated_into_C(VALUE self, VALUE x, VALUE y)
{
    ID open = rb_intern("open");

    return rb_funcall_passing_block(x, open, 1, &y);
}
```

- **param** `recv` -- メソッドのレシーバです。
- **param** `mid` -- 呼び出すメソッドの名前です。
- **param** `argc` -- `argv` の要素数です。
- **param** `argv` -- メソッドに渡す引数の配列です。
- **return** -- 呼び出したメソッドの返り値です。
- **raise** `NoMethodError` -- メソッドがないとき、またはメソッドが private か protected のとき。
- **raise** `Exception` -- 呼び出したメソッドの中で例外が発生したとき。

### VALUE rb_funcall_passing_block_kw(VALUE recv, ID mid, int argc, const VALUE *argv, int kw_splat)

[f:rb_funcall_passing_block] と同じですが、`argv` の最後の要素をキーワード引数として扱うかどうかを `kw_splat` で指定します。

`kw_splat` には次のどれかを指定します。

- `RB_NO_KEYWORDS` -- `argv` の最後はキーワード引数ではありません。
- `RB_PASS_KEYWORDS` -- `argv` の最後はキーワード引数です。
- `RB_PASS_CALLED_KEYWORDS` -- 現在のメソッドがキーワード引数付きで呼ばれていれば、キーワード引数を渡します。

- **param** `recv` -- メソッドのレシーバです。
- **param** `mid` -- 呼び出すメソッドの名前です。
- **param** `argc` -- `argv` の要素数です。
- **param** `argv` -- メソッドに渡す引数の配列です。
- **param** `kw_splat` -- キーワード引数の扱いです。
- **return** -- 呼び出したメソッドの返り値です。
- **raise** `NoMethodError` -- メソッドがないとき、またはメソッドが private か protected のとき。
- **raise** `Exception` -- 呼び出したメソッドの中で例外が発生したとき。

### VALUE rb_funcall_with_block(VALUE recv, ID mid, int argc, const VALUE *argv, VALUE procval)

[f:rb_funcallv_public] と同じですが、ブロックを渡せます。
ブロックには [c:Proc] のインスタンスを指定します。
`to_proc` による変換が必要なときは、この関数に渡す前に済ませてください。
ただし `nil` とシンボルは特別に受け付けます。

- **param** `recv` -- メソッドのレシーバです。
- **param** `mid` -- 呼び出すメソッドの名前です。
- **param** `argc` -- `argv` の要素数です。
- **param** `argv` -- メソッドに渡す引数の配列です。
- **param** `procval` -- ブロックとして渡す [c:Proc]、シンボル、または `nil` です。
- **return** -- 呼び出したメソッドの返り値です。
- **raise** `NoMethodError` -- メソッドがないとき、またはメソッドが private か protected のとき。
- **raise** `Exception` -- 呼び出したメソッドの中で例外が発生したとき。

### VALUE rb_funcall_with_block_kw(VALUE recv, ID mid, int argc, const VALUE *argv, VALUE procval, int kw_splat)

[f:rb_funcall_with_block] と同じですが、`argv` の最後の要素をキーワード引数として扱うかどうかを `kw_splat` で指定します。

`kw_splat` には次のどれかを指定します。

- `RB_NO_KEYWORDS` -- `argv` の最後はキーワード引数ではありません。
- `RB_PASS_KEYWORDS` -- `argv` の最後はキーワード引数です。
- `RB_PASS_CALLED_KEYWORDS` -- 現在のメソッドがキーワード引数付きで呼ばれていれば、キーワード引数を渡します。

- **param** `recv` -- メソッドのレシーバです。
- **param** `mid` -- 呼び出すメソッドの名前です。
- **param** `argc` -- `argv` の要素数です。
- **param** `argv` -- メソッドに渡す引数の配列です。
- **param** `procval` -- ブロックとして渡す [c:Proc]、シンボル、または `nil` です。
- **param** `kw_splat` -- キーワード引数の扱いです。
- **return** -- 呼び出したメソッドの返り値です。
- **raise** `NoMethodError` -- メソッドがないとき、またはメソッドが private か protected のとき。
- **raise** `Exception` -- 呼び出したメソッドの中で例外が発生したとき。

### VALUE rb_funcallv(VALUE recv, ID mid, int argc, const VALUE *argv)

`recv` のメソッド `mid` を、引数を C の配列で渡して呼び出します。
private や protected のメソッドも呼び出せます。
[f:rb_funcall] とは、引数の渡し方だけが異なります。

- **param** `recv` -- メソッドのレシーバです。
- **param** `mid` -- 呼び出すメソッドの名前です。
- **param** `argc` -- `argv` の要素数です。
- **param** `argv` -- メソッドに渡す引数の配列です。
- **return** -- 呼び出したメソッドの返り値です。
- **raise** `NoMethodError` -- メソッドがないとき。
- **raise** `Exception` -- 呼び出したメソッドの中で例外が発生したとき。

### VALUE rb_funcallv_kw(VALUE recv, ID mid, int argc, const VALUE *argv, int kw_splat)

[f:rb_funcallv] と同じですが、`argv` の最後の要素をキーワード引数として扱うかどうかを `kw_splat` で指定します。

`kw_splat` には次のどれかを指定します。

- `RB_NO_KEYWORDS` -- `argv` の最後はキーワード引数ではありません。
- `RB_PASS_KEYWORDS` -- `argv` の最後はキーワード引数です。
- `RB_PASS_CALLED_KEYWORDS` -- 現在のメソッドがキーワード引数付きで呼ばれていれば、キーワード引数を渡します。

- **param** `recv` -- メソッドのレシーバです。
- **param** `mid` -- 呼び出すメソッドの名前です。
- **param** `argc` -- `argv` の要素数です。
- **param** `argv` -- メソッドに渡す引数の配列です。
- **param** `kw_splat` -- キーワード引数の扱いです。
- **return** -- 呼び出したメソッドの返り値です。
- **raise** `NoMethodError` -- メソッドがないとき。
- **raise** `Exception` -- 呼び出したメソッドの中で例外が発生したとき。

### VALUE rb_funcallv_public(VALUE recv, ID mid, int argc, const VALUE *argv)

`recv` のメソッド `mid` を、引数を C の配列で渡して呼び出します。
[f:rb_funcallv] と異なり、public のメソッドだけを呼び出せます。
Ruby の [m:Object#public_send] に近い動作です。

- **param** `recv` -- メソッドのレシーバです。
- **param** `mid` -- 呼び出すメソッドの名前です。
- **param** `argc` -- `argv` の要素数です。
- **param** `argv` -- メソッドに渡す引数の配列です。
- **return** -- 呼び出したメソッドの返り値です。
- **raise** `NoMethodError` -- メソッドがないとき。
- **raise** `NoMethodError` -- メソッドが private か protected のとき。
- **raise** `Exception` -- 呼び出したメソッドの中で例外が発生したとき。

### VALUE rb_funcallv_public_kw(VALUE recv, ID mid, int argc, const VALUE *argv, int kw_splat)

[f:rb_funcallv_public] と同じですが、`argv` の最後の要素をキーワード引数として扱うかどうかを `kw_splat` で指定します。

`kw_splat` には次のどれかを指定します。

- `RB_NO_KEYWORDS` -- `argv` の最後はキーワード引数ではありません。
- `RB_PASS_KEYWORDS` -- `argv` の最後はキーワード引数です。
- `RB_PASS_CALLED_KEYWORDS` -- 現在のメソッドがキーワード引数付きで呼ばれていれば、キーワード引数を渡します。

- **param** `recv` -- メソッドのレシーバです。
- **param** `mid` -- 呼び出すメソッドの名前です。
- **param** `argc` -- `argv` の要素数です。
- **param** `argv` -- メソッドに渡す引数の配列です。
- **param** `kw_splat` -- キーワード引数の扱いです。
- **return** -- 呼び出したメソッドの返り値です。
- **raise** `NoMethodError` -- メソッドがないとき。
- **raise** `NoMethodError` -- メソッドが private か protected のとき。
- **raise** `Exception` -- 呼び出したメソッドの中で例外が発生したとき。

### void rb_interrupt(void)

### void rb_iter_break(void)

break の C 用インターフェイスです。
現在評価中のブロックから抜けます。

代表的には、rb_iterate の block_proc 中で使います。

### void rb_iter_break_value(VALUE val)

現在もっとも内側のブロックから抜けます。
[f:rb_iter_break] と同じですが、イテレータの評価結果となる値 `val` を指定できます。
この値はブロックの `yield` の値ではなく、ブロックを渡されたイテレータ(メソッド)の返り値になります。
この関数は呼び出し元に戻りません。

- **param** `val` -- イテレータの返り値にする値です。
- **raise** `LocalJumpError` -- ブロックの外から呼ばれたとき。

#%until 4.1
### VALUE rb_iterate(VALUE (*call_proc)(), VALUE date1, VALUE (*block_proc)(), date2)

ブロック付きメソッド(イテレータ)呼び出しを行う関数です。

まず call_proc(data1) を実行します。そしてその関数かその直下のメソッドで yield が発生すると以下が実行されます。

```text
block_proc(VALUE block_arg, VALUE data2, VALUE self)
```

block_arg はブロック引数(複数なら配列に入っている)、
data2 は rb_iterate() に渡したもの、
self は block_proc 呼び出し時点での self です。

Ruby 4.1 で削除されました。[feature:21768]
#%end

### void rb_jump_tag(int tag)

初出: [ruby-dev:4064]

[f:rb_load_protect],[f:rb_eval_string_protect],[f:rb_protect]
などで捕捉した大域脱出を再生成します。

tagには上記関数の引数で受け取ったstateを指定します。

### void rb_load(VALUE fname, int wrap)

参考: [ruby-list:21651]

組込み関数 [m:Kernel?.load] の低レベルインタフェースです。Rubyスクリプトが格納されたファイルfname をロードします。

引数wrapが、non-zeroなら無名のモジュールを生成して、ロードした内容をそのモジュールに閉じ込めます。閉じ込めるのは

  - 定数
  - クラス、モジュール
  - トップレベルメソッド

です。グローバル変数の変更などは閉じ込められません。

### void rb_load_protect(VALUE fname, int wrap, int *state)

### int rb_method_boundp(VALUE klass, ID id, int ex)

### VALUE rb_mod_module_eval(int argc, VALUE *argv, VALUE mod)

Module#module_eval の実体です。

### void rb_obj_call_init(VALUE obj, int argc, VALUE *argv)

オブジェクト obj に対して initialize を呼び出します。
引数は長さ argc の配列 argv で表され、ブロックが積んである場合はそれも自動的に渡されます。

### VALUE rb_obj_instance_eval(int argc, VALUE *argv, VALUE self)

### VALUE rb_obj_is_proc(VALUE recv)

`recv` が [c:Proc] のインスタンスであれば真を返します。

### VALUE rb_obj_method(VALUE recv, VALUE mid)

### int rb_obj_respond_to(VALUE obj, ID mid, int private_p)

`obj` がメソッド `mid` に応答するなら 1、そうでなければ 0 を返します。
`private_p` が真のときはプライベートメソッドも対象にします。

### VALUE rb_proc_new(rb_block_call_func_t func, VALUE val)

### VALUE rb_protect(VALUE (*proc)(VALUE), VALUE data, int *state)

初出: [ruby-dev:4064]

proc(data) を評価中のあらゆる大域脱出(例外を含む)を捕捉します。

```c
val = rb_protect(func, arg, &status);
if (status != 0) {
    puts("大域脱出が起きた");
    rb_jump_tag(status);
}
```

### void rb_provide(const char *feature)

ライブラリ feature をロードしたものとしてロックをかけます。

### int rb_provided(const char *feature)

### void rb_remove_method(VALUE klass, const char *name)

クラス klass 自体に登録されている name という名前のメソッドを検索し、エントリを削除します。
見付からなかったときは例外 NameError を発生します。

### VALUE rb_require(const char *fname)

require の C 版です。feature「fname」をロードします。

### VALUE rb_rescue(VALUE (*b_proc)(VALUE), VALUE data1, VALUE (*r_proc)(VALUE, VALUE), VALUE data2)

まず b_proc(data1) を実行し、その途中で例外が発生したら r_proc(data2) を実行します。
捕捉する例外は [c:StandardError] のサブクラスだけです。

### VALUE rb_rescue2(VALUE (*b_proc)(VALUE), VALUE data1, VALUE (*r_proc)(VALUE, VALUE), VALUE data2, ...)

まず b_proc(data1) を実行し、その途中で例外が発生したら r_proc(data2) を実行します。
第五引数以降の可変長引数に捕捉したい例外クラスのリストを指定します。
引数の最後は NULL で終らなければなりません。

### int rb_respond_to(VALUE obj, ID id)

obj にメソッド id が定義されているとき真。
プライベートメソッドに対しても真を返します。

### void rb_set_end_proc(void (*func)(VALUE), VALUE data)

### int rb_thread_alone(void)

評価器にスレッドが一つしか存在しないとき真。

### void rb_thread_atfork(void)

### VALUE rb_thread_create(VALUE (*fn)(void *), void *arg)

### VALUE rb_thread_current(void)

現在実行中のスレッドを返します。

### void rb_thread_fd_close(int fd)

### int rb_thread_fd_writable(int fd)

### VALUE rb_thread_kill(VALUE thread)

### VALUE rb_thread_local_aref(VALUE thread, ID id)

### VALUE rb_thread_local_aset(VALUE thread, ID id, VALUE val)

### VALUE rb_thread_main(void)

メインスレッド (プロセスの一番最初に存在するスレッド) を返します。

### VALUE rb_thread_run(VALUE thread)

スレッド thread に実行権を渡します。

### void rb_thread_schedule(void)

他のスレッドに実行権を渡します。
対象の特定はできません。

- **SEE** [f:rb_thread_wait_fd], [f:rb_thread_wait_for]

### void rb_thread_sleep(int sec)

### void rb_thread_sleep_forever(void)

### VALUE rb_thread_stop(void)

現在実行中のスレッドを停止します。
他のスレッドから rb_thread_wakeup を呼ばれると再開します。

#%since 4.0
### int rb_thread_wait_fd(int fd)
#%else
### void rb_thread_wait_fd(int fd)
#%end

ファイルディスクリプタ fd を読み込めるようになるまでカレントスレッドを停止します。

### void rb_thread_wait_for(struct timeval time)

time の長さの時間が経過するまでカレントスレッドを停止します。

### VALUE rb_thread_wakeup(VALUE thread)

停止中のスレッド thread を再開させます。

### void rb_throw(const char *tag, VALUE val)

throw の実体。返り値を val として、
tag を catch したところまでジャンプします。

rb_catch も参照してください。

### void rb_undef(VALUE klass, ID id)

クラス klass のメソッド id を undef します。

### VALUE rb_yield(VALUE val)

yield の C 版です。val を引数にブロックを実行します。
複数の引数を与えたいときは配列に格納して渡します。

この関数を呼び出したメソッドがブロックを伴わない場合は、例外
[c:LocalJumpError] が発生します。

### VALUE rb_yield_splat(VALUE ary)

配列 `ary` の要素を、それぞれ別の引数としてブロックに `yield` します。
[f:rb_yield_values2] と同じですが、引数を Ruby の配列で指定します。

- **param** `ary` -- 展開して渡す引数の配列です。
- **return** -- ブロックの評価結果です。
- **raise** `LocalJumpError` -- ブロックが渡されていないとき。

### VALUE rb_yield_splat_kw(VALUE ary, int kw_splat)

[f:rb_yield_splat] と同じですが、`ary` の最後の要素をキーワード引数として扱うかどうかを `kw_splat` で指定します。

`kw_splat` には `RB_NO_KEYWORDS`(最後はキーワード引数ではない)か `RB_PASS_KEYWORDS`(最後はキーワード引数)を指定します。
`RB_PASS_CALLED_KEYWORDS` はここでは意味を持ちません。

- **param** `ary` -- 展開して渡す引数の配列です。
- **param** `kw_splat` -- キーワード引数の扱いです。
- **return** -- ブロックの評価結果です。
- **raise** `LocalJumpError` -- ブロックが渡されていないとき。

### VALUE rb_yield_values(int n, ...)

`n` 個の引数をブロックに `yield` します。
[f:rb_yield] と同じですが、引数を可変長で渡します。
Ruby の引数 1 つにつき、C の引数 1 つを使います。

- **param** `n` -- ブロックに渡す引数の個数です。
- **param** `...` -- ブロックに渡す引数です。`n` 個渡します。
- **return** -- ブロックの評価結果です。
- **raise** `LocalJumpError` -- ブロックが渡されていないとき。

### VALUE rb_yield_values2(int n, const VALUE *argv)

`n` 個の引数をブロックに `yield` します。
[f:rb_yield_values] と同じですが、引数を C の配列 `argv` で渡します。

- **param** `n` -- ブロックに渡す引数の個数です。
- **param** `argv` -- ブロックに渡す引数の配列です。
- **return** -- ブロックの評価結果です。
- **raise** `LocalJumpError` -- ブロックが渡されていないとき。

### VALUE rb_yield_values_kw(int n, const VALUE *argv, int kw_splat)

[f:rb_yield_values2] と同じですが、`argv` の最後の要素をキーワード引数として扱うかどうかを `kw_splat` で指定します。

`kw_splat` には `RB_NO_KEYWORDS`(最後はキーワード引数ではない)か `RB_PASS_KEYWORDS`(最後はキーワード引数)を指定します。
`RB_PASS_CALLED_KEYWORDS` はここでは意味を持ちません。

- **param** `n` -- ブロックに渡す引数の個数です。
- **param** `argv` -- ブロックに渡す引数の配列です。
- **param** `kw_splat` -- キーワード引数の扱いです。
- **return** -- ブロックの評価結果です。
- **raise** `LocalJumpError` -- ブロックが渡されていないとき。

### void ruby_finalize(void)

評価器プロセスの終了処理を行います。

### void ruby_init(void)

評価器を初期化します。Ruby C API を呼ぶプロセスでは前もって必ずこの関数を呼ばなければなりません。

### void *ruby_options(int argc, char **argv)

argc と argv を ruby へのコマンドラインオプションとして処理します。

### int ruby_run_node(void *n)

コンパイル済みのソースを実行し、このプロセスを終了します。
`n` には `rb_load_file` などで得た、中身の見えない「ノード」のポインタを渡します。

- **param** `n` -- 実行するソースを表す、中身の見えないノードのポインタです。
- **return** -- ソースの実行に成功すると `EXIT_SUCCESS` です。エラーが起きたときは `EXIT_FAILURE` です。

### void ruby_script(const char *name)

現在のスクリプト名を `name` に設定します。
Ruby レベルで `$0 = name` とするのと似ていますが、インタプリタが保持するスクリプト名も変わります。

- **param** `name` -- 設定するファイル名です。

### void ruby_stop(int ex)

評価器プロセスを停止します。
