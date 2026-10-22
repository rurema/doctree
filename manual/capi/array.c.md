### VALUE rb_ary_new()

空の Ruby の配列を作成し返します。

```text title="対応するRubyコード"
ary = Array.new または
ary = []
```

```c title="使用例"
VALUE ary;
ary = rb_ary_new();
```

### VALUE rb_ary_new2(long len)

長さ len 分だけメモリを確保した、長さゼロの Ruby の配列を作成し返します。

```text title="対応するRubyコード"
ary = Array.new(len)
```

```c title="使用例"
VALUE ary;
long len;
...
ary = rb_ary_new2(len);
```

### VALUE rb_ary_new3(long n, VALUE i0, i1, i2, ...)

長さ n で要素に i0 i1 i2 …を格納した
Ruby の配列を作成し返します。

```text title="対応するRubyコード"
ary = Array[i0, i1, i2...] または
ary = [i0, i1, i2...]
```

```c title="使用例"
VALUE ary;
int i[3] = { 1, 2, 3 };
ary = rb_ary_new3(3, INT2FIX(i[0]), INT2FIX(i[1]), INT2FIX(i[2]));
```

### VALUE rb_assoc_new(VALUE a, VALUE b)

[a,b] を返します。

```text title="対応するRubyコード"
[a, b]
```

```c title="使用例"
VALUE assoc_string(VALUE str_a, VALUE str_b)
{
  Check_Type(str_a, T_STRING);
  Check_Type(str_b, T_STRING);
  return rb_assoc_new(str_a, str_b);
}
```

#%since 4.1
### VALUE rb_ary_entry(VALUE ary, rb_len_t offset)
#%else
### VALUE rb_ary_entry(VALUE ary, long offset)
#%end

ary のインデックス offset の要素を返します。

インデックスが範囲を越えるときは Qnil を返します。
負のインデックスも使えます。

```text title="対応するRubyコード"
ary[offset] または
ary.at(offset)
```

```c title="使用例"
VALUE num;
num = rb_ary_entry(ary, offset); 
printf("%d\n", FIX2INT(num));

キャストを使った要素の参照方法
  
VALUE num = RARRAY(ary)->ptr[offset];
```

### VALUE rb_ary_aref(int argc, VALUE *argv, VALUE ary)

argc が 1 のときは ary[*argv]、
2 のときは ary[argv[0], argv[1]] を返します。

#%since 4.1
### void rb_ary_store(VALUE ary, rb_len_t idx, VALUE val)
#%else
### void rb_ary_store(VALUE ary, long idx, VALUE val)
#%end

配列 ary のインデックス idx に
val を格納します。idx が範囲を越えるときは
Ruby レベルと同じく自動的にサイズが拡張されます。

```text title="対応するRubyコード"
ary[idx] = val
```

```c title="使用例"
VALUE ary;
int idx;
int n[5] = { 1, 2, 3, 4, 5 };
ary = rb_ary_new();
for (idx=0; idx<5; idx++) rb_ary_store(ary, idx, INT2FIX(n[idx])); 
```

### VALUE rb_ary_push(VALUE ary, VALUE item)

配列 ary の末尾に item を追加します。

```text title="対応するRubyコード"
ary.push(item) または
ary << item
```

```c title="使用例"
VALUE ary = rb_ary_new();
char line[4096];
while ((gets(line)) != NULL){
  item = process_apache_log(line);
  rb_ary_push(ary, item);
}
```

### VALUE rb_ary_pop(VALUE ary)

配列 ary の末尾の要素をとりのぞき返します。
空配列のときは Qnil を返します。

```text title="対応するRubyコード"
val = ary.pop
```

```c title="使用例"
last_error = rb_ary_pop(err_ary);
VALUE str = rb_funcall(last_error, rb_intern("to_s"), 0);
```

### VALUE rb_ary_shift(VALUE ary)

配列 ary の先頭の要素を取り除き返します。
空配列のときは Qnil を返します。

```text title="対応するRubyコード"
val = ary.shift
```

### VALUE rb_ary_unshift(VALUE ary, VALUE item)

配列 ary の先頭に item を挿入します。

### VALUE rb_ary_to_s(VALUE ary)

ary.to_s

```c title="使用例"
void debug_print(VALUE ary)
{
  Check_Type(ary, T_ARRAY);
  printf("%s", STR2CSTR(rb_ary_to_s(ary)));
}
```

### VALUE rb_ary_sort(VALUE ary)

ary.sort

### VALUE rb_ary_includes(VALUE ary, VALUE item)

ary.include? item

### VALUE rb_ary_delete(VALUE ary, VALUE item)

ary.delete

### VALUE rb_ary_clear(VALUE ary)

ary.clear

### VALUE rb_ary_concat(VALUE ary, VALUE x)

ary.concat x

#%since 4.1
### VALUE rb_ary_cat(VALUE ary, const VALUE *train, rb_len_t len)
#%else
### VALUE rb_ary_cat(VALUE ary, const VALUE *train, long len)
#%end

配列 `ary` の末尾に、`train` が指す `len` 個のオブジェクトを破壊的に追加します。

- **param** `ary` -- 追加先の配列です。
- **param** `train` -- 追加するオブジェクトの C の配列です。
- **param** `len` -- `train` の要素数です。
- **return** -- 引数の `ary` です。
- **raise** `IndexError` -- `len` が大きすぎるとき。
- **raise** `FrozenError` -- `ary` が凍結されているとき。

#%since 4.1
### MACRO VALUE rb_ary_new4(rb_len_t n, const VALUE *elts)
#%else
### MACRO VALUE rb_ary_new4(long n, const VALUE *elts)
#%end

[f:rb_ary_new_from_values] の古い名前です。
新しく書くコードでは [f:rb_ary_new_from_values] を使ってください。

- **param** `n` -- `elts` の要素数です。
- **param** `elts` -- 配列に入れるオブジェクトの C の配列です。
- **return** -- 要素数 `n` の新しい配列です。

#%since 4.1
### VALUE rb_ary_new_capa(rb_len_t capa)
#%else
### VALUE rb_ary_new_capa(long capa)
#%end

要素を持たない配列を作成します。
内部のバッファは `capa` 個の要素分を確保します。
配列が最終的にある大きさまで育つと分かっているときは、サイズ変更を繰り返すよりも効率的です。

- **param** `capa` -- 作成する配列の容量です。
- **return** -- 空で、容量が `capa` の新しい配列です。

#%since 4.1
### VALUE rb_ary_new_from_args(rb_len_t n, ...)
#%else
### VALUE rb_ary_new_from_args(long n, ...)
#%end

可変長引数で渡されたオブジェクトから、要素数 `n` の配列を作成します。

- **param** `n` -- 続く引数の個数です。
- **param** `...` -- 配列に入れる Ruby のオブジェクトです。`n` 個渡します。
- **return** -- 要素数 `n` の新しい配列です。

#%since 4.1
### VALUE rb_ary_new_from_values(rb_len_t n, const VALUE *elts)
#%else
### VALUE rb_ary_new_from_values(long n, const VALUE *elts)
#%end

C の配列で渡されたオブジェクトから、要素数 `n` の配列を作成します。
[f:rb_ary_new_from_args] とは、オブジェクトの渡し方だけが異なります。

- **param** `n` -- `elts` の要素数です。
- **param** `elts` -- 配列に入れる Ruby のオブジェクトの C の配列です。
- **return** -- 要素数 `n` の新しい配列です。

#%since 4.1
### VALUE rb_ary_subseq(VALUE ary, rb_len_t beg, rb_len_t len)
#%else
### VALUE rb_ary_subseq(VALUE ary, long beg, long len)
#%end

配列 `ary` の一部を、新しい配列として取り出します。

範囲が `ary` の外であれば `Qnil` を返します。
たとえば `[0, 1, 2, 3]` の 4 番目から 1,000,000,000 番目までを要求したときのように、返す配列は `len` より短くなることがあります。

- **param** `ary` -- 対象の配列です。
- **param** `beg` -- 取り出す部分の先頭の添字です。
- **param** `len` -- 取り出す要素数です。
- **return** -- `ary` の `beg` から `len` 個を持つ新しい配列です。範囲が外のときは `Qnil` です。

### VALUE rb_ary_to_ary(VALUE obj)

オブジェクトを強制的に配列にします。
まず `obj` の `to_ary` メソッドを試し、結果があればそれを返します。
そうでなければ、`obj` だけを要素とする長さ 1 の配列を作って返します。

- **param** `obj` -- 変換するオブジェクトです。
- **return** -- `obj` を表す配列です。
