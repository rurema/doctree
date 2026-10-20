#%since 4.1
### VALUE rb_str_new(const char *ptr, rb_len_t len)
#%else
### VALUE rb_str_new(const char *ptr, long len)
#%end

ptr から len バイト分をコピーして
Ruby の文字列を作成し返します。

```c
rb_str_new(0,0)
```

では空文字列を生成して返します。

### VALUE rb_str_new2(const char *ptr)

rb_str_new(ptr, strlen(ptr))

### VALUE rb_str_new4(VALUE orig)

文字列 orig の変更不可能な複製を作成し返します。

### VALUE rb_str_dup(VALUE str)

文字列 str の複製を作成し返します。

#%since 4.1
### VALUE rb_str_substr(VALUE str, rb_len_t beg, rb_len_t len)
#%else
### VALUE rb_str_substr(VALUE str, long beg, long len)
#%end

str[beg, len]

#%since 4.1
### VALUE rb_str_cat(VALUE str, const char *ptr, rb_len_t len)
#%else
### VALUE rb_str_cat(VALUE str, const char *ptr, long len)
#%end

文字列 str に、長さ len (NUL 含まず)の C の文字列
ptr を破壊的に連結します。

### VALUE rb_str_cat2(VALUE str, const char *ptr)

文字列 str に C の文字列 ptr を破壊的に連結します。ptr はヌル終端を仮定しています。

### VALUE rb_str_concat(VALUE s1, VALUE s2)

equivalent to "s1.concat s2"

#%since 4.1
### VALUE rb_enc_str_new(const char *ptr, rb_len_t len, rb_encoding *enc)
#%else
### VALUE rb_enc_str_new(const char *ptr, long len, rb_encoding *enc)
#%end

エンコーディングを指定して、新しい [c:String] を作成します。
[f:rb_str_new] と同じですが、エンコーディング `enc` を持つ文字列になります。

`enc` には `NULL` も指定できます。
その場合は、US-ASCII の文字列を作成する [f:rb_usascii_str_new] と同じになります。

- **param** `ptr` -- 文字列の内容を持つ、`len` バイト以上のメモリ領域です。
- **param** `len` -- `ptr` の長さです。終端の NUL 文字を含まないバイト数で指定します。
- **param** `enc` -- `ptr` のエンコーディングです。
- **return** -- `ptr` の内容をそのままコピーした、長さ `len` バイトで `enc` のエンコーディングの新しい [c:String] です。
- **raise** `NoMemoryError` -- `len+1` バイトの確保に失敗したとき。
- **raise** `ArgumentError` -- `len` が負のとき。

### VALUE rb_enc_str_new_cstr(const char *ptr, rb_encoding *enc)

エンコーディングを指定して、C の文字列から新しい [c:String] を作成します。
[f:rb_enc_str_new] と同じですが、`ptr` が C の文字列であると仮定して長さを求めます。
[f:rb_str_new_cstr] と同じですが、エンコーディング `enc` を持つ文字列になります。

`enc` には `NULL` も指定できます。
その場合は、[f:rb_usascii_str_new_cstr] と同じになります。
`ptr` は C の文字列なので、`enc` に UTF-32 のようなものを指定しても意味がありません。

- **param** `ptr` -- C の文字列です。`NULL` は指定できません。
- **param** `enc` -- `ptr` のエンコーディングです。
- **return** -- `ptr` の内容をそのままコピーした、`enc` のエンコーディングの新しい [c:String] です。
- **raise** `NoMemoryError` -- メモリの確保に失敗したとき。

### MACRO VALUE rb_enc_str_new_literal(const char *str, rb_encoding *enc)

エンコーディングを指定して、C の文字列リテラルから新しい [c:String] を作成します。
文字列リテラルの領域を、そのまま文字列の実体として使います。
文字列リテラルしか渡せません。変数は渡せません。

返り値は読み取り専用として扱ってください。
C の文字列リテラルへの書き込みは、すぐに SEGV を起こすことがあります。

- **param** `str` -- C の文字列リテラルです。
- **param** `enc` -- `str` のエンコーディングです。
- **return** -- `enc` のエンコーディングを持ち、実体が `str` である [c:String] です。

### VALUE rb_str_append(VALUE dst, VALUE src)

文字列 `dst` の末尾に、文字列 `src` を破壊的に追加します。
`src` の内容は、`dst` のエンコーディングに変換されて追加されます。
`dst` は [c:String] でなければいけません。

- **param** `dst` -- 追加先の [c:String] です。
- **param** `src` -- 追加する文字列です。
- **return** -- 引数の `dst` です。
- **raise** `Encoding::CompatibilityError` -- エンコーディングを混在できないとき。
- **raise** `ArgumentError` -- 結果の文字列が大きすぎるとき。

### VALUE rb_str_cat_cstr(VALUE dst, const char *src)

文字列 `dst` の末尾に、C の文字列 `src` を破壊的に追加します。
`rb_str_cat(dst, src, strlen(src))` と同じです。
`dst` は [c:String] でなければいけません。
`src` は `NULL` であってはいけません。

- **param** `dst` -- 追加先の [c:String] です。
- **param** `src` -- 追加する C の文字列です。
- **return** -- 引数の `dst` です。
- **raise** `ArgumentError` -- 結果の文字列が大きすぎるとき。
- **raise** `ArgumentError` -- `src` が `NULL` のとき。

### void rb_str_modify(VALUE str)

文字列 `str` を変更する準備をします。
`RSTRING_PTR` や [f:rb_str_set_len] を使って `str` の内容を変更する前には、必ずこの関数を呼んでください。

`str` が共有された領域を使っているときは、専用の領域を確保します。
変更できない文字列のときは、例外が発生します。

- **param** `str` -- 変更しようとする [c:String] です。
- **raise** `RuntimeError` -- `str` が `locktmp` されているとき。
- **raise** `FrozenError` -- `str` が凍結されているとき。

### VALUE rb_str_new_cstr(const char *ptr)

C の文字列 `ptr` から、新しい [c:String] を作成します。
`rb_str_new(ptr, strlen(ptr))` と同じです。
エンコーディングは ASCII-8BIT(binary)になります。

- **param** `ptr` -- C の文字列です。`NULL` は指定できません。
- **return** -- `ptr` の内容をそのままコピーした、ASCII-8BIT の新しい [c:String] です。
- **raise** `NoMemoryError` -- メモリの確保に失敗したとき。
- **raise** `ArgumentError` -- `ptr` が `NULL` のとき。

### MACRO VALUE rb_str_new_literal(const char *str)

C の文字列リテラルから、新しい [c:String] を作成します。
文字列リテラルの領域を、そのまま文字列の実体として使います。
文字列リテラルしか渡せません。変数は渡せません。
エンコーディングは ASCII-8BIT(binary)になります。

返り値は読み取り専用として扱ってください。
C の文字列リテラルへの書き込みは、すぐに SEGV を起こすことがあります。

- **param** `str` -- C の文字列リテラルです。
- **return** -- 実体が `str` である、ASCII-8BIT の [c:String] です。

#%since 4.1
### VALUE rb_str_resize(VALUE str, rb_len_t len)
#%else
### VALUE rb_str_resize(VALUE str, long len)
#%end

文字列 `str` の長さを `len` バイトにします。
[f:rb_str_set_len] と異なり、文字列を伸ばすこともできます。
`len` が元の長さより小さければ、`len` バイトより後ろの内容は捨てられます。
大きければ、元の長さより後ろの内容は保証されず、ごみになります。

この関数を呼ぶと `RSTRING_PTR(str)` が変わることがあります。
`str` は [c:String] でなければいけません。

- **param** `str` -- 長さを変える [c:String] です。
- **param** `len` -- 新しい長さです。
- **return** -- 引数の `str` です。
- **raise** `ArgumentError` -- `len` が負のとき。
- **raise** `RuntimeError` -- `str` が `locktmp` されているとき。
- **raise** `FrozenError` -- `str` が凍結されているとき。

#%since 4.1
### void rb_str_set_len(VALUE str, rb_len_t len)
#%else
### void rb_str_set_len(VALUE str, long len)
#%end

文字列 `str` の長さを `len` バイトに設定します。
主に、あらかじめ `rb_str_modify_expand` で領域を広げた文字列を縮めるために使います。
`len` は `str` の容量を超えてはいけません。
`len` バイトまでの内容は、現在の長さによらず保たれます。
`str` は [c:String] でなければいけません。

```c title="使用例"
extern int fd;
VALUE str = rb_str_new_cstr("...");
ssize_t len;

rb_str_modify_expand(str, BUFSIZ);
len = recv(fd, RSTRING_PTR(str), BUFSIZ, 0);
if (len >= 0) {
    rb_str_set_len(str, len);
}
else {
    rb_sys_fail("recv(2)");
}
```

- **param** `str` -- 長さを設定する [c:String] です。
- **param** `len` -- 新しい長さです。`str` の容量以下にします。
- **raise** `RuntimeError` -- `str` が `locktmp` されているとき。
- **raise** `FrozenError` -- `str` が凍結されているとき。

#%since 4.1
### VALUE rb_usascii_str_new(const char *ptr, rb_len_t len)
#%else
### VALUE rb_usascii_str_new(const char *ptr, long len)
#%end

US-ASCII の新しい [c:String] を作成します。
[f:rb_str_new] と同じですが、エンコーディングが US-ASCII になります。
`rb_external_str_new` とは異なり、内容の変換はしません。

- **param** `ptr` -- 文字列の内容を持つ、`len` バイト以上のメモリ領域です。
- **param** `len` -- `ptr` の長さです。終端の NUL 文字を含まないバイト数で指定します。
- **return** -- `ptr` の内容をそのままコピーした、長さ `len` バイトで US-ASCII の新しい [c:String] です。
- **raise** `NoMemoryError` -- `len+1` バイトの確保に失敗したとき。
- **raise** `ArgumentError` -- `len` が負のとき。

### VALUE rb_usascii_str_new_cstr(const char *ptr)

C の文字列 `ptr` から、US-ASCII の新しい [c:String] を作成します。
[f:rb_str_new_cstr] と同じですが、エンコーディングが US-ASCII になります。

- **param** `ptr` -- C の文字列です。`NULL` は指定できません。
- **return** -- `ptr` の内容をそのままコピーした、US-ASCII の新しい [c:String] です。
- **raise** `NoMemoryError` -- メモリの確保に失敗したとき。
- **raise** `ArgumentError` -- `ptr` が `NULL` のとき。

### MACRO VALUE rb_usascii_str_new_literal(const char *str)

C の文字列リテラルから、US-ASCII の新しい [c:String] を作成します。
文字列リテラルの領域を、そのまま文字列の実体として使います。
文字列リテラルしか渡せません。変数は渡せません。

返り値は読み取り専用として扱ってください。
C の文字列リテラルへの書き込みは、すぐに SEGV を起こすことがあります。

- **param** `str` -- C の文字列リテラルです。
- **return** -- 実体が `str` である、US-ASCII の [c:String] です。

#%since 4.1
### VALUE rb_utf8_str_new(const char *ptr, rb_len_t len)
#%else
### VALUE rb_utf8_str_new(const char *ptr, long len)
#%end

UTF-8 の新しい [c:String] を作成します。
[f:rb_str_new] と同じですが、エンコーディングが UTF-8 になります。

- **param** `ptr` -- 文字列の内容を持つ、`len` バイト以上のメモリ領域です。
- **param** `len` -- `ptr` の長さです。終端の NUL 文字を含まないバイト数で指定します。
- **return** -- `ptr` の内容をそのままコピーした、長さ `len` バイトで UTF-8 の新しい [c:String] です。
- **raise** `NoMemoryError` -- `len+1` バイトの確保に失敗したとき。
- **raise** `ArgumentError` -- `len` が負のとき。

### VALUE rb_utf8_str_new_cstr(const char *ptr)

C の文字列 `ptr` から、UTF-8 の新しい [c:String] を作成します。
[f:rb_str_new_cstr] と同じですが、エンコーディングが UTF-8 になります。

- **param** `ptr` -- C の文字列です。`NULL` は指定できません。
- **return** -- `ptr` の内容をそのままコピーした、UTF-8 の新しい [c:String] です。
- **raise** `NoMemoryError` -- メモリの確保に失敗したとき。
- **raise** `ArgumentError` -- `ptr` が `NULL` のとき。

### MACRO VALUE rb_utf8_str_new_literal(const char *str)

C の文字列リテラルから、UTF-8 の新しい [c:String] を作成します。
文字列リテラルの領域を、そのまま文字列の実体として使います。
文字列リテラルしか渡せません。変数は渡せません。

返り値は読み取り専用として扱ってください。
C の文字列リテラルへの書き込みは、すぐに SEGV を起こすことがあります。

- **param** `str` -- C の文字列リテラルです。
- **return** -- 実体が `str` である、UTF-8 の [c:String] です。
