* https://github.com/rurema/doctree/issues

上記でレビュー用のチケットを発行しているので以下の方法でレビューする。カテゴリを doc:review で絞り込むと良い。

## 注意点

1. どれか適当なファイルをレビューする(基本は1.8.x向けにチェック)。以下の点に注意する。
  * BitClust で処理できるか? -> bitclust コマンドで処理してエラーがないこと
  * すべての返り値が書いてあるか? -> 基本的に目視で確認
  * @param が全部書いてあるか? -> bc-checkparams で確認できる
  * できれば、意味の無い @return がないか? -> ドキュメントを読んで確認
  * できれば、すべてのメソッドが揃っているか? -> bc-methods で確認できる
  * できれば、1.9.x に対応しているか? -> bc-methods で確認できるが、目視も必要
1. 問題がなければ、チケットを close する。
1. 問題があったら、ML に日本語での指摘またはパッチを投げる。該当するチケットにコメントを付けるのが望ましい。(ステータスを Feedback にすると検索しやすい。担当者をセットすると担当者に気付かれやすい)
1. 修正されたら、確認してチケットを close する。

一つのファイルを複数人がチェックしても構いません。
出来れば複数人がレビューするようにしてください。

すべてのファイルが最低 1 人にレビューされたらレビュー完了とします。

Kernel は functions, constants, specialvars の三つをレビューすること。

## 具体的な手順

主に bc-methods を使用する。

```
$ bc-methods -rgetoptlong GetoptLong
```

でエントリ一覧を表示することが出来る。
差分を確認するには

```
$ bc-methods -rgetoptlong --ruby=1.9.1 --diff=src/getoptlong.rd GetoptLong
```

のようにする。
ここで --diff に与えるパスはカレントディレクトリからの相対パスか絶対パスである。
差分が表示された場合は、その内容を吟味してエントリの過不足があると判断したら、当該チケットにコメントをつける。

### 問題のない例

```
$ bc-methods -rgetoptlong --ruby=1.9.1 --diff=src/getoptlong.rd GetoptLong
+GetoptLong
+GetoptLong.new
```

このように + の行が二行だけ表示されている場合は不足は無いはずである。

zsh ならば以下のようにすればワンライナーで全てのバージョンの Ruby で確認できる。

```
$ for v in 1.8.{0..8} 1.9.{1..2}; do echo $v;bc-methods -rgetoptlong --ruby=$v --diff=src/getoptlong.rd GetoptLong; done
```

### 問題のある例

2010-05-01 現在、csv ライブラリに関してはレビュー依頼が出ていないが、例のために使用した。

```
$ bc-methods -rcsv --ruby=1.9.1 --diff=src/csv.rd CSV
-CSV#<<
-CSV#add_row
-CSV#binmode
-CSV#binmode?
-CSV#close
-CSV#close_read
-CSV#close_write
# ... 多すぎたので以下略
```

レビュー依頼の出ているライブラリでこのように差分が表示されるクラスがあれば、それはエントリが不足している証拠である。
コマンドの実行結果、あるいは不足しているドキュメントを書いたパッチを当該チケットにコメントしたり添付したりするとよい。
