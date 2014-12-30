= やること(やるかもしれないこと)

これらの課題や方針については rubyist ML で議論されています(議論されて
ない場合もあります:-p)。

* 2002-04-19: Method の良い実例を → ((<rubyist:1343>)) ？

* 2002-04-16: ((<shim>)) ((<ruby-dev:16790>)), ((<ruby-dev:16926>)) の紹介。

* 2002-03-04: getoptsの変更(((<ruby-dev:16193>)))への追随(commit待ち)。
  -> なんだっけ？確か書いたと思う。((<getopts>)) の「おそらく1.6.8」
  とかいう記述は直さなきゃね。

* 追加された添付ライブラリについてのページを(まだなければ)用意する。

* 「new は initialize を呼ぶ。そうでないコンストラクタ(openとか)は
  initializeを呼ばない」ことを明記する

  チェック完 -> Proc

  Thread は難しいので保留

* メソッドの戻り値の明記

  ENV と ARGF がまだ。疲れたわい。

  チェック完 -> Thread, Proc, 組み込み関数
  Object, Array, Binding, Continuation, Data, Exception, Dir,
  FalseClass, File::Stat, Hash, IO, File, MatchData, Method,
  UnboundMethod, Module, Class, Numeric, Integer, Bignum, Fixnum,
  Float, Proc, Process::Status, Range, Regexp,
  String, Struct, Symbol, Thread, ThreadGroup, Time, TrueClass, NilClass,
  Comparable, Enumerable, Errno, File::Constants, FileTest, GC,
  Kernel, Marshal, Math, ObjectSpace, Precision, Process, Signal,
  全例外クラス

* 2001-05-09: Marshal の制限について書く(((<rubyist:0537>)))
* footnote の整理(まだちょっと残ってる→その後、また書いちゃった
  footnote はpending項目としても使っている)
* 暗黙の型変換について書く(本当に書く？元気がなくなった)
* 文書スタイルの確立
* RAAの紹介ページなんかも欲しいなとか言ってみる
* 演算子の説明(一般的な用法 rubyの演算子は再定義可能なので→うーん)
* self の説明(コンテキストの説明)
* クラスもオブジェクトであることに言及する。
  * object.c の図を載せる？
  * クラス階層について詳細を(include はクラス階層への挿入)
  * ((<ruby-list:14141>))の図を載せる
* できるだけすべてのメソッドに簡潔な実例をつけるようにする。

= (どなたかが)やったこと

* allocation framework (1.7 feature) のことも書く
  -> 2002-04-10: 簡単に書いた

* 定義も実行文であることにふれる。(class や module 文で)
  * 直接ではないけど、一応前に「((<クラス／メソッドの定義/クラス定義>))」で書いた
* 索引ページの更新(演算子形式等も索引に載るように)
  * ((<method>))ページで解決？->解決
* MethodList 化
  * 2002-01-14: クラス、モジュール等主なものは完了。あとはぼちぼちやる。
* このマニュアルの配布条件を決める(？)
  * 2001-12-25: ((<配布条件>))
* 2001-04-28: Rubyの終了処理について書く(((<rubyist:0526>)))
  * 2001-05-11: ((<終了処理>))
* 「Rubyの文法」再構成に伴い、全体の記述の見直しと(('((<Rubyの文法>))'))
  と参照している箇所を修正する
  * 2001-05-11: やった。
* ((<manual page>)) の参照の仕方のページ
  * ページだけ作った
  * ((<Process>))でちょっと使ってみた
  * 完了したつもり
* Ruby FAQをここに取り込む
  * 完了したみたい
* 「Rubyの文法」の再編成(検討中)
  * 2001-02-26 やった。どう？ - あらい
* 拡張ライブラリリファレンスマニュアル(書く人いる？)
