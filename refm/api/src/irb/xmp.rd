#@# Author: Keiju ISHITSUKA

ごとけん xmp の上位互換バージョンです. 
ただ, 非常に重いのでごとけん xmp では対応できない時に使用すると良いでしょう.

=== 関数として使う

  require "irb/xmp"
  xmp <<END
  foo = 1
  foo
  END
  ---
  foo = 1
      ==>1
  foo
      ==>1

=== XMPインスタンスを用いる.

この場合は XMP がコンテキスト情報を持つので,
変数の値などを保持しています.

  require "irb/xmp"
  xmp = XMP.new
  xmp.puts <<END
  foo = 1
  foo
  END
  xmp.puts <<END
  foo
  END
  ===
  foo = 1
      ==>1
  foo
      ==>1
  foo
      ==>1

=== コンテキストに関して

XMPメソッド群のコンテキストは, 呼び出す前のコンテキストで評価されます.
明示的にコンテキストを指定するとそのコンテキストで評価します.

例:

  xmp "foo", an_binding

[注] マルチスレッドには対応していません.
