### static VALUE define_final(int argc, VALUE *argv, VALUE os)

### static void gc_sweep(void)

GC のスイープフェイズを実行します。

#%until 4.1
### static VALUE id2ref(VALUE obj, VALUE id)

ObjectSpace#_id2ref の実体。
Ruby の整数で表されたオブジェクト ID id からオブジェクトを返します。
#%end

#%until 3.4
### void Init_heap(void)
#%end

### static void init_mark_stack(void)

### static inline int is_pointer_to_heap(void *ptr)

#%until 3.1
### static void mark_locations_array(register VALUE *x, register long n)
#%end

#%until 3.4
### static void obj_free(VALUE obj)
#%end

### static VALUE os_each_obj(int argc, VALUE *argv)

### static VALUE os_obj_of(VALUE of)

#%until 4.1
### VALUE rb_data_object_alloc(VALUE klass, void *datap, RUBY_DATA_FUNC dmark, RUBY_DATA_FUNC dfree)

datap をラップするオブジェクトを生成し、返します。
そのクラスは klass となり、datap をマークするときは
dmark、解放するときは dfree を使うようになります。

Ruby 4.1 で削除されました。[feature:21768]
#%end

### void rb_gc(void)

明示的に GC を開始します。rb_gc_disable() で禁止中のときおよびすでに GC が実行中のときは実際には行われません。

#%until 3.2
### void rb_gc_call_finalizer_at_exit(void)
#%end

### VALUE rb_gc_disable(void)

GC を禁止します。

### VALUE rb_gc_enable(void)

GC を許可します。

#%until 4.1
### void rb_gc_force_recycle(VALUE p)

p を強制的に GC します。

Ruby 4.1 で削除されました。[feature:21768]
#%end

### void rb_gc_mark(VALUE v)

v をマークします。

#%since 3.4
### void rb_gc_mark_children(VALUE ptr)

v から指されているオブジェクトを全てマークします。
#%end

### void rb_gc_mark_locations(VALUE *start, VALUE *end)

### void rb_gc_mark_maybe(VALUE v)

v が Ruby のオブジェクトであればマークします。

### void rb_gc_register_address(VALUE *addr)

#%# 初出: [ruby-list:20488] 1.5 feature

ポインタ addr が指す変数を GC の対象にします。

#%since 4.1
`addr` は呼び出した [c:Ractor] に登録され、その [c:Ractor] の GC だけが格納されたオブジェクトをマークします。
どの [c:Ractor] からでも登録できますが、`*addr` に格納できる値は、特別な定数、shareable なオブジェクト、登録した [c:Ractor] が所有する unshareable なオブジェクトに限ります。
他の [c:Ractor] の unshareable なオブジェクトを格納すると、`addr` が参照したままオブジェクトが解放され、use-after-free になることがあります。
プロセスと同じ寿命のアドレス (static な `VALUE`) は、main [c:Ractor] から登録するか、shareable な値だけを格納してください。
登録した [c:Ractor] が [m:Ractor#value] で join されると、残りの登録は join した [c:Ractor] に移ります。
そうでなければ、その [c:Ractor] が回収されたときに main [c:Ractor] に移ります。
[feature:22277]
#%end

### VALUE rb_gc_start(void)

GC を起動します。

### void rb_gc_unregister_address(VALUE *addr)

#%# 初出: [ruby-list:20488] [1.5 feature]

ポインタ addr が指す変数を GC の対象から外します。

### void rb_global_variable(VALUE *var)

[f:rb_gc_register_address] と同じです。

#%since 4.1
[c:Ractor] ごとの登録の扱いについても [f:rb_gc_register_address] を参照してください。
#%end

### void rb_mark_hash(st_table *tbl)

### void rb_mark_tbl(st_table *tbl)

### void rb_memerror(void)

NoMemoryErrorをraiseする。
しかしraise自体にもメモリ容量を使うため、メモリが足りない状況ではその途中でまたメモリ不足になる可能性がある。そのためこの関数では再帰を検出した場合はraiseではなくexitするようになっている。

### VALUE rb_newobj(void)

未使用のオブジェクト領域一つへのポインタを返す。
返り値が返ってきたときは失敗はない。

### int ruby_stack_check(void)

### size_t ruby_stack_length(VALUE **p)

### void *ruby_xcalloc(size_t n, size_t size)

引数と返り値は calloc() と同じです。
ただしメモリ割り当てに失敗したときは
GC を行いそれでもだめなときは例外 NoMemoryError を発生します。
つまりこの関数が返り値を返したときは常に割り当ては成功です。

### void ruby_xfree(void *x)

以前 malloc/calloc/realloc して free していないポインタ x を開放します。ruby のシグナル機構とコンフリクトしません。

### void *ruby_xmalloc(size_t size)

引数と返り値は malloc() と同じ。
ただしメモリ割り当てに失敗したときは
GC を行いそれでもだめなときは NoMemoryError を raise する。
つまりこの関数が返り値を返したときは常に割り当ては成功している。

### void *ruby_xrealloc(void *ptr, size_t size)

引数と返り値の意味は realloc() と同じ。
ただしメモリ割り当てに失敗したときは
GC を行いそれでもだめなときは NoMemoryError を raise する。
つまりこの関数が返り値を返したときは常に割り当ては成功している。

#%since 4.1
### void ruby_xfree_sized(void *ptr, size_t size)

[f:ruby_xfree] と同じですが、確保したときの大きさ `size` を受け取ります。
C23 の `free_sized` に倣った関数で、GC がメモリ使用量をより正確に追跡できます。
`size` は `ptr` を確保したときの大きさと正確に一致していなければならず、誤った大きさを渡すと未定義動作になり、クラッシュやメモリリークを起こすことがあります。
[feature:21861]

### void *ruby_xrealloc_sized(void *ptr, size_t newsiz, size_t oldsiz)

[f:ruby_xrealloc] と同じですが、現在の大きさ `oldsiz` を受け取ります。
`oldsiz` は `ptr` を確保したときの大きさと正確に一致していなければならず、誤った大きさを渡すと未定義動作になります。
[feature:21861]

### void *ruby_xrealloc2_sized(void *ptr, size_t newelems, size_t newsiz, size_t oldelems)

`ruby_xrealloc2` と同じですが、現在の要素数 `oldelems` を受け取ります。
`oldelems` は `ptr` を確保したときの要素数と正確に一致していなければならず、誤った大きさを渡すと未定義動作になります。
[feature:21861]
#%end

### static void run_final(VALUE obj)

obj のファイナライズを行います。

#%until 3.4
### static VALUE run_single_final(VALUE *args)
#%end

### static VALUE undefine_final(VALUE os, VALUE obj)
