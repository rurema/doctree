### VALUE rb_any_to_s(VALUE obj)

[m:Object#to_s] の実体です。

### VALUE rb_Array(VALUE obj)

obj が Array でない場合は to_a を使って
Array に変換します。

### VALUE rb_check_convert_type(VALUE val, int type, const char *tname, const char *method)

val.method を実行してクラス tname のインスタンスを返します。
val がメソッド method を持たなければ nil を返します。

type は、T_ARRAY, T_STRING などの構造体を表す ID です。
method の結果の型が type でなければ例外 TypeError が発生します。

### VALUE rb_class_new_instance(int argc, VALUE *argv, VALUE klass)

[m:Class#new] の実体です。

### VALUE rb_class_real(VALUE cl)

特異クラスや化身クラス (T_ICLASS) を飛ばして cl のスーパークラスを辿り、Ruby レベルに露出してもよいクラスを返します。

```c title="例"
rb_class_real(RBASIC(klass)->super)
```

rb_obj_class(obj) は、obj のクラスを返す汎用の関数(Object#type と同じ)だが、obj が Qtrue などでない RBasic 構造のものであることがわかっているなら

```c
rb_class_real(RBASIC(obj)->klass)
```

でも良い。(が、やはり rb_obj_class(obj) を使う方が無難だろう)

### VALUE rb_class_superclass(VALUE klass)

### VALUE rb_convert_type(VALUE val, int type, const char *tname, const char *method)

オブジェクト val をクラス type のインスタンスに変換します。
変換には、val.method の戻り値が使われます。

val がもともと type クラスのインスタンスなら val をそのまま返します。

### double rb_cstr_to_dbl(const char *p, int badcheck)

### int rb_eql(VALUE obj1, VALUE obj2)

obj1.equal?(obj2) ならば Qtrue、そうでないならば Qfalse。

### VALUE rb_equal(VALUE obj1, VALUE obj2)

obj1 == obj2 ならば Qtrue、そうでないならば Qfalse。

### VALUE rb_Float(VALUE val)

### VALUE rb_inspect(VALUE obj)

obj.inspect の実体。

### VALUE rb_Integer(VALUE obj)

obj が Ruby の整数でない場合は to_i を使って
Integer に変換します。

### double rb_num2dbl(VALUE val)

任意の Numeric のオブジェクトを double に変換します。

### VALUE rb_obj_alloc(VALUE klass)

klass のインスタンスを作成する。

### VALUE rb_obj_class(VALUE obj)

[m:Object#class] の実体です。

### VALUE rb_obj_clone(VALUE obj)

[m:Object#clone] の実体です。

### VALUE rb_obj_dup(VALUE obj)

[m:Object#dup] の実体です。

Cのソースコード上でオブジェクトの複製を作成して返します。

```c title="例"
VALUE 
return_copy(VALUE arg) 
{
    VALUE copy = rb_obj_dup(arg); // 引数で受け取ったオブジェクトを複製し、copyに代入。
    return copy;
}
```

### VALUE rb_obj_freeze(VALUE obj)

[m:Object#freeze]

### VALUE rb_obj_frozen_p(VALUE obj)

[m:Object#frozen?]

### VALUE rb_obj_id(VALUE obj)

[m:Object#object_id] の実体です。

### VALUE rb_obj_is_instance_of(VALUE obj, VALUE klass)

obj がクラス klass のインスタンスならば真。

### VALUE rb_obj_is_kind_of(VALUE obj, VALUE klass)

obj がクラス klass およびそのサブクラスのインスタンスのとき真。

#%until 3.2
### VALUE rb_obj_taint(VALUE obj)

[m:Object#taint]
#%end

#%until 3.2
### VALUE rb_obj_tainted(VALUE obj)

[m:Object#tainted?]
#%end

#%until 3.2
### VALUE rb_obj_untaint(VALUE obj)

[m:Object#untaint]
#%end

### double rb_str_to_dbl(VALUE str, int badcheck)

### VALUE rb_String(VALUE val)

[m:Kernel?.String] の実体です。
val を文字列に変換します。

### ID rb_to_id(VALUE name)

String・Fixnum・Symbol を ID に変換します。

### VALUE rb_to_int(VALUE val)

val を to_int メソッドを使って Ruby の整数に変換します。

#%until 3.1
### VALUE rb_sym_interned_p(VALUE sym)
#%end
