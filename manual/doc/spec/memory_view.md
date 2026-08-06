# メモリビュー

メモリビュー（ MemoryView ）は、固定サイズの要素からなる型が均一な多次元配列を、拡張ライブラリ間で共有する機能を提供します。

この機能は実験段階であり、将来仕様が変更になるかもしれません。

<https://tech.speee.jp/entry/2020/12/24/093131> も参照してください。

### 概要

numo-narray の `Numo::NArray` や rmagick の `Magick::Image` といった、 contiguous な（連続配置の）メモリ領域に、型が均一な固定サイズの要素が並んだ配列を内部表現として持つオブジェクトを扱うことがあります。メモリビューはそういったオブジェクトの内部データをコピーせずにライブラリ間で共有するハブの役割を果たします。

コピーレスでデータを共有することは、データ分析、機械学習、画像処理といった領域においては非常に重要です。これらの領域では、いくつかのライブラリを使ってメモリ上の巨大なデータを扱わなくてはならないのです。もしライブラリ間でデータを交換する際にコピーしなければならないとなったら、処理時間の大半がコピーに費やされてしまうでしょう。メモリビューを使うことでそうした時間消費を避けることができるのです。

メモリビューには二種類の API があります。

- **1. プロデューサ（提供側） API**: クラスにメモリビューのエントリを登録できます。そのクラスのオブジェクトは自身のメモリビューを公開できるようになります。
- **2. コンシューマ（使用側） API**: コンシューマ API を使ってオブジェクトのメモリビューを取得・管理できるようになります。

### メモリビュー構造体

メモリビュー構造体 `rb_memory_view_t` を使ってあるオブジェクトのメモリビューをエクスポートできます。この構造体は所有者であるそのオブジェクトへの参照、エクスポートするメモリの先頭へのポインタ、メモリ上の構造を記述したメタデータからなります。メタデータによって多次元配列をストライドと共に記述することが可能になっています。

### メモリビュー構造体のメンバ

メモリビュー構造体には以下のメンバがあります。

- **`VALUE obj`**: メモリビュー経由でメモリをエクスポートしている元のオブジェクト。 RubyVM は、メモリビューをエクスポートしているオブジェクトを GC から保護するために参照カウントを管理します。コンシューマはこのオブジェクトを GC から保護するために何かする必要はありません。

- **`void *data`**: エクスポートするメモリの先頭へのポインタ。

- **`ssize_t byte_size`**: `data` が指すメモリのバイト数。

- **`bool readonly`**: 読み取り専用メモリであれば `true` 、書き込み可能なメモリであれば `false` 。

- **`const char *format`**: 要素のフォーマットを表す文字列。 `NULL` であれば符号なしバイト列。詳細は [フォーマット文字列](#format) を参照。

- **`ssize_t item_size`**: 各要素のバイト数。 `rb_memory_view_item_size_from_format(format)` と等しくなるはずです。

- **`const rb_memory_view_item_component_t *item_desc.components`**: 一つの要素内の成分メタデータの配列。 `rb_memory_view_prepare_item_desc` と `rb_memory_view_get_item` が必要に応じてメモリーを割り当て、 `rb_memory_view_release` が解放します。 [メモリビュー成分構造体](#component-structure)も参照。

- **`size_t item_desc.length`**: `item_desc.components` 内の要素数。

- **`ssize_t ndim`**: 次元数。

- **`const ssize_t *shape`**: 各次元の要素数を示す、長さ `ndim` の配列。`ndim` が 1 の時は `NULL` になることがあります。

- **`const ssize_t *strides`**: それぞれの次元で次の要素まで進むのに何バイトスキップすればよいかを示す、長さ `ndim` の配列。各要素は負数になることもあります。メモリビューが行指向の contiguous （連続配置）な配列の場合は `NULL` になることもあります。

- **`const ssize_t *sub_offsets`**: メモリビューがネストされた配列をエクスポートする場合に、それぞれの次元におけるオフセットからなる、長さ `ndim` の配列。メモリビューが平坦な配列の場合は `NULL` になることがあります。

- **`void *private_data`**: メモリビューのプロデューサが内部的に使用するプライベートなデータ。不要な場合は `NULL` になることがあります。

#### フォーマット文字列 {#format}

`format` は以下の [d:pack_template] を並べた文字列です。

```
c, C, s, s!, S, S!, n, v, i, i!, I, I!, l, l!, L, L!,
N, V, f, e, g, q, q!, Q, Q!, d, E, G, j, J, x
```

例えば `"dd"` は二つの浮動小数点数からなる要素で、 `"CCC"` は RGB カラーの三つ組などの三つのバイト列からなる要素です。

また、型指定文字の後に `'<'` か `'>'` を続けることで明示的に値のエンディアンを指定できます。

要素は contiguous （連続配置）にパックされます。構造体メンバのアラインメントを模倣する場合は `'|'` をフォーマット文字列の最初に置いてください。例えば x86_64 Linux ABI では `"|iqc"` というフォーマットの要素は 13 バイトではなく 24 バイトです。

### メモリビュー成分構造体 {#component-structure}

メモリビューの成分のメタデータです。

`rb_memory_view_t->item_desc.components` の一要素です。

#### メモリビュー成分構造体のメンバ

- **`char format`**: `rb_memory_view_t->format` 参照。

- **`bool native_size_p`**: ネイティブ（システム依存）のサイズかどうか。 [d:pack_template] の「整数のテンプレート文字のシステム依存性」の項参照。

- **`bool little_endian_p`**: 成分のエンディアン。

- **`size_t offset`**: 成分のオフセット。

- **`size_t size`**: 成分のサイズ。

- **`size_t repeat`**: 成分の繰り返し回数。例えば `"C3"` の `repeat` は 3です。

### エントリ構造体

クラスとメモリビューエントリ構造体 `rb_memory_view_entry_t` を [f:rb_memory_view_register] に渡して、そのクラスのオブジェクトがメモリビューをエクスポートできるようにします。エントリ構造体にはメモリビューをエクスポート、解放、対応可否の判定をする際に必要な関数ポインタをメンバとして持たせます。

#### エントリ構造体のメンバ

エントリ構造体には以下のメンバがあります。

- **rb_memory_view_get_func_t get_func**: メモリビューをエクスポートする時に呼ばれます。 `rb_memory_view_get_func_t` のシグネチャは `bool (* rb_memory_view_get_func_t)(VALUE obj, rb_memory_view_t *view, int flags)` です。
- **rb_memory_view_release_func_t release_func**: メモリビューを解放する時に呼ばれます。 `rb_memory_view_release_func_t` のシグネチャは `bool (* rb_memory_view_release_func_t)(VALUE obj, rb_memory_view_t *view)` です。
- **rb_memory_view_available_p_func_t available_p_func**: メモリビューのエクスポートに対応しているかどうか調べる時に呼ばれます。 `rb_memory_view_available_p_func_t` のシグネチャは `bool (* rb_memory_view_available_p_func_t)(VALUE obj)` です。

### API

#### プロデューサ API

- [f:rb_memory_view_register]
- [f:rb_memory_view_init_as_byte_array]
- [f:rb_memory_view_fill_contiguous_strides]
- [f:rb_memory_view_prepare_item_desc]

#### コンシューマ API

- [f:rb_memory_view_available_p]
- [f:rb_memory_view_get]
- [f:rb_memory_view_release]
- [f:rb_memory_view_parse_item_format]
- [f:rb_memory_view_item_size_from_format]
- [f:rb_memory_view_get_item_pointer]
- [f:rb_memory_view_get_item]
- [f:rb_memory_view_is_contiguous]
- [f:rb_memory_view_extract_item_members]
- [f:rb_memory_view_is_row_major_contiguous]
- [f:rb_memory_view_is_column_major_contiguous]
