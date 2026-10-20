### int rb_check_arity(int argc, int min, int max)

引数の個数 `argc` が `min` 以上 `max` 以下の範囲にあることを検査します。
`max` に `UNLIMITED_ARGUMENTS` を指定すると、上限は検査しません。
範囲外のときは [c:ArgumentError] が発生します。
[f:rb_scan_args] が使えるときは、そちらのほうが強力で分かりやすいので、そちらを使ってください。

- **param** `argc` -- 引数の個数です。
- **param** `min` -- 許される最小の個数です。
- **param** `max` -- 許される最大の個数です。`UNLIMITED_ARGUMENTS` なら上限はありません。
- **return** -- 引数の `argc` です。
- **raise** `ArgumentError` -- `argc` が範囲外のとき。

### VALUE rb_class_instance_methods(int argc, VALUE *argv, VALUE mod)

Module#instance_methods の実体。
モジュール mod に定義されている public メソッド名のリストを文字列の配列で返します。

### VALUE rb_class_new(VALUE super)

super をスーパークラスとして新しいクラスオブジェクトを生成し、返します。

### VALUE rb_class_private_instance_methods(int argc, VALUE *argv, VALUE mod)

Module#private_instance_methods の実体。
モジュール mod に定義されている private メソッド名のリストを文字列の配列で返します。

### VALUE rb_class_protected_instance_methods(int argc, VALUE *argv, VALUE mod)

Module#protected_instance_methods の実体。
モジュール mod に定義されている protected メソッド名のリストを文字列の配列で返します。

### void rb_define_alias(VALUE klass, const char *new, const char *old)

クラス klass のインスタンスメソッド old の別名 new を定義します。

### void rb_define_attr(VALUE klass, const char *name, int read, int write)

クラス klass にメソッド name と name= を定義します。
read が真のときは name を定義し、
write が真のときは name= を定義します。

### VALUE rb_define_class(const char *name, VALUE super)

クラス super の下位クラス name を作成し返します。

### VALUE rb_define_class_id(ID id, VALUE super)

クラス名 id でクラス super を継承したクラスを新しく作成する。クラス→クラス名 (定数名) の関連付けはなされるが、定数→クラスの関連付けはなされない。

### VALUE rb_define_class_under(VALUE outer, const char *name, VALUE super)

super のサブクラスとして新しい Ruby クラスを、outer の定数として定義して返します。

- **param** `outer` -- 定義するクラスが定数として所属するクラス

- **param** `name` -- クラス名

- **param** `super` -- 継承元のクラス。NULL を指定した場合は [c:Object] クラス

- **raise** `TypeError` -- 引数 name と同じ名前の定数が既に存在し、それが
                 [c:Class] オブジェクトではない場合に発生します。

- **raise** `TypeError` -- 定義済みのクラスと継承元のクラスが一致しない場合に発生します。

### void rb_define_global_function(const char *name, VALUE (*func)(), int argc)

関数 name を定義します。
func と argc は rb_define_method と同じです。

```c title="例"
static VALUE 
return_obj_dup(VALUE obj) 
{
      VALUE dup = rb_obj_dup(obj); // オブジェクトを複製
      return dup;
}

void Init_func() {
      rb_define_global_function("dup_obj", return_obj_dup, 1); // 関数 dup_objを定義しています。
}
```

### void rb_define_method(VALUE klass, const char *name, VALUE(*func)(), int argc)

クラスklassのインスタンスメソッドnameを定義します。

argcはCの関数へ渡される引数の数(と形式)を決めます。

- **argcが0以上の時**:
    argcで指定した値がそのメソッドの引数の数になります。
    16個以上の引数は使えません、

        VALUE func(VALUE self, VALUE arg1, ... VALUE argN)

- **argcが-1のとき**:
    引数はCの配列として第二引数に入れて渡されます。
    第一引数は配列の要素数です。

        VALUE func(int argc, VALUE *argv, VALUE self)

- **argcが-2のとき**:
    引数はRubyの配列に入れて渡されます。

        VALUE func(VALUE self, VALUE args)

[f:rb_scan_args] も参照

### void rb_define_method_id(VALUE klass, ID name, VALUE (*func)(), int argc)

klass に public メソッド name を定義します。
その実体は関数 func です。また argc の意味は
rb_define_method と同じです。

### VALUE rb_define_module(const char *name)

モジュール name を作成し返します。

```c title="例"
VALUE rb_mHoge = rb_define_module("Hoge"); // モジュールHogeを作成
```

### void rb_define_module_function(VALUE module, const char *name, VALUE (*func)(), int argc)

モジュール module にモジュール関数 name を定義します。
func と argc は rb_define_method と同じです。

### VALUE rb_define_module_id(ID id)

名前が id である新しいモジュールを定義し、それを返します。
モジュール→名前 (定数) のリンクは確立しますが名前→モジュールのリンクはまだ確立していません。

### VALUE rb_define_module_under(VALUE outer, const char *name)

モジュール outer::name を作成し返します。

### void rb_define_private_method(VALUE klass, const char *name, VALUE(*func)(), int argc)

クラス klass にプライベートインスタンスメソッド name を定義します。その実体は関数 func であり、その関数がとる引数のタイプを argc で指定します。argc のフォーマットについては rb_define_method の項を参照してください。

### void rb_define_protected_method(VALUE klass, const char *name, VALUE (*func)(), int argc)

クラス klass に protected インスタンスメソッド name を定義します。その実体は関数 func であり、その関数がとる引数のタイプを argc で指定します。argc のフォーマットについては rb_define_method の項を参照してください。

### void rb_define_singleton_method(VALUE obj, const char *name, VALUE (*func)(), int argc)

obj に特異メソッド name を定義します。
メソッドの実体を func に関数ポインタで与え、その関数がとる引数のタイプを argc に渡します。argc のフォーマットについては rb_define_method の記述を参照してください。

### VALUE rb_extract_keywords(VALUE *orighash)

ハッシュを、シンボルをキーとする部分とそれ以外に分けます。
シンボルをキーとする部分は新しいハッシュとして返します。
残りは新しいハッシュとして `orighash` が指す先に格納します。
元のハッシュは変更しません。

`orighash` が指すハッシュにシンボル以外のキーがなければ、`orighash` が指す先には `0` が格納されます。

- **param** `orighash` -- 分割するハッシュへのポインタです。呼び出し後は、残りのハッシュを指します。
- **return** -- シンボルをキーとする要素を集めたハッシュです。

### int rb_get_kwargs(VALUE keyword_hash, const ID *table, int required, int optional, VALUE *values)

キーワード引数のハッシュ `keyword_hash` から、`table` に並べたキーワードに対応する値を取り出して `values` に格納します。
取り出した要素は `keyword_hash` から削除されます。

`table` の先頭の `required` 個のキーワードは必須です。
続く `optional` 個のキーワードは省略できます。
`optional` が負のときは、省略できるキーワードは `-optional-1` 個で、`table` にない残りのキーワードは無視されます。
`optional` が負でなければ、`table` にないキーワードがあると例外が発生します。
省略できるキーワードが `keyword_hash` になければ、`values` の対応する要素には `Qundef` が設定されます。

C API でキーワード引数を扱うのは Ruby で扱うよりも効率が悪くなります。
Ruby でラッパーメソッドを書き、キーワード引数を取らない C の関数を呼び出すことも検討してください。

- **param** `keyword_hash` -- 分解するキーワード引数のハッシュです。
- **param** `table` -- 取り出したいキーワードの ID の配列です。
- **param** `required` -- 必須のキーワードの個数です。
- **param** `optional` -- 省略できるキーワードの個数です。負の数も指定できます。
- **param** `values` -- 取り出した値を格納するバッファです。
- **return** -- `values` に格納した値の個数です。
- **raise** `ArgumentError` -- 必須のキーワードがないとき。
- **raise** `ArgumentError` -- 未知のキーワードがあったとき。

### void rb_include_module(VALUE klass, VALUE module)

Module#append_features の実体。
クラスまたはモジュール klass にモジュール module をインクルードします。

### VALUE rb_mod_ancestors(VALUE mod)

モジュール mod にインクルードされているモジュール、さらに mod がクラスならばスーパークラスとそれにインクルードされているモジュールを再帰的に集めてメソッド探索優先順位順に並べて返します (早く探索されるほうが前)。

### VALUE rb_mod_include_p(VALUE mod, VALUE mod2)

モジュール mod が mod2 をインクルードしていれば真。

### VALUE rb_mod_included_modules(VALUE mod)

モジュール mod にインクルードされているモジュールの配列を返します。

### VALUE rb_module_new(void)

新しいモジュールオブジェクトを作成し、返します。

### VALUE rb_obj_singleton_methods(int argc, VALUE *argv, VALUE obj)

Object#singleton_methods の実体。
オブジェクト obj に定義されている特異メソッド名のリストを文字列の配列で返す。

### int rb_scan_args(int argc, const VALUE *argv, const char *fmt, ...)

長さ argc の配列 argv を fmt に従って解析し、第四引数以降で渡されたアドレスに書き込みます。

fmt のフォーマットは以下の通りです。

  - 必須引数の数 (省略可能な引数があるなら省略不可)
  - 省略可能な引数の数 (ゼロ個ならば省略可)
  - 残りの引数を Ruby の配列として受け取ることを示す '*' (省略可)
  - 最後の引数をオプションハッシュとして受け取る事を示す ':' (省略可)
  - ブロックを Proc オブジェクト化して受け取ることを示す '&' (省略可)

これらの指定文字はそれぞれ省略可能ですが、必ずこの順番で現れなければいけません。

```c title="使用例"
VALUE a, b, optv;
rb_scan_args(argc, argv, "21", &a, &b, &optv);
```

```text title="対応する Ruby プログラムでの宣言"
def some_method(a, b, opt = nil)
```

```c title="使用例 (2)"
VALUE a, rest, block;
rb_scan_args(argc, argv, "1*&", &a, &rest, &block);
```

```text title="対応する Ruby プログラムでの宣言"
def some_method(a, *rest, &block)
```

- **SEE** <https://github.com/ruby/ruby/blob/master/doc/extension.ja.rdoc>

### int rb_scan_args_kw(int kw_splat, int argc, const VALUE *argv, const char *fmt, ...)

[f:rb_scan_args] と同じように、`argc` と `argv` の引数を `fmt` の書式に従って、続く VALUE への参照に格納します。
キーワード引数が渡されているかどうかを、Ruby からの呼び出しで決めるのではなく、`kw_splat` で指定する点が異なります。
`fmt` の書式は [f:rb_scan_args] と同じです。

`kw_splat` には次のどれかを指定します。

- `RB_SCAN_ARGS_PASS_CALLED_KEYWORDS` -- [f:rb_scan_args] と同じ動作です。
- `RB_SCAN_ARGS_KEYWORDS` -- 最後の引数をキーワード引数のハッシュとして扱います。
- `RB_SCAN_ARGS_LAST_HASH_KEYWORDS` -- 最後の引数がハッシュならキーワード引数として扱い、そうでなければ扱いません。

- **param** `kw_splat` -- キーワード引数の扱いです。
- **param** `argc` -- `argv` の要素数です。
- **param** `argv` -- 解析する引数の配列です。
- **param** `fmt` -- 引数の形式を表す書式文字列です。
- **param** `...` -- 値を格納する変数への参照です。
- **return** -- 実際に解析した引数の個数です。
- **raise** `fatal` -- `fmt` の形式が不正なとき。
- **raise** `ArgumentError` -- 引数の個数が合わないとき。

### VALUE rb_singleton_class(VALUE obj)

obj に特異クラスを導入し、その特異クラスを返します。
すでに特異クラスが導入されているときはそれをそのまま返します。

obj が特異メソッドを定義できない型のオブジェクトであるときは例外 TypeError を発生します。

### void rb_singleton_class_attached(VALUE klass, VALUE obj)

特異クラス klass にその唯一のインスタンス obj を結びつけます。

### VALUE rb_singleton_class_clone(VALUE klass)

特異クラス klass を clone して返します。
klass が特異クラスでないときはただ klass を返します。

### void rb_undef_method(VALUE klass, const char *name)

クラス klass のインスタンスメソッド name を undef します。
