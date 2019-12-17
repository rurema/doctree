--- static int clone_method(ID mid, NODE *body, st_table *tbl)

m_tbl 格納形式のメソッド (構文木) をコピーして返します。
ST_CONTINUE を返します。

--- static VALUE include_class_new(VALUE module, VALUE super)

super をスーパークラスとして
モジュールの「化身」クラスを作成し返します。

--- static int ins_methods_i(ID key, NODE *body, VALUE ary)

rb_class_instance_methods() のイテレータブロック (通常版)。

--- static int ins_methods_priv_i(ID key, NODE *body, VALUE ary)

rb_class_instance_methods() のイテレータブロック
(private メソッド版)。

--- static int ins_methods_prot_i(ID key, NODE *body, VALUE ary)

rb_class_instance_methods() のイテレータブロック
(protected メソッド版)。

--- static VALUE method_list(VALUE mod, int option, int (*func)())

モジュール mod に定義されているメソッドに対して
順番に func を繰り返し呼び出します。

--- VALUE rb_class_boot(VALUE super)

スーパークラスを super とするクラスオブジェクトを作成し、返します。

--- VALUE rb_class_inherited(VALUE super, VALUE klass)

クラス super の下位クラス klass が作成されたことを
受けて、super に対し inherited メソッドを呼び出します。

--- VALUE rb_class_instance_methods(int argc, VALUE *argv, VALUE mod)

Module#instance_methods の実体。
モジュール mod に定義されている public メソッド名の
リストを文字列の配列で返します。

--- VALUE rb_class_new(VALUE super)

super をスーパークラスとして
新しいクラスオブジェクトを生成し、返します。

--- VALUE rb_class_private_instance_methods(int argc, VALUE *argv, VALUE mod)

Module#private_instance_methods の実体。
モジュール mod に定義されている private メソッド名の
リストを文字列の配列で返します。

--- VALUE rb_class_protected_instance_methods(int argc, VALUE *argv, VALUE mod)

Module#protected_instance_methods の実体。
モジュール mod に定義されている protected メソッド名の
リストを文字列の配列で返します。

--- void rb_define_alias(VALUE klass, const char *new, const char *old)

クラス klass のインスタンスメソッド old の
別名 new を定義します。

--- void rb_define_attr(VALUE klass, const char *name, int read, int write)

クラス klass にメソッド name と name= を定義します。
read が真のときは name を定義し、
write が真のときは name= を定義します。

--- VALUE rb_define_class(const char *name, VALUE super)

クラス super の下位クラス name を作成し返します。

--- VALUE rb_define_class_id(ID id, VALUE super)

クラス名 id でクラス super を継承したクラスを
新しく作成する。クラス→クラス名 (定数名) の関連付けは
なされるが、定数→クラスの関連付けはなされない。

--- VALUE rb_define_class_under(VALUE outer, const char *name, VALUE super)

super のサブクラスとして新しい Ruby クラスを、outer の定数として定義し
て返します。

@param outer 定義するクラスが定数として所属するクラス

@param name クラス名

@param super 継承元のクラス。NULL を指定した場合は [[c:Object]] クラス

@raise TypeError 引数 name と同じ名前の定数が既に存在し、それが
                 [[c:Class]] オブジェクトではない場合に発生します。

#@since 2.3.0
@raise TypeError 定義済みのクラスと継承元のクラスが一致しない場合に発生
                 します。
#@end

--- void rb_define_global_function(const char *name, VALUE (*func)(), int argc)

関数 name を定義します。
func と argc は rb_define_method と同じです。

--- void rb_define_method(VALUE klass, const char *name, VALUE(*func)(), int argc)

クラスklassのインスタンスメソッドnameを定義します。

argcはCの関数へ渡される引数の数(と形式)を決めます．

: argcが0以上の時
    argcで指定した値がそのメソッドの引数の数になります。
    16個以上の引数は使えません，

        VALUE func(VALUE self, VALUE arg1, ... VALUE argN)

: argcが-1のとき
    引数はCの配列として第二引数に入れて渡されます。
    第一引数は配列の要素数です。

        VALUE func(int argc, VALUE *argv, VALUE self)

: argcが-2のとき
    引数はRubyの配列に入れて渡されます。

        VALUE func(VALUE self, VALUE args)

[[f:rb_scan_args]] も参照

--- void rb_define_method_id(VALUE klass, ID name, VALUE (*func)(), int argc)

klass に public メソッド name を定義します。
その実体は関数 func です。また argc の意味は
rb_define_method と同じです。

--- VALUE rb_define_module(const char *name)

モジュール name を作成し返します。

--- void rb_define_module_function(VALUE module, const char *name, VALUE (*func)(), int argc)

モジュール module にモジュール関数 name を定義します。
func と argc は rb_define_method と同じです。

--- VALUE rb_define_module_id(ID id)

名前が id である新しいモジュールを定義し、それを返します。
モジュール→名前 (定数) のリンクは確立しますが
名前→モジュールのリンクはまだ確立していません。

--- VALUE rb_define_module_under(VALUE outer, const char *name)

モジュール outer::name を作成し返します。

--- void rb_define_private_method(VALUE klass, const char *name, VALUE(*func)(), int argc)

クラス klass にプライベートインスタンスメソッド name を
定義します。その実体は関数 func であり、その関数がとる
引数のタイプを argc で指定します。argc のフォーマットに
ついては rb_define_method の項を参照してください。

--- void rb_define_protected_method(VALUE klass, const char *name, VALUE (*func)(), int argc)

クラス klass に protected インスタンスメソッド name を
定義します。その実体は関数 func であり、その関数がとる
引数のタイプを argc で指定します。argc のフォーマットに
ついては rb_define_method の項を参照してください。

--- void rb_define_singleton_method(VALUE obj, const char *name, VALUE (*func)(), int argc)

obj に特異メソッド name を定義します。
メソッドの実体を func に関数ポインタで与え、その関数がとる
引数のタイプを argc に渡します。argc のフォーマットに
ついては rb_define_method の記述を参照してください。

--- void rb_include_module(VALUE klass, VALUE module)

Module#append_features の実体。
クラスまたはモジュール klass にモジュール module を
インクルードします。

--- VALUE rb_make_metaclass(VALUE obj, VALUE klass)

クラス klass のインスタンス obj に特異クラスを導入し
特異クラスと obj を結びつけます。

--- VALUE rb_mod_ancestors(VALUE mod)

モジュール mod にインクルードされているモジュール、
さらに mod がクラスならばスーパークラスとそれに
インクルードされているモジュールを再帰的に集めて
メソッド探索優先順位順に並べて返します (早く探索されるほうが前)。

--- VALUE rb_mod_clone(VALUE mod)

モジュール mod を clone して返します。

--- VALUE rb_mod_dup(VALUE mod)

モジュール mod を dup して返します。

--- VALUE rb_mod_include_p(VALUE mod, VALUE mod2)

モジュール mod が mod2 をインクルードしていれば真。

--- VALUE rb_mod_included_modules(VALUE mod)

モジュール mod にインクルードされているモジュールの配列を返します。

--- VALUE rb_module_new(void)

新しいモジュールオブジェクトを作成し、返します。

--- VALUE rb_obj_singleton_methods(int argc, VALUE *argv, VALUE obj)

Object#singleton_methods の実体。
オブジェクト obj に定義されている特異メソッド名のリストを
文字列の配列で返す。

--- int rb_scan_args(int argc, const VALUE *argv, const char *fmt, ...)

長さ argc の配列 argv を fmt に従って
解析し、第四引数以降で渡されたアドレスに書き込みます。

fmt のフォーマットは以下の通りです。

  * 必須引数の数 (省略可能な引数があるなら省略不可)
  * 省略可能な引数の数 (ゼロ個ならば省略可)
  * 残りの引数を Ruby の配列として受け取ることを示す '*' (省略可)
#@since 1.9.3
  * 最後の引数をオプションハッシュとして受け取る事を示す ':' (省略可)
#@end
  * ブロックを Proc オブジェクト化して受け取ることを示す '&' (省略可)

これらの指定文字はそれぞれ省略可能ですが、
必ずこの順番で現れなければいけません。

使用例

      VALUE a, b, optv;
      rb_scan_args(argc, argv, "21", &a, &b, &optv);

対応する Ruby プログラムでの宣言

      def some_method(a, b, opt = nil)

使用例 (2)

      VALUE a, rest, block;
      rb_scan_args(argc, argv, "1*&", &a, &rest, &block);

対応する Ruby プログラムでの宣言

      def some_method(a, *rest, &block)

@see [[url:https://github.com/ruby/ruby/blob/master/doc/extension.ja.rdoc]]

--- VALUE rb_singleton_class(VALUE obj)

obj に特異クラスを導入し、その特異クラスを返します。
すでに特異クラスが導入されているときはそれをそのまま返します。

obj が特異メソッドを定義できない型のオブジェクトである
ときは例外 TypeError を発生します。

--- void rb_singleton_class_attached(VALUE klass, VALUE obj)

特異クラス klass にその唯一のインスタンス obj を結びつけます。

--- VALUE rb_singleton_class_clone(VALUE klass)

特異クラス klass を clone して返します。
klass が特異クラスでないときはただ klass を返します。

--- VALUE rb_singleton_class_new(VALUE super)

super をスーパークラスとする特異クラスを生成し、返します。

--- void rb_undef_method(VALUE klass, const char *name)

クラス klass のインスタンスメソッド name を undef します。
