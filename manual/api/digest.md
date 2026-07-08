---
type: library
category: Text
require:
  - digest/md5
  - digest/rmd160
  - digest/sha1
  - digest/sha2
---
メッセージダイジェストライブラリです。

[c:Digest::MD5] や [c:Digest::SHA1] などの
全てのメッセージダイジェストの実装クラスは、
基底クラスである [c:Digest::Base] と同じインタフェースを持ちます。
基本的な使い方は、MD5やSHA1など、どのアルゴリズムでも同じです。
詳しくは [c:Digest::Base] を参照してください。

なお、「メッセージダイジェスト」とは、
データから固定長の擬似乱数を生成する演算手法のことです。

