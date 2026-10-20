### void rb_alias_variable(ID name1, ID name2)

#%until 3.2
### void rb_autoload(const char *klass, const char *filename)

この関数は Ruby 2.3 以降で deprecated です。[f:rb_funcall] を使用してください。
#%end

### VALUE rb_autoload_load(VALUE space, ID name)

### char *rb_class2name(VALUE klass)

klass の名前を返します。
返り値の内容を変更したり free してはいけません。

```c
RSTRING(rb_class_path(klass))->ptr
```

と同じです。

### VALUE rb_class_path(VALUE klass)

klass の名前を返します。klassが無名クラス、無名モジュールの場合 #<Class 0xXXXX>, #<Module 0xXXXX> の形式で返します。

[m:Module#to_s] の定義は

```c
rb_str_dup(rb_class_path(klass));
```

です。

### int rb_const_defined(VALUE klass, ID id)

klass とそのスーパークラスに定数 id が定義されていれば真。

### int rb_const_defined_at(VALUE klass, ID id)

klass 自体に定数 id が定義されていれば真。

### VALUE rb_const_get(VALUE klass, ID name)

定数 klass::name の値を取得します。

### VALUE rb_const_get_at(VALUE klass, ID name)

クラス klass で定義された定数 name の値を取得します
(祖先や外のクラスは調べない)。

### VALUE rb_const_list(void *data)

### void rb_const_set(VALUE klass, ID name, VALUE val)

定数 klass::name の値を val として定義します。

### void rb_copy_generic_ivar(VALUE clone, VALUE obj)

### VALUE rb_cv_get(VALUE klass, char *name)

klass のクラス変数 name の値を取得します。

### void rb_cv_set(VALUE klass, char *name, VALUE val)

klass のクラス変数 name に val を代入します。
変数がまだ定義されていない場合は NameError を発生します。

### VALUE rb_cvar_defined(VALUE klass, ID id)

### VALUE rb_cvar_get(VALUE klass, ID name)

klass のクラス変数 name の値を取得します。

### void rb_cvar_set(VALUE klass, ID name, VALUE val)

klass のクラス変数 name に val を代入します。
変数がまだ定義されていない場合は NameError を発生します。

### void rb_define_class_variable(VALUE klass, const char *name, VALUE val)

クラス klass のクラス変数 name を初期値 val で定義します。既に同名の変数が定義されていたら警告します。

### void rb_define_const(VALUE klass, const char *name, VALUE val)

クラス klass の定数 name を初期値 val で定義します。既に同名の定数が定義されていたら警告します。

### void rb_define_global_const(const char *name, VALUE val)

トップレベル (現在は [c:Object]) の定数 name を初期値 val で定義します。既に同名の定数が定義されていたら警告します。

### void rb_define_hooked_variable(const char *name, VALUE *var, rb_gvar_getter_t *getter, rb_gvar_setter_t *setter)

### void rb_define_readonly_variable(const char *name, VALUE *var)

### void rb_define_variable(const char *name, VALUE *var)

### void rb_define_virtual_variable(const char *name, rb_gvar_getter_t *getter, rb_gvar_setter_t *setter)

### VALUE rb_f_global_variables(void)

### VALUE rb_f_trace_var(int argc, VALUE *argv)

### VALUE rb_f_untrace_var(int argc, VALUE *argv)

### void rb_free_generic_ivar(VALUE obj)

### VALUE rb_gv_get(const char *name)
#%# [1.5 feature]

Ruby のグローバル変数の値を取得します。

```c title="使用例"
VALUE v = rb_gv_get("$!")
```

### VALUE rb_gv_set(const char *name, VALUE val)
#%# [1.5 feature]

Ruby のグローバル変数 name に val を代入します。
val を返します。

### VALUE rb_iv_get(VALUE obj, char *name)

オブジェクト obj のインスタンス変数 name の値を取得します。

### VALUE rb_iv_set(VALUE obj, char *name, VALUE val)

オブジェクト obj のインスタンス変数 name に
val を代入します。

### VALUE rb_ivar_defined(VALUE obj, ID id)

オブジェクト obj のインスタンス変数 name が定義されていれば真。

### VALUE rb_ivar_get(VALUE obj, ID name)

オブジェクト obj のインスタンス変数 name の値を取得します。

### VALUE rb_ivar_set(VALUE obj, ID name, VALUE val)

オブジェクト obj のインスタンス変数 name に
val を代入します。

### VALUE rb_mod_class_variables(int argc, const VALUE *argv, VALUE mod)

### void *rb_mod_const_at(VALUE mod, void *data)

### void *rb_mod_const_of(VALUE mod, void *data)

### VALUE rb_mod_constants(int argc, const VALUE *argv, VALUE mod)

### VALUE rb_mod_name(VALUE mod)

[m:Module#name] の実体です。
無名クラス、無名モジュールに対しては空文字列を返します。

### VALUE rb_mod_remove_const(VALUE mod, VALUE name)

### VALUE rb_mod_remove_cvar(VALUE mod, VALUE name)

### VALUE rb_obj_instance_variables(VALUE obj)

### VALUE rb_obj_remove_instance_variable(VALUE obj, VALUE name)

### VALUE rb_path2class(const char *path)

### void rb_set_class_path(VALUE klass, VALUE under, const char *name)
