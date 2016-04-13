--- static int autoload_i(ID key, const char *name, st_table *tbl)

--- static VALUE classname(VALUE klass)

--- static int cv_i(ID key, VALUE value, VALUE ary)

--- static void cvar_override_check(VALUE id, VALUE a)

--- static int fc_i(ID key, VALUE value, struct fc_result *res)

--- static VALUE fc_path(struct fc_result *fc, ID name)

--- static VALUE find_class_path(VALUE klass)

クラス klass のクラスパスを探索し、Ruby の文字列で返します。

--- static VALUE generic_ivar_defined(VALUE obj, ID id)

--- static VALUE generic_ivar_get(VALUE obj, ID id)

--- static int generic_ivar_remove(VALUE obj, ID id, VALUE *valp)

--- static void generic_ivar_set(VALUE obj, ID id, VALUE val)

--- static int givar_i(VALUE obj, st_table *tbl)

--- static int givar_mark_i(ID key, VALUE value)

--- static ID global_id(const char *name)

--- static int gvar_i(ID key, struct global_entry *entry, VALUE ary)

--- void Init_var_tables(void)

--- static int ivar_i(ID key, struct global_entry *entry, VALUE ary)

--- static int list_i(ID key, ID value, VALUE ary)

--- static int mark_global_entry(ID key, struct global_entry *entry)

--- static void mod_av_set(VALUE klass, ID id, VALUE val, int isconst)

--- static VALUE original_module(VALUE c)

--- void rb_alias_variable(ID name1, ID name2)

--- void rb_autoload(const char *klass, const char *filename)

この関数は 2.3.0 以降で deprecated です。[[f:rb_funcall]] を使用してください。

--- int rb_autoload_defined(ID id)

--- static void rb_autoload_id(ID id, const char *filename)

--- void rb_autoload_load(ID id)

--- char *rb_class2name(VALUE klass)

klass の名前を返します。
返り値の内容を変更したり free してはいけません。

  RSTRING(rb_class_path(klass))->ptr

と同じです。

--- VALUE rb_class_path(VALUE klass)

klass の名前を返します．klassが無名クラス、無名モジュー
ルの場合 #<Class 0xXXXX>, #<Module 0xXXXX> の形式で返します。

[[m:Module#to_s]] の定義は

  rb_str_dup(rb_class_path(klass));

です。

--- void rb_const_assign(VALUE klass, ID id, VALUE val)

--- int rb_const_defined(VALUE klass, ID id)

klass とそのスーパークラスに定数 id が定義されていれば真。

--- int rb_const_defined_at(VALUE klass, ID id)

klass 自体に定数 id が定義されていれば真。

--- VALUE rb_const_get(VALUE klass, ID name)

定数 klass::name の値を取得します。

--- VALUE rb_const_get_at(VALUE klass, ID name)

クラス klass で定義された定数 name の値を取得します
(祖先や外のクラスは調べない)。

--- VALUE rb_const_list(void *data)

--- void rb_const_set(VALUE klass, ID name, VALUE val)

定数 klass::name の値を val として定義します。

--- void rb_copy_generic_ivar(VALUE clone, VALUE obj)

--- VALUE rb_cv_get(VALUE klass, char *name)

klass のクラス変数 name の値を
取得します。

--- void rb_cv_set(VALUE klass, char *name, VALUE val)

klass のクラス変数 name に val を代入します。
変数がまだ定義されていない場合は NameError を発生します。

--- void rb_cvar_declear(VALUE klass, ID name, VALUE val)

klass のクラス変数 name に val を代入します。

--- VALUE rb_cvar_defined(VALUE klass, ID id)

--- VALUE rb_cvar_get(VALUE klass, ID name)

klass のクラス変数 name の値を
取得します。

--- void rb_cvar_set(VALUE klass, ID name, VALUE val)

klass のクラス変数 name に val を代入します。
変数がまだ定義されていない場合は NameError を発生します。

--- void rb_define_class_variable(VALUE klass, const char *name, VALUE val)

クラス klass のクラス変数 name を初期値 val で
定義します。既に同名の変数が定義されていたら警告します。

--- void rb_define_const(VALUE klass, const char *name, VALUE val)

クラス klass の定数 name を初期値 val で
定義します。既に同名の定数が定義されていたら警告します。

--- void rb_define_global_const(const char *name, VALUE val)

トップレベル (現在は [[c:Object]]) の定数 name を初期値 val で
定義します。既に同名の定数が定義されていたら警告します。

--- void rb_define_hooked_variable(const char *name, VALUE *var, VALUE (*getter)(), VALUE (*setter)())


--- void rb_define_readonly_variable(const char *name, VALUE *var)

--- void rb_define_variable(const char *name, VALUE *var)

--- void rb_define_virtual_variable(const char *name, VALUE (*getter)(), VALUE (*setter)())

--- VALUE rb_f_autoload(VALUE obj, VALUE klass, VALUE file)

--- VALUE rb_f_global_variables(void)

--- VALUE rb_f_trace_var(int argc, VALUE *argv)

--- VALUE rb_f_untrace_var(int argc, VALUE *argv)

--- void rb_free_generic_ivar(VALUE obj)

--- void rb_gc_mark_global_tbl(void)

--- st_table *rb_generic_ivar_table(VALUE obj)

--- struct global_entry *rb_global_entry(ID id)

--- VALUE rb_gv_get(const char *name)
#@# [1.5 feature]

Ruby のグローバル変数の値を取得します。

使用例

    VALUE v = rb_gv_get("$!")

--- VALUE rb_gv_set(const char *name, VALUE val)
#@# [1.5 feature]

Ruby のグローバル変数 name に val を代入します。
val を返します。

--- VALUE rb_gvar_defined(struct global_entry *entry)

entry で示されるグローバル変数が定義されているなら真。

--- VALUE rb_gvar_get(struct global_entry *entry)

グローバル変数のエントリ entry から値を取得します。

--- VALUE rb_gvar_set(struct global_entry *entry, VALUE val)

グローバル変数のエントリ entry に値を代入します。

--- VALUE rb_iv_get(VALUE obj, char *name)

オブジェクト obj のインスタンス変数 name の値を
取得します。

--- VALUE rb_iv_set(VALUE obj, char *name, VALUE val)

オブジェクト obj のインスタンス変数 name に
val を代入します。

--- VALUE rb_ivar_defined(VALUE obj, ID id)

オブジェクト obj のインスタンス変数 name が
定義されていれば真。

--- VALUE rb_ivar_get(VALUE obj, ID name)

オブジェクト obj のインスタンス変数 name の値を
取得します。

--- VALUE rb_ivar_set(VALUE obj, ID name, VALUE val)

オブジェクト obj のインスタンス変数 name に
val を代入します。

--- void rb_mark_generic_ivar(VALUE obj)

--- void rb_mark_generic_ivar_tbl(void)

--- VALUE rb_mod_class_variables(VALUE obj)

--- void *rb_mod_const_at(VALUE mod, void *data)

--- void *rb_mod_const_of(VALUE mod, void *data)

--- VALUE rb_mod_constants(VALUE mod)

--- VALUE rb_mod_name(VALUE mod)

[[m:Module#name]] の実体です。
無名クラス、無名モジュールに対しては空文字列を返します。

--- VALUE rb_mod_remove_const(VALUE mod, VALUE name)

--- VALUE rb_mod_remove_cvar(VALUE mod, VALUE name)

--- void rb_name_class(VALUE klass, ID id)

クラス klass を id と命名します。

--- VALUE rb_obj_instance_variables(VALUE obj)

--- VALUE rb_obj_remove_instance_variable(VALUE obj, VALUE name)

--- VALUE rb_path2class(const char *path)

--- void rb_set_class_path(VALUE klass, VALUE under, const char *name)

--- static void rb_trace_eval(VALUE cmd, VALUE val)

--- static void readonly_setter(VALUE val, ID id, void *var)

--- static void remove_trace(struct global_variable *var)

--- static int sv_i(ID key, VALUE value, st_table *tbl)

--- static int top_const_get(ID id, VALUE *klassp)

トップレベルの定数 id を参照します。
定数 id が定義されていたら真を返し klassp に
その値を書き込みます。未定義なら偽を返します。

--- static VALUE trace_en(struct global_variable *var)

--- static VALUE trace_ev(struct trace_data *data)

--- static VALUE undef_getter(ID id)

--- static void undef_marker(void)

--- static void undef_setter(VALUE val, ID id, void *data, struct global_variable *var)

--- static VALUE val_getter(ID id, VALUE val)

--- static void val_marker(VALUE data)

--- static void val_setter(VALUE val, ID id, void *data, struct global_variable *var)

--- static VALUE var_getter(ID id, VALUE *var)

--- static void var_marker(VALUE *var)

--- static void var_setter(VALUE val, ID id, VALUE *var)

