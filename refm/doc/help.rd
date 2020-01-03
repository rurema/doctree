= このマニュアルのヘルプ

=== 記号の説明

: size -> Integer の「-> Integer」って何?
  size メソッドは整数を返すという意味です。

: Kernel.#require の .# って何?
  「.#」はモジュール関数であることを表します。「Kernel.#require」は
  「Kernel のモジュール関数である require 」という意味です。

: String#size の # って何?
  「#」はインスタンスメソッドであることを表します。

: Dir.chdir の . って何?
  「.」はクラスメソッドであることを表します。

: p a #=> 1 の #=> って何?
  「#=>」は標準出力に出力されるということを表しています。
  「p a #=> 1 」は「p a」を実行すると標準出力に「1」が出力される
  という意味です。

==== 返り値の型の詳細

返り値の型の仕様は以下のようになっています。

 * 真偽値を返す場合は「bool」です
 * 返り値が不定の場合は、「-> ()」です
 * 任意の型を返す場合は 「object」 です
 * 配列を返す場合は 「[クラス名]」 か 「Array」 です
 * 代入式の場合には省略されます

複数の型の値を返すときは "|" を使って記述されています。

例:
  # String または String の配列を返す
  CGI#[](name) -> String | [String]

x オブジェクトと nil で成功・失敗を表す場合は「x | nil」が
使われています。

=== お問い合わせ

間違いを見付けた場合は
 * [[url:https://github.com/rurema]]
へお願いします。

それ以外の意見なども
 * [[url:https://github.com/rurema]]
へお願いします。

GitHub の使い方は
 * [[url:https://github.com/rurema/doctree/wiki/HowToReport]]
を参照してください。
