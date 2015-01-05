--- VALUE rb_ary_new()

空の Ruby の配列を作成し返します。

対応するRubyコード

  ary = Array.new または
  ary = []

使用例

  VALUE ary;
  ary = rb_ary_new();

--- VALUE rb_ary_new2(long len)

長さ len 分だけメモリを確保した、
長さゼロの Ruby の配列を作成し返します。

対応するRubyコード

  ary = Array.new(len)

使用例

  VALUE ary;
  long len;
  ...
  ary = rb_ary_new2(len);

--- VALUE rb_ary_new3(long n, ...)

可変長引数を要素とした
長さ n の Ruby の配列を作成し返します。

対応するRubyコード

  ary = Array[i0, i1, i2...] または
  ary = [i0, i1, i2...]

使用例

  VALUE ary;
  int i[3] = { 1, 2, 3 };
  ary = rb_ary_new3(3, INT2FIX(i[0]), INT2FIX(i[1]), INT2FIX(i[2]));

--- VALUE rb_assoc_new(VALUE a, VALUE b)

[a,b] を返します。

対応するRubyコード

  [a, b]

使用例

  VALUE assoc_string(VALUE str_a, VALUE str_b)
  {
    Check_Type(str_a, T_STRING);
    Check_Type(str_b, T_STRING);
    return rb_assoc_new(str_a, str_b);
  }

--- VALUE rb_ary_entry(VALUE ary, long offset)

ary のインデックス offset の要素を返します。

インデックスが範囲を越えるときは Qnil を返します。
負のインデックスも使えます。

対応するRubyコード

  ary[offset] または
  ary.at(offset)

使用例

  VALUE num;
  num = rb_ary_entry(ary, offset); 
  printf("%d\n", FIX2INT(num));

  キャストを使った要素の参照方法
  
  VALUE num = RARRAY(ary)->ptr[offset];

--- VALUE rb_ary_aref(int argc, VALUE *argv, VALUE ary)

argc が 1 のときは ary[*argv]、
2 のときは ary[argv[0], argv[1]] を返します。

--- void rb_ary_store(VALUE ary, long idx, VALUE val)

配列 ary のインデックス idx に
val を格納します。idx が範囲を越えるときは
Ruby レベルと同じく自動的にサイズが拡張されます。

対応するRubyコード

  ary[idx] = val

使用例

  VALUE ary;
  int idx;
  int n[5] = { 1, 2, 3, 4, 5 };
  ary = rb_ary_new();
  for (idx=0; idx<5; idx++) rb_ary_store(ary, idx, INT2FIX(n[idx])); 

--- VALUE rb_ary_push(VALUE ary, VALUE item)

配列 ary の末尾に item を追加します。

対応するRubyコード

  ary.push(item) または
  ary << item

使用例

  VALUE ary = rb_ary_new();
  char line[4096];
  while ((gets(line)) != NULL){
    item = process_apache_log(line);
    rb_ary_push(ary, item);
  }

--- VALUE rb_ary_pop(VALUE ary)

配列 ary の末尾の要素をとりのぞき返します。
空配列のときは Qnil を返します。

対応するRubyコード

  val = ary.pop

使用例

  last_error = rb_ary_pop(err_ary);
  VALUE str = rb_funcall(last_error, rb_intern("to_s"), 0);

--- VALUE rb_ary_shift(VALUE ary)

配列 ary の先頭の要素を取り除き返します。
空配列のときは Qnil を返します。

対応するRubyコード

  val = ary.shift

--- VALUE rb_ary_unshift(VALUE ary, VALUE item)

配列 ary の先頭に item を挿入します。

--- VALUE rb_ary_to_s(VALUE ary)

ary.to_s

使用例

  void debug_print(VALUE ary)
  {
    Check_Type(ary, T_ARRAY);
    printf("%s", STR2CSTR(rb_ary_to_s(ary)));
  }

--- VALUE rb_ary_sort(VALUE ary)

ary.sort

--- VALUE rb_ary_includes(ary, item)

ary.include? item

--- VALUE rb_ary_delete(VALUE ary, VALUE item)

ary.delete

--- VALUE rb_ary_clear(VALUE ary)

ary.clear

--- VALUE rb_ary_concat(VALUE ary, VALUE x)

ary.concat x
