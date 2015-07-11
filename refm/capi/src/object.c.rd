--- static VALUE boot_defclass(char *name, VALUE super)

(まだ) メタクラスを持たないクラスを作成します。
三つのメタオブジェクト Object, Module, Class を
作成するのに使います。

--- static VALUE convert_type(VALUE val, const char *tname, const char *method, int raise)

--- static int inspect_i(ID id, VALUE value, VALUE str)

--- static VALUE inspect_obj(VALUE obj, VALUE str)

--- VALUE rb_any_to_s(VALUE obj)

[[m:Object#to_s]] の実体です。

--- VALUE rb_Array(VALUE obj)

obj が Array でない場合は to_a を使って
Array に変換します。

--- VALUE rb_check_convert_type(VALUE val, int type, const char *tname, const char *method)

val.method を実行してクラス tname のインスタンスを返します。
val がメソッド method を持たなければ nil を返します。

type は、T_ARRAY, T_STRING などの構造体を表す ID です。
method の結果の型が type でなければ例外 TypeError が発生します。

--- static VALUE rb_class_allocate_instance(VALUE klass)

[[m:Class#allocate]] の実体です。

--- static VALUE rb_class_initialize(int argc, VALUE *argv, VALUE klass)

[[m:Class#initialize]] の実体です。

--- VALUE rb_class_new_instance(int argc, VALUE *argv, VALUE klass)

[[m:Class#new]] の実体です。

--- VALUE rb_class_real(VALUE cl)

特異クラスや化身クラス (T_ICLASS) を飛ばして cl の
スーパークラスを辿り、Ruby レベルに露出してもよいクラスを返します。

例:
   rb_class_real(RBASIC(klass)->super)

rb_obj_class(obj) は、obj のクラスを返す汎用の関数(Object#type と
同じ)だが、obj が Qtrue などでない RBasic 構造のものであることが
わかっているなら

    rb_class_real(RBASIC(obj)->klass)

でも良い。(が、やはり rb_obj_class(obj) を使う方が無難だろう)

--- static VALUE rb_class_s_new(int argc, VALUE *argv)

--- static VALUE rb_class_superclass(VALUE klass)

--- VALUE rb_convert_type(VALUE val, int type, const char *tname, const char *method)

オブジェクト val をクラス type のインスタンスに変換します。
変換には、val.method の戻り値が使われます。

val がもともと type クラスのインスタンスなら val を
そのまま返します。

--- double rb_cstr_to_dbl(const char *p, int badcheck)

--- VALUE rb_eql(VALUE obj1, VALUE obj2)

obj1.equal?(obj2) ならば Qtrue、
そうでないならば Qfalse。

--- VALUE rb_equal(VALUE obj1, VALUE obj2)

obj1 == obj2 ならば Qtrue、
そうでないならば Qfalse。

--- static VALUE rb_f_array(VALUE obj, VALUE arg)

[[m:Kernel.#Array]] の実体です。

--- static VALUE rb_f_float(VALUE obj, VALUE arg)

[[m:Kernel.#Float]] の実体です。

--- static VALUE rb_f_integer(VALUE obj, VALUE arg)

[[m:Kernel.#Integer]] の実体です。

--- static VALUE rb_f_string(VALUE obj, VALUE arg)

[[m:Kernel.#String]] の実体です。

#@# #@since 2.0.0
#@# --- static VALUE rb_f_hash(VALUE obj, VALUE arg)
#@#
#@# [[m:Kernel.#Hash]] の実体です。
#@# #@end

--- static VALUE rb_false(VALUE obj)

[[m:Object#nil?]] の実体です。

--- VALUE rb_Float(VALUE val)

--- VALUE rb_inspect(VALUE obj)

obj.inspect の実体。

--- VALUE rb_Integer(VALUE obj)

obj が Ruby の整数でない場合は to_i を使って
Integer に変換します。

--- static VALUE rb_mod_attr(int argc, VALUE *argv, VALUE klass)

--- static VALUE rb_mod_attr_accessor(int argc, VALUE *argv, VALUE klass)

--- static VALUE rb_mod_attr_reader(int argc, VALUE *argv, VALUE klass)

--- static VALUE rb_mod_attr_writer(int argc, VALUE *argv, VALUE klass)

--- static VALUE rb_mod_cmp(VALUE mod, VALUE arg)

--- static VALUE rb_mod_const_defined(VALUE mod, VALUE name)

--- static VALUE rb_mod_const_get(VALUE mod, VALUE name)

--- static VALUE rb_mod_const_set(VALUE mod, VALUE name, VALUE value)

--- static VALUE rb_mod_eqq(VALUE mod, VALUE arg)

--- static VALUE rb_mod_ge(VALUE mod, VALUE arg)

--- static VALUE rb_mod_gt(VALUE mod, VALUE arg)

--- static VALUE rb_mod_initialize(VALUE module)

--- static VALUE rb_mod_le(VALUE mod, VALUE arg)

--- static VALUE rb_mod_lt(VALUE mod, VALUE arg)

--- static VALUE rb_mod_to_s(VALUE klass)

--- static VALUE rb_module_s_alloc(VALUE klass)

--- double rb_num2dbl(VALUE val)

任意の Numeric のオブジェクトを double に変換します。

--- VALUE rb_obj_alloc(VALUE klass)

klass のインスタンスを作成する。

--- VALUE rb_obj_class(VALUE obj)

[[m:Object#class]] の実体です。

--- VALUE rb_obj_clone(VALUE obj)

[[m:Object#clone]] の実体です。

--- static VALUE rb_obj_dummy(void)

--- VALUE rb_obj_dup(VALUE obj)

[[m:Object#dup]] の実体です。

--- static VALUE rb_obj_equal(VALUE obj1, VALUE obj2)

obj1 と obj2 が同一のオブジェクトなら真。

--- VALUE rb_obj_freeze(VALUE obj)

[[m:Object#freeze]]

--- VALUE rb_obj_frozen_p(VALUE obj)

[[m:Object#frozen?]]

--- VALUE rb_obj_id(VALUE obj)

[[m:Object#object_id]] の実体です。

--- static VALUE rb_obj_inspect(VALUE obj)

[[m:Object#inspect]] の実体です。

--- VALUE rb_obj_is_instance_of(VALUE obj, VALUE klass)

obj がクラス klass のインスタンスならば真。

--- VALUE rb_obj_is_kind_of(VALUE obj, VALUE klass)

obj がクラス klass およびそのサブクラスの
インスタンスのとき真。

--- static VALUE rb_obj_methods(VALUE obj)

[[m:Object#methods]] の実体です。

--- static VALUE rb_obj_private_methods(VALUE obj)

[[m:Object#private_methods]] の実体です。

--- static VALUE rb_obj_protected_methods(VALUE obj)

[[m:Object#protected_methods]] の実体です。

--- VALUE rb_obj_taint(VALUE obj)

[[m:Object#taint]]

--- VALUE rb_obj_tainted(VALUE obj)

[[m:Object#tainted?]]

--- VALUE rb_obj_untaint(VALUE obj)

[[m:Object#untaint]]

#@if (version <= "1.9.1")
--- char *rb_str2cstr(VALUE str, int *len)

strl を C の文字列に変換します。第二引数も与えると
*len にバイト長を書き込みます。str が String
でない場合は to_str での変換を試みます。
#@end

--- double rb_str_to_dbl(VALUE str, int badcheck)

--- VALUE rb_String(VALUE val)

[[m:Kernel.#String]] の実体です。
val を文字列に変換します。

--- VALUE rb_to_id(VALUE name)

String・Fixnum・Symbol を ID に変換します。

--- VALUE rb_to_int(VALUE val)

val を to_int メソッドを使って Ruby の整数に変換します。

--- static VALUE rb_to_integer(VALUE val, char *method)

--- static VALUE rb_true(VALUE obj)

Qtrue を返します。

--- static VALUE rb_sym_interned_p(VALUE sym)
