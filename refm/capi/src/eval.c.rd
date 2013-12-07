--- static char *arg_defined(VALUE self, NODE *node, char *buf, char *type)

--- static void assign(VALUE self, NODE *lhs, VALUE val, int pcall)

左辺を表す構文木 lhs に対し、右辺の値 val を代入します。
Proc オブジェクトを起動する場合は pcall を非ゼロとします。

--- static VALUE avalue_to_svalue(VALUE v)

--- static VALUE avalue_to_yvalue(VALUE v)

--- static VALUE backtrace(int lev)

--- static VALUE bind_clone(VALUE self)

--- static void blk_copy_prev(struct BLOCK *block)

--- static void blk_free(struct BLOCK *data)

--- static void blk_mark(struct BLOCK *data)

--- static int blk_orphan(struct BLOCK *data)

data が作成された SCOPE かまたはその子ではない
SCOPE を評価しているとき真。

--- static VALUE block_pass(VALUE self, NODE *node)

node を評価して Proc オブジェクトを得、それを積みます。

--- static void bm_mark(struct METHOD *data)

--- static VALUE bmcall(VALUE args, VALUE method)

--- static VALUE call_cfunc(VALUE (*func)(), VALUE recv, int len, int argc, VALUE *argv)

C で定義されたメソッドの起動に際し、実体の関数 func を呼び出します。

--- static void call_end_proc(VALUE data)

評価器プロセスが終了するとき、
END 文で登録された Proc オブジェクト data を起動します。

--- static void call_trace_func(char *event, NODE *pos, VALUE self, ID id, VALUE klass)

評価器の動作をフックする手続き trace_func を評価します。

--- static VALUE catch_i(ID tag)

--- static void catch_timer(int sig)

--- static NODE *compile(VALUE src, char *file, int line)

Ruby の文字列または IO オブジェクト src を
構文木にコンパイルし、返します。そのとき、src が
ファイル file の line 行目から始まっていると仮定します。

--- static void compile_error(const char *at)

--- static void copy_fds(fd_set *dst, fd_set *src, int max)

fd_set src を dst にコピーします。
max は select(2) の第一引数と同じ意味です。

--- static NODE *copy_node_scope(NODE *node, VALUE rval)

node の先頭についているはずの、
ローカル変数スコープを積むための情報を格納したノード NODE_SCOPE を
コピーして返します。そのとき nd_rval に rval を格納します。

--- static VALUE cvar_cbase(void)

現在のコンテキストで、クラス変数の探索の起点となるモジュールを返します。

--- static inline void dvar_asgn(ID id, VALUE value)

現在のローカル変数スコープ中に存在するはずの
ブロックローカル変数 id に value を代入します。

--- static inline void dvar_asgn_curr(ID id, VALUE value)

現在のブロックローカル変数スコープに存在するはずの
ブロックローカル変数 id に value を代入します。

--- static void dvar_asgn_internal(ID id, VALUE value, int curr)

dvar_asgn と dvar_asgn_curr の補助関数です。

--- static VALUE errat_getter(ID id)

--- static void errat_setter(VALUE val, ID id, VALUE *var)

--- static void errinfo_setter(VALUE val, ID id, VALUE *var)

--- static int error_handle(int ex)

--- static void error_pos(void)

--- static void error_print(void)

--- static VALUE ev_const_defined(NODE *cref, ID id, VALUE self)

外のクラスが cref で self が self のとき、
定数 id が定義されていたら真。

--- static VALUE ev_const_get(NODE *cref, ID id, VALUE self)

外のクラスが cref で self が self として
定数 id を参照します。

--- static VALUE eval(VALUE self, VALUE src, VALUE scope, char *file, int line)

eval の実体。文字列 src を評価します。
そのとき第三引数 scope が nil でなければ
そのコンテキストの元で評価します。

また src をコンパイルするとき、
ファイル file の line 行目に配置されていると仮定します。

--- static VALUE eval_node(VALUE self, NODE *node)

--- static VALUE eval_under(VALUE under, VALUE self, VALUE src, const char *file, int line)

--- static VALUE eval_under_i(VALUE *args)

--- static VALUE exec_under(VALUE (*func)(), VALUE under, VALUE cbase, void *args)

--- static int find_bad_fds(fd_set *dst, fd_set *src, int max)

--- static void frame_dup(struct FRAME *frame)

frame とその親 FRAME 全てをスタックからヒープに割り当てなおします。

--- static VALUE get_backtrace(VALUE info)

--- static int handle_rescue(VALUE self, NODE *node)

--- void Init_eval(void)

--- void Init_load(void)

--- void Init_Proc(void)

--- void Init_Thread(void)

--- static int intersect_fds(fd_set *src, fd_set *dst, int max)

--- static char *is_defined(VALUE self, NODE *node, char *buf)

node を self = self で評価したとき値が得られそうな
式であれば、node の種別を表す文字列を返します。

--- static void jump_tag_but_local_jump(int state)

--- static void localjump_error(const char *mesg, VALUE status)

--- static VALUE localjump_exitstatus(VALUE exc)

--- static VALUE make_backtrace(void)

--- static VALUE massign(VALUE self, NODE *node, VALUE val, int pcall)

--- static int match_fds(fd_set *dst, fd_set *src, int max)

--- static VALUE method_arity(VALUE method)

--- static VALUE method_call(int argc, VALUE *argv, VALUE method)

--- static VALUE method_clone(VALUE self)

--- static VALUE method_eq(VALUE method, VALUE other)

--- static VALUE method_inspect(VALUE method)

--- static VALUE method_proc(VALUE method)

--- static VALUE method_unbind(VALUE obj)

--- static VALUE mnew(VALUE klass, VALUE obj, ID id, VALUE mklass)

--- static VALUE module_setup(VALUE module, NODE *n)

module を定義するモジュール文の本体 n を評価します。

--- static VALUE mproc(void)

--- static VALUE mvalue_to_svalue(VALUE v)

--- static struct BLOCKTAG *new_blktag(void)

--- static struct RVarmap *new_dvar(ID id, VALUE value, struct RVarmap *prev)

--- static void print_undef(VALUE klass, ID id)

クラス klass にメソッド id が見付からない (undefined) ことに
対するエラーメッセージを stderr に出力します。

--- static VALUE proc_arity(VALUE proc)

--- static VALUE proc_binding(VALUE proc)

--- static VALUE proc_call(VALUE proc, VALUE args)

--- static VALUE proc_eq(VALUE self, VALUE other)

--- static int proc_get_safe_level(VALUE data)

--- static VALUE proc_invoke(VALUE proc, VALUE args, int pcall, VALUE self)

Proc オブジェクト proc を起動します。そのとき
引数を args とし、self を self にします。

--- static VALUE proc_new(VALUE klass)

評価器のその時点でのスナップショットを保存する
Proc オブジェクトを生成します。クラスを klass にします。

--- static VALUE proc_s_new(int argc, VALUE *argv, VALUE klass)

Proc.new の実体。

--- static void proc_save_safe_level(VALUE data)

--- static void proc_set_safe_level(VALUE data)

--- static VALUE proc_to_proc(VALUE proc)

--- static VALUE proc_to_s(VALUE self, VALUE other)

--- static VALUE proc_yield(VALUE proc, VALUE args)

Proc.yield の実体。

--- void rb_add_method(VALUE klass, ID mid, NODE *node, int noex)

クラス klass に mid という名前のメソッドを定義する。
その本体は node であり、noex で示される可視性を持つ。

--- void rb_alias(VALUE klass, ID name, ID def)

クラス klass に定義されたメソッド name の
本体を実体とする新しいメソッド def を定義します。

--- VALUE rb_apply(VALUE recv, ID mid, VALUE args)

オブジェクト recv のメソッド mid を
引数 args とともに呼び出します。

--- void rb_attr(VALUE klass, ID id, int read, int write, int ex)

--- void rb_backtrace(void)

--- int rb_block_given_p(void)

メソッドがブロック付きで呼ばれていれば true を返します。

--- static VALUE rb_call(VALUE klass, VALUE recv, ID mid, int argc, const VALUE *argv, int scope)

クラス klass に定義されたメソッド mid を呼び出します。
レシーバは recv で、引数は長さ argc の配列 argv で渡します。

scope は以下のように呼び出しの形式を示します。

: 0
    obj.method()   (private/protected メソッドを呼べない)
: 1
    method()       (private/protected メソッドも呼べる)
: 2
    method_or_lvar (1とはエラーメッセージが変わる)
: 3
    super

--- static VALUE rb_call0(VALUE klass, VALUE recv, ID id, int argc, VALUE *argv, NODE *body, int nosuper)

クラス klass に定義されたメソッドのコード body を起動します。
レシーバは recv で、引数は長さ argc の配列 argv で渡します。
nosuper が非ゼロのときは、この呼び出し中の super がエラーになります。

--- VALUE rb_call_super(int argc, const VALUE *argv)

Rubyレベルでの super です。
現在評価中のメソッドのスーパークラスのメソッドを呼び出します。

--- static VALUE rb_callcc(VALUE self)

Continuation オブジェクトを生成します。

--- VALUE rb_catch(const char *tag, VALUE (*proc)(), VALUE data)

catch と同等の動作を実行します。

まず proc に、yield された値と data を渡して実行します。
その途中で tag が throw されたら rb_catch 全体を終了します。

throw が発生した場合はその値を返します。
throw が発生しなかったときは proc の返り値を返します。

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

--- void rb_check_safe_str(VALUE x)

マクロ Check_SafeStr の本体です。

この API は obsolete です。
SafeStringValue() を使ってください。

--- void rb_clear_cache(void)

メソッドキャッシュをすべて消去します。

--- static void rb_clear_cache_by_class(VALUE klass)

メソッドキャシュから klass クラスのメソッドの
キャッシュエントリを消去します。

--- static void rb_clear_cache_by_id(ID id)

メソッドキャシュから id という名前のメソッドの
キャッシュエントリを全て消去します。

--- static VALUE rb_cont_call(int argc, VALUE *argv, VALUE cont)

Continuation#call の実体。

--- void rb_disable_super(VALUE klass, const char *name)

クラス klass のメソッド name からの super を禁止します。
klass とそのスーパークラスで name というメソッドが定義
されていないときは例外 NameError を発生します。

--- VALUE rb_dvar_curr(ID id)

現在のブロックローカル変数スコープで id を参照します。

--- VALUE rb_dvar_defined(ID id)

--- void rb_dvar_push(ID id, VALUE value)

--- VALUE rb_dvar_ref(ID id)

現在のローカル変数スコープで id を参照します。

--- void rb_enable_super(VALUE klass, const char *name)

クラス klass のメソッド name からの super を許可します。
klass とそのスーパークラスで name というメソッドが定義
されていないときは例外 NameError を発生します。

--- VALUE rb_ensure(VALUE (*body)(), VALUE data1, VALUE (*ensure)(), VALUE data2)

ensure の C 版です。まず body(data1) を実行し、その途中で
例外や exit が起きたとしても ensure(data2) が確実に
実行されます ( body() が正常終了しても実行されます)。

--- static VALUE rb_eval(VALUE self, NODE *n)

構文木 n を self = self のもとで評価します。

--- VALUE rb_eval_cmd(VALUE cmd, VALUE arg, int tcheck)

--- VALUE rb_eval_string(const char *str)

str を Ruby プログラムとしてコンパイル・評価し、
その値を返します。

--- VALUE rb_eval_string_protect(const char *str, int *state)

str を Ruby プログラムとしてコンパイル・評価し、
その値を返します。

コンパイル中または評価中に例外を含む大域脱出が発生した場合は、
state が NULL でなければそれに値が代入され Qnil を返します。

--- VALUE rb_eval_string_wrap(const char *str, int *state)

[[f:rb_eval_string_protect]] と同じですが，スクリプトの評価を
無名のモジュールのもとで行います。

--- void rb_exc_fatal(VALUE err)

例外オブジェクト err を fatal として投げます。

--- void rb_exc_raise(VALUE err)

例外オブジェクト err を投げます。

--- void rb_exec_end_proc(void)

END ブロックおよび Kernel#at_exit で登録した Proc オブジェクトを
実行します。

--- void rb_exit(int status)

ステータス status でインタプリタを終了させます。

--- static void rb_export_method(VALUE klass, ID name, ID noex)

--- void rb_extend_object(VALUE obj, VALUE module)

--- static VALUE rb_f_abort(int argc, VALUE *argv)

--- static VALUE rb_f_at_exit(void)

--- static VALUE rb_f_binding(VALUE self)

--- static VALUE rb_f_block_given_p(void)

block_given? の実体。
現在評価中の (Ruby で実装された) メソッドに対して
ブロックが与えられていたら真。

--- static VALUE rb_f_caller(int argc, VALUE *argv)

--- static VALUE rb_f_catch(VALUE dmy, VALUE tag)

--- static void rb_f_END(void)

--- static VALUE rb_f_eval(int argc, VALUE *argv, VALUE self)

--- static VALUE rb_f_exit(int argc, VALUE *argv, VALUE obj)

--- VALUE rb_f_lambda(void)

ruby_block 先端の BLOCK から Proc オブジェクトを作成し、返します。

--- static VALUE rb_f_load(int argc, VALUE *argv)

load の実体。

--- static VALUE rb_f_local_variables(void)

--- static VALUE rb_f_loop(void)

loop の実体。永遠に yield を繰り返します。

--- static VALUE rb_f_missing(int argc, VALUE *argv, VALUE obj)

--- static VALUE rb_f_raise(int argc, VALUE *argv)

--- VALUE rb_f_require(VALUE obj, VALUE fname)

require の実体。
self == obj として fname を require します。

--- static VALUE rb_f_send(int argc, VALUE *argv, VALUE recv)

--- static VALUE rb_f_throw(int argc, VALUE *argv)

--- static int rb_feature_p(const char *feature, int wait)

--- ID rb_frame_last_func(void)

現在呼び出し中の (Rubyで実装された) メソッドの呼び出し名を返します。

--- void rb_frozen_class_p(VALUE klass)

--- VALUE rb_funcall(VALUE recv, ID name, int nargs, ...)

recv に対してメソッド name を呼びだし、
メソッドの返り値を返します。プライベートメソッドも
呼びだせます。

メソッドへの引数は第四引数以降にあたえ、その数を nargs
に指定します。それら引数はすべて VALUE でなければ
いけません。

--- VALUE rb_funcall2(VALUE recv, ID name, int nargs, VALUE *args)

recv に対してメソッド name を呼びだし、
メソッドの返り値を返します。プライベートメソッドも
呼びだせます。

メソッドへの引数は VALUE の配列として第四引数にあたえ、
その長さを nargs に指定します。

--- VALUE rb_funcall3(VALUE recv, ID mid, int argc, const VALUE *argv)

recv に対してメソッド name を呼びだし、
メソッドの返り値を返します。

メソッドへの引数は VALUE の配列として第四引数にあたえ、
その長さを nargs に指定します。

rb_funcall2 との違いは、プライベートメソッドを呼び出せないことです。

--- void rb_gc_mark_threads(void)

存在するスレッド全てをマークします。

--- static NODE *rb_get_method_body(VALUE *klassp, ID *idp, int *noexp)

クラス klass から id という名前のメソッドエントリを検索する。
見付かったらその本体である構文木を返す。見付からなければ
NULL を返す。

検索結果をキャッシュする。

--- void rb_interrupt(void)

--- void rb_iter_break(void)

break の C 用インターフェイスです。
現在評価中のブロックから抜けます。

代表的には、rb_iterate の block_proc 中で使います。

--- VALUE rb_iterate(VALUE (*call_proc)(), VALUE date1, VALUE (*block_proc)(), date2)

ブロック付きメソッド(イテレータ)呼び出しを行う関数です．

まず call_proc(data1) を実行します。そしてその関数か
その直下のメソッドで yield が発生すると以下が実行されます。

    block_proc(VALUE block_arg, VALUE data2, VALUE self)

block_arg はブロック引数(複数なら配列に入っている)、
data2 は rb_iterate() に渡したもの、
self は block_proc 呼び出し時点での self です。

--- int rb_iterator_p()

この関数はobsoleteです。[[f:rb_block_given_p]] を使用してください。

--- void rb_jump_tag(int tag)

初出: [[ruby-dev:4064]]

[[f:rb_load_protect]],[[f:rb_eval_string_protect]],[[f:rb_protect]]
などで捕捉した大域脱出を再生成します。

tagには上記関数の引数で受け取ったstateを指定します。

--- void rb_load(VALUE fname, int wrap)

参考: [[ruby-list:21651]]

組込み関数 [[m:Kernel.#load]] の低レベルインタフェースです。Rubyスクリ
プトが格納されたファイルfname をロードします。

引数wrapが、non-zeroなら無名のモジュールを生成して、ロー
ドした内容をそのモジュールに閉じ込めます。閉じ込めるのは

  * 定数
  * クラス、モジュール
  * トップレベルメソッド

です。グローバル変数の変更などは閉じ込められません。

--- void rb_load_protect(VALUE fname, int wrap, int *state)

--- static void rb_longjmp(int tag, VALUE mesg)

--- void rb_mark_end_proc(void)

--- int rb_method_boundp(VALUE klass, ID id, int ex)

--- static VALUE rb_mod_alias_method(VALUE mod, VALUE newname, VALUE oldname)

--- static VALUE rb_mod_append_features(VALUE module, VALUE include)

--- static VALUE rb_mod_define_method(int argc, VALUE *argv, VALUE mod)

--- static VALUE rb_mod_extend_object(VALUE mod, VALUE obj)

--- static VALUE rb_mod_include(int argc, VALUE *argv, VALUE module)

--- static VALUE rb_mod_method(VALUE mod, VALUE vid)

--- static VALUE rb_mod_method_defined(VALUE mod, VALUE mid)

--- static VALUE rb_mod_modfunc(int argc, VALUE *argv, VALUE module)

--- VALUE rb_mod_module_eval(int argc, VALUE *argv, VALUE mod)

Module#module_eval の実体です。

--- static VALUE rb_mod_nesting(void)

--- static VALUE rb_mod_private(int argc, VALUE *argv, VALUE module)

--- static VALUE rb_mod_private_method(int argc, VALUE *argv, VALUE obj)

--- static VALUE rb_mod_protected(int argc, VALUE *argv, VALUE module)

--- static VALUE rb_mod_public(int argc, VALUE *argv, VALUE module)

--- static VALUE rb_mod_public_method(int argc, VALUE *argv, VALUE obj)

--- static VALUE rb_mod_remove_method(VALUE mod, VALUE name)

Module#remove_method の実体。

モジュール mod から name という名前のメソッドを
検索し、エントリを削除します。見付からなかったときは
例外 [[c:NameError]] が発生します。

--- static VALUE rb_mod_s_constants(void)

--- static VALUE rb_mod_undef_method(VALUE mod, VALUE name)

--- void rb_obj_call_init(VALUE obj, int argc, VALUE *argv)

オブジェクト obj に対して initialize を呼び出します。
引数は長さ argc の配列 argv で表され、
ブロックが積んである場合はそれも自動的に渡されます。

--- static VALUE rb_obj_extend(int argc, VALUE *argv, VALUE obj)

--- VALUE rb_obj_instance_eval(int argc, VALUE *argv, VALUE self)

--- static VALUE rb_obj_is_block(VALUE block)

proc が Proc または Binding のインスタンスであれば真。

--- static VALUE rb_obj_is_proc(VALUE proc)

proc が Proc のインスタンスであれば真。

--- static VALUE rb_obj_method(VALUE obj, VALUE vid)

--- static VALUE rb_obj_respond_to(int argc, VALUE *argv, VALUE obj)

--- VALUE rb_proc_new(func, val)

VALUE (*func)(ANYARGS);
VALUE val;

--- VALUE rb_protect(VALUE (*proc)(), VALUE data, int *state)

初出: [[ruby-dev:4064]]

proc(data) を評価中のあらゆる大域脱出(例外を含む)を捕捉します。

  val = rb_protect(func, arg, &status);
  if (status != 0) {
      puts("大域脱出が起きた");
      rb_jump_tag(status);
  }

--- void rb_provide(const char *feature)

ライブラリ feature をロードしたものとしてロックをかけます。

--- static void rb_provide_feature(VALUE feature)

--- int rb_provided(const char *feature)

--- void rb_remove_method(VALUE klass, const char *name)

クラス klass 自体に登録されている name という名前のメソッドを
検索し、エントリを削除します。
見付からなかったときは例外 NameError を発生します。

--- VALUE rb_require(const char *fname)

require の C 版です。feature「fname」をロードします。

--- VALUE rb_rescue(VALUE (*b_proc)(), VALUE data1, VALUE (*r_proc)(), VALUE data2)

まず b_proc(data1) を実行し、その途中で例外が発生したら r_proc(data2) を実行します。
捕捉する例外は [[c:StandardError]] のサブクラスだけです。

--- VALUE rb_rescue2(VALUE (*b_proc)(), VALUE data1, VALUE (*r_proc)(), VALUE data2, ...)

まず b_proc(data1) を実行し、その途中で例外が発生したら r_proc(data2) を実行します。
第五引数以降の可変長引数に捕捉したい例外クラスのリストを指定します。
引数の最後は NULL で終らなければなりません。

--- int rb_respond_to(VALUE obj, ID id)

obj にメソッド id が定義されているとき真。
プライベートメソッドに対しても真を返します。

--- void rb_secure(int level)

現在のセーフレベルが level 以上のとき、
例外 SecurityError を発生します。

--- void rb_set_end_proc(void (*func)(VALUE), VALUE data)

--- void rb_set_safe_level(int level)

セーフレベルを level に上げます。
level が現在のセーフレベルより低い場合は
例外 SecurityError が発生します。

--- VALUE *rb_svar(int cnt)

現在の SCOPE でローカル変数IDが cnt である変数の
領域へのポインタを返します。主に [[m:$_]] (cnt=0) と [[m:$~]] (cnt=1) に
アクセスするために使われます。

--- static VALUE rb_thread_abort_exc(VALUE thread)

--- static VALUE rb_thread_abort_exc_set(VALUE thread, VALUE val)

--- static VALUE rb_thread_alive_p(VALUE thread)

--- static rb_thread_t rb_thread_alloc(VALUE klass)

--- int rb_thread_alone(void)

評価器にスレッドが一つしか存在しないとき真。

--- static VALUE rb_thread_aref(VALUE thread, VALUE id)

--- static VALUE rb_thread_aset(VALUE thread, VALUE id, VALUE val)

--- void rb_thread_atfork(void)

--- static rb_thread_t rb_thread_check(VALUE data)

--- static void rb_thread_cleanup(void)

--- VALUE rb_thread_create(fn, arg)

VALUE (*fn)();
void *arg;

--- static VALUE rb_thread_critical_get(void)

--- static VALUE rb_thread_critical_set(VALUE obj, VALUE val)

--- VALUE rb_thread_current(void)

現在実行中のスレッドを返します。

--- static int rb_thread_dead(rb_thread_t th)

--- static void rb_thread_deadlock(void)

--- static VALUE rb_thread_exit(void)

--- void rb_thread_fd_close(int fd)

--- int rb_thread_fd_writable(int fd)

--- static VALUE rb_thread_initialize(VALUE thread, VALUE args)

--- static VALUE rb_thread_inspect(VALUE thread)

--- void rb_thread_interrupt(void)

--- static int rb_thread_join(rb_thread_t th, double limit)

--- static VALUE rb_thread_join_m(int argc, VALUE *argv, VALUE thread)

--- static VALUE rb_thread_key_p(VALUE thread, VALUE id)

--- static VALUE rb_thread_keys(VALUE thread)

--- static VALUE rb_thread_kill(VALUE thread)

--- VALUE rb_thread_list(void)

--- VALUE rb_thread_local_aref(VALUE thread, ID id)

--- VALUE rb_thread_local_aset(VALUE thread, ID id, VALUE val)

--- VALUE rb_thread_main(void)

メインスレッド (プロセスの一番最初に存在するスレッド) を返します。

--- static VALUE rb_thread_pass(void)

Thread#pass の実体。

--- void rb_thread_polling(void)

--- static VALUE rb_thread_priority(VALUE thread)

--- static VALUE rb_thread_priority_set(VALUE thread, VALUE prio)

--- static VALUE rb_thread_raise(int argc, VALUE *argv, rb_thread_t th)

--- static VALUE rb_thread_raise_m(int argc, VALUE *argv, VALUE thread)

--- static void rb_thread_ready(rb_thread_t th)

--- static void rb_thread_remove(rb_thread_t th)

--- static void rb_thread_restore_context(rb_thread_t th, int exit)

スレッドを切り替えるにあたって、切り替え先のスレッド th の
コンテキストを評価器に復帰します。

--- VALUE rb_thread_run(VALUE thread)

スレッド thread に実行権を渡します。

--- static VALUE rb_thread_s_abort_exc(void)

--- static VALUE rb_thread_s_abort_exc_set(VALUE self, VALUE val)

--- static VALUE rb_thread_s_kill(VALUE obj, VALUE th)

--- static VALUE rb_thread_s_new(int argc, VALUE *argv, VALUE klass)

--- static VALUE rb_thread_safe_level(VALUE thread)

--- static void rb_thread_save_context(rb_thread_t th)

スレッドを切り替えるにあたって、現在実行中のスレッド th の
コンテキストを評価器から th に退避します。

--- void rb_thread_schedule(void)

他のスレッドに実行権を渡します。
対象の特定はできません。

see also: [[f:rb_thread_wait_fd]], [[f:rb_thread_wait_for]]

--- int rb_thread_select(int max, fd_set *read, fd_set *write, fd_set *except, struct timeval *timeout)

Ruby のスレッドは実装のために内部で select(2) を使っているため、
拡張ライブラリ内で独自に select(2) を使った場合の動作は保証されません。
代わりにこの関数 rb_thread_select を使ってください。
引数の意味は select(2) と同じです。

--- void rb_thread_signal_raise(char *sig)

--- void rb_thread_sleep(int sec)

--- void rb_thread_sleep_forever(void)

--- static VALUE rb_thread_start(VALUE klass, VALUE args)

--- static VALUE rb_thread_start_0(VALUE (*fn)(), void *arg, rb_thread_t th_arg)

--- void rb_thread_start_timer(void)

setitimer(2) が存在する場合のみ定義されます。

Ruby のスレッドスケジューリングに使用している
インターバルタイマーを開始します。

--- static VALUE rb_thread_status(VALUE thread)

--- VALUE rb_thread_stop(void)

現在実行中のスレッドを停止します。
他のスレッドから rb_thread_wakeup を呼ばれると再開します。

--- static VALUE rb_thread_stop_p(VALUE thread)

--- void rb_thread_stop_timer(void)

setitimer(2) が存在する場合のみ定義されます。

Ruby のスレッドスケジューリングに使用しているインターバルタイマーを
停止します。このタイマーが止まると Ruby のスレッド機構は基本的に停止
しますので注意してください。

--- void rb_thread_trap_eval(VALUE cmd, int sig)

--- static VALUE rb_thread_value(VALUE thread)

--- void rb_thread_wait_fd(int fd)

ファイルディスクリプタ fd を読み込めるようになるまで
カレントスレッドを停止します。

--- void rb_thread_wait_for(struct timeval time)

time の長さの時間が経過するまでカレントスレッドを停止します。

--- static void rb_thread_wait_other_threads(void)

--- VALUE rb_thread_wakeup(VALUE thread)

停止中のスレッド thread を再開させます。

--- static VALUE rb_thread_yield(VALUE arg, rb_thread_t th)

--- void rb_throw(const char *tag, VALUE val)

throw の実体。返り値を val として、
tag を catch したところまでジャンプします。

rb_catch も参照してください。

--- static VALUE rb_trap_eval(VALUE cmd, int sig)

--- void rb_undef(VALUE klass, ID id)

クラス klass のメソッド id を undef します。

--- static VALUE rb_undefined(VALUE obj, ID id, int argc, VALUE *argv, int call_status)

--- VALUE rb_with_disable_interrupt(VALUE (*proc)(), data)

--- VALUE rb_yield(VALUE val)

yield の C 版です．val を引数にブロックを実行します．
複数の引数を与えたいときは配列に格納して渡します。

この関数を呼び出したメソッドがブロックを伴わない場合は，例外
[[c:LocalJumpError]] が発生します．

--- static VALUE rb_yield_0(VALUE val, VALUE self, VALUE klass, int pcall)

カレントブロックに val を渡して処理を移す。
そのさい self とクラスを self と klass に切り替える。
Proc の呼び出しのときは pcall=非ゼロ にしなければならない。

--- static void remove_method(VALUE klass, ID mid)

クラス klass 自体に登録されている mid という名前のメソッドを
検索し、エントリを削除します。見付からなかったときは例外 [[c:NameError]]
を発生します。

--- void ruby_finalize(void)

評価器プロセスの終了処理を行います。

--- void ruby_init(void)

評価器を初期化します。Ruby C API を呼ぶプロセスでは
前もって必ずこの関数を呼ばなければなりません。

--- void ruby_options(int argc, char **argv)

argc と argv を ruby への
コマンドラインオプションとして処理します。

--- void ruby_run(void)

ruby_eval_tree の評価を開始します。

--- void ruby_stop(int ex)

評価器プロセスを停止します。

--- static VALUE safe_getter(void)

--- static void safe_setter(VALUE val)

--- static void scope_dup(struct SCOPE *scope)

scope とその親の SCOPE 全ての local_vars を
スタックからヒープに割り当て直します。

--- static NODE *search_method(VALUE klass, ID id, VALUE *origin)

クラス klass から id という名前のメソッドエントリを検索し、
返します。見付からなければ NULL を返します。

このメソッドは undef を考慮しません。つまり m_tbl に
エントリがあるならその内容に関らず探索は成功します。

--- static void secure_visibility(VALUE self)

--- static void set_backtrace(VALUE info, VALUE bt)

--- static void set_method_visibility(VALUE self, int argc, VALUE *argv, ID ex)

--- static VALUE set_trace_func(VALUE obj, VALUE trace)

Kernel#set_trace_func の実体。
評価器に対するフック手続きを登録します。

--- static VALUE specific_eval(int argc, VALUE *argv, VALUE klass, VALUE self)

rb_obj_instance_eval と rb_mod_module_eval を共通化するための補助関数です。

--- static void stack_check(void)

--- static void stack_extend(rb_thread_t th, int exit)

--- static VALUE superclass(VALUE self, NODE *node)

クラス文のスーパークラスを表すノード node を
評価してクラスを得ます。

--- static VALUE svalue_to_avalue(VALUE v)

--- static VALUE svalue_to_mvalue(VALUE v)

--- static void terminate_process(int status, const char *mesg, int mlen)

--- static VALUE thgroup_add(VALUE group, VALUE thread)

--- static VALUE thgroup_list(VALUE group)

--- static VALUE thgroup_s_alloc(VALUE klass)

--- static void thread_free(rb_thread_t th)

--- static int thread_keys_i(ID key, VALUE value, VALUE ary)

--- static void thread_mark(rb_thread_t th)

--- static const char *thread_status_name(enum thread_status status)

--- static int thread_switch(int n)

--- static double timeofday(void)

--- static VALUE top_include(int argc, VALUE *argv)

--- static VALUE top_private(int argc, VALUE *argv)

--- static VALUE top_public(int argc, VALUE *argv)

--- static VALUE umcall(VALUE args, VALUE method)

--- static VALUE umethod_bind(VALUE method, VALUE recv)

UnboundMethod method を recv に束縛します。

--- static VALUE umethod_call(int argc, VALUE *argv, VALUE method)

--- static VALUE umethod_proc(VALUE method)

--- static VALUE umethod_unbind(VALUE obj)

--- static VALUE yield_under(VALUE under, VALUE self)

モジュール under の元のコンテキストで
ruby_block を評価します。

--- static VALUE yield_under_i(VALUE self)

yield_under の補助関数です。
