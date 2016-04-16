--- static VALUE add_final(VALUE os, VALUE proc)

--- static void add_heap(void)

Rubyオブジェクトのヒープスロットを増設する。

--- static VALUE call_final(VALUE os, VALUE obj)

--- static VALUE define_final(int argc, VALUE *argv, VALUE os)

--- static VALUE finals(void)

--- static void gc_mark_all(void)

--- static void gc_mark_rest(void)

--- static void gc_sweep(void)

GC のスイープフェイズを実行します。

--- static VALUE id2ref(VALUE obj, VALUE id)

ObjectSpace#_id2ref の実体。
Ruby の整数で表されたオブジェクト ID id から
オブジェクトを返します。

--- void Init_heap(void)

--- static void init_mark_stack(void)

--- void Init_stack(VALUE *addr)

--- static inline int is_pointer_to_heap(void *ptr)

--- static int mark_entry(ID key, VALUE value)

--- static int mark_hashentry(VALUE key, VALUE value)

--- static void mark_locations_array(register VALUE *x, register long n)

--- static void mark_source_filename(char *f)

--- static void obj_free(VALUE obj)

--- static VALUE os_each_obj(int argc, VALUE *argv)

--- static VALUE os_live_obj(void)

--- static VALUE os_obj_of(VALUE of)

--- VALUE rb_data_object_alloc(VALUE klass, void *datap, RUBY_DATA_FUNC dmark, RUBY_DATA_FUNC dfree)

datap をラップするオブジェクトを生成し、返します。
そのクラスは klass となり、datap をマークするときは
dmark、解放するときは dfree を使うようになります。

--- VALUE rb_gc(void)

明示的に GC を開始します。rb_gc_disable() で禁止中のときおよび
すでに GC が実行中のときは実際には行われません。

--- void rb_gc_call_finalizer_at_exit(void)

--- VALUE rb_gc_disable(void)

GC を禁止します。

--- VALUE rb_gc_enable(void)

GC を許可します。

--- void rb_gc_force_recycle(VALUE p)

p を強制的に GC します。

--- void rb_gc_mark(VALUE v)

v をマークします。

--- void rb_gc_mark_children(VALUE ptr)

v から指されているオブジェクトを全てマークします。

--- void rb_gc_mark_frame(struct FRAME *frame)

frame をマークします。

--- void rb_gc_mark_locations(VALUE *start, VALUE *end)

--- void rb_gc_mark_maybe(VALUE v)

v が Ruby のオブジェクトであればマークします。

--- void rb_gc_register_address(VALUE *addr)

#@# 初出: [ruby-list:20488] 1.5 feature

ポインタ addr が指す変数を GC の対象にします。

--- VALUE rb_gc_start(void)

GC を起動します。

--- void rb_gc_unregister_address(VALUE *addr)

#@# 初出: [ruby-list:20488] [1.5 feature]

ポインタ addr が指す変数を GC の対象から外します。

#@until 2.2.0
-- void rb_gc_set_params(void)

この関数は deprecated です。内部関数になりました。
#@end

--- void rb_global_variable(VALUE *var)

[[f:rb_gc_register_address]] と同じです。

--- void rb_mark_hash(st_table *tbl)

--- void rb_mark_tbl(st_table *tbl)

--- void rb_memerror(void)

NoMemoryErrorをraiseする。
しかしraise自体にもメモリ容量を使うため、メモリが足りない状況
ではその途中でまたメモリ不足になる可能性がある。そのため
この関数では再帰を検出した場合はraiseではなくexitするように
なっている。

--- VALUE rb_newobj(void)

未使用のオブジェクト領域一つへのポインタを返す。
返り値が返ってきたときは失敗はない。

--- char *rb_source_filename(const char *f)

--- static VALUE rm_final(VALUE os, VALUE proc)

--- int ruby_stack_check(void)

--- int ruby_stack_length(VALUE **p)

--- void *ruby_xcalloc(long n, long size)

引数と返り値は calloc() と同じです。
ただしメモリ割り当てに失敗したときは
GC を行いそれでもだめなときは例外 NoMemoryError を発生します。
つまりこの関数が返り値を返したときは常に割り当ては成功です。

--- void ruby_xfree(void *x)

以前 malloc/calloc/realloc して free していないポインタ x を
開放します。ruby のシグナル機構とコンフリクトしません。

--- void *ruby_xmalloc(long size)

引数と返り値は malloc() と同じ。
ただしメモリ割り当てに失敗したときは
GC を行いそれでもだめなときは NoMemoryError を raise する。
つまりこの関数が返り値を返したときは常に割り当ては成功している。

--- void *ruby_xrealloc(void *ptr, long size)

引数と返り値の意味は realloc() と同じ。
ただしメモリ割り当てに失敗したときは
GC を行いそれでもだめなときは NoMemoryError を raise する。
つまりこの関数が返り値を返したときは常に割り当ては成功している。

--- static void run_final(VALUE obj)

obj のファイナライズを行います。

--- static VALUE run_single_final(VALUE *args)

--- static enum st_retval sweep_source_filename(char *key, char *value)

--- static VALUE undefine_final(VALUE os, VALUE obj)

