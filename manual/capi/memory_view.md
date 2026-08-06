### bool rb_memory_view_register(VALUE klass, const rb_memory_view_entry_t *entry)

`entry` をメモリビューのエントリとして `klass` に登録します。

### bool rb_memory_view_available_p(VALUE obj)

`obj` がメモリビューのエクスポートをサポートしていれば `true` を返します。サポートしていない場合は `false` を返します。

この関数が `true` を返しても [f:rb_memory_view_get] 関数が成功するとは限りません。

`rb_memory_view_entry_t->available_p_func` が呼ばれます。

### bool rb_memory_view_get(VALUE obj, rb_memory_view_t *view, int flags)

`obj` が `flags` に適合するメモリビューのエクスポートをサポートする場合、 `view` をメモリビューの情報で埋めて `true` を返します。その場合、 `view->obj` の参照カウントが増えます。

`obj` と `flags` の組み合わせがメモリビューをエクスポートできない場合、 `false` を返します。この場合 `view` の内容は変わりません。

エクスポートされたメモリビューは不要になった時に [f:rb_memory_view_release] で解放しなければなりません。

`flags` は以下をビット OR で組み合わせて指定します。

```c
RUBY_MEMORY_VIEW_SIMPLE            = 0
RUBY_MEMORY_VIEW_WRITABLE          = (1<<0)
RUBY_MEMORY_VIEW_FORMAT            = (1<<1)
RUBY_MEMORY_VIEW_MULTI_DIMENSIONAL = (1<<2)
RUBY_MEMORY_VIEW_STRIDES           = (1<<3) | RUBY_MEMORY_VIEW_MULTI_DIMENSIONAL
RUBY_MEMORY_VIEW_ROW_MAJOR         = (1<<4) | RUBY_MEMORY_VIEW_STRIDES
RUBY_MEMORY_VIEW_COLUMN_MAJOR      = (1<<5) | RUBY_MEMORY_VIEW_STRIDES
RUBY_MEMORY_VIEW_ANY_CONTIGUOUS    = RUBY_MEMORY_VIEW_ROW_MAJOR | RUBY_MEMORY_VIEW_COLUMN_MAJOR
RUBY_MEMORY_VIEW_INDIRECT          = (1<<6) | RUBY_MEMORY_VIEW_STRIDES
```

`rb_memory_view_entry_t->get_func` が呼ばれます。

### bool rb_memory_view_release(rb_memory_view_t *view)

メモリビュー `view` を解放して `view->obj` の参照カウントを減らします。

コンシューマは、メモリビューが不要になった時にこの関数を呼ばなくてはなりません。呼び忘れるとメモリリークが起こります。

`rb_memory_view_entry_t->release_func` が呼ばれます。 `release_func` が `NULL` であるか `true` を返せば `true` を返します。

メモリビューが登録されていないか  `release_func` が `false` を返すと `false`を返します。この場合は参照カウントの減少は行われず、 `rb_memory_view_entry_t->item_desc` も解放されません。

### ssize_t rb_memory_view_parse_item_format(const char *format, rb_memory_view_item_component_t **members, size_t *n_members, const char **err)

`format` を分解して `members` を埋め、 `members` の数を `n_members` に設定します。

全体のバイトサイズを返します。

処理に失敗した場合はエラーのあった文字を `err` に設定し、 `-1` を返します。

### ssize_t rb_memory_view_item_size_from_format(const char *format, const char **err)

要素が使用するバイト数を計算します。

計算に失敗した場合は、フォーマットでの失敗した位置を `err` に保存し、 `-1` を返します。

### void *rb_memory_view_get_item_pointer(rb_memory_view_t *view, const ssize_t *indices)

`indices` が示す要素の位置を計算します。
`indices` の長さは `view->ndim` と等しくなければなりません。

### VALUE rb_memory_view_get_item(rb_memory_view_t *view, const ssize_t *indices)

`indices` が示す要素の Ruby オブジェクトとしての表現を返します。
必要であれば `view->item_desc` を初期化します。
この関数は [f:rb_memory_view_get_item_pointer] を使います。

### bool rb_memory_view_init_as_byte_array(rb_memory_view_t *view, VALUE obj, void *data, const ssize_t len, const bool readonly)

1 次元のバイト列として `view` のメンバを埋めます。

### void rb_memory_view_fill_contiguous_strides(const ssize_t ndim, const ssize_t item_size, const ssize_t *const shape, const bool row_major_p, ssize_t *const strides)

`shape` を持った与えられた要素サイズの contiguous 配列のストライド（バイト単位）で `strides` を埋めます。

### VALUE rb_memory_view_extract_item_members(const void *ptr, const rb_memory_view_item_component_t *members, const size_t n_members)

要素メンバからなるオブジェクトを返します。

要素が単一メンバの場合、戻り値は単一のオブジェクトになります。

要素が複数メンバからなる場合、 [c:Array] を返します。

### void rb_memory_view_prepare_item_desc(rb_memory_view_t *view)

`view` の `item_desc` メンバを埋めます。

### bool rb_memory_view_is_contiguous(const rb_memory_view_t *view)

メモリビュー `view` のデータが行指向か列指向 contiguous 配列であれば `true` を返します。

そうでなければ `false` を返します。

### bool rb_memory_view_is_row_major_contiguous(const rb_memory_view_t *view)

メモリビュー `view` が行指向 contiguous 配列であれば `true` を返します。

そうでなければ `false` を返します。

### bool rb_memory_view_is_column_major_contiguous(const rb_memory_view_t *view)

メモリビュー `view` が列指向 contiguous 配列であれば `true` を返します。

そうでなければ `false` を返します。
