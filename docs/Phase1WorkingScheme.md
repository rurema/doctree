第 1 段階はファイルフォーマットの変換です。

## 作業方法

変換作業では、ファイルごとに担当を決めて進めます。
レポジトリに ASSIGN というファイルが作ってあります。
この表の該当エントリに自分の Subversion アカウント名を書いて、
コミットした時点でファイルの担当が決まったものとします。
忙しくて作業ができなくなった場合は
ASSIGN ファイルを書き換えてコミットしてもらえれば結構です。

まだフォーマット変換が済んでいないファイル
には *.off という拡張子がついています。
変換が終わったら svn mv で「.off」のない名前に
移動することで作業が完了したことを示します。
例えば _builtin/Dir.rd.off の変換が済んだら
_builtin/Dir.rd に移動します。

フォーマットについては、まず実例を見てもらうのがよいと思います。
すでに変換されているファイル (*.rd) を真似しながらやってください。
記述フォーマットは [[ClassReferenceManualFormat]] に書いてあります。

また、ツール ([[BitClust]]) の bin/bc-convert.rb を使うと、
簡単な変換はすべて済ませられます。
一度これを使って変換したあと、
ざっと見て残りを手でいじるとよいでしょう。

```
実行例
% ruby -I./lib bin/bc-convert.rb String.rd.off > tmp
% diff String.rd.off tmp
```

それ以外に、手で変換が必要になりそうなのは以下のところです。

  * 「= class String」などのレベル 1 ヘッダを新しい形式に変える
  * 「== Singleton Methods」「== Instance Methods」
    などのレベル 2 ヘッダを新しい形式に変える
  * 「メソッド一覧」は自動生成するので、すべて消す。
  * include と require を新しい文法に沿って書く
  * テキストがインデントしてたら全部下げる。
  * メソッドのシグネチャは Ruby の def と同じにする。
  * ハイパーリンクは文法がまだ決まってないのでいじらなくてよいです。
  * ((<ruby 1.x.x feature>)) はプリプロセッサの #@if に変換
  * 注釈 ((- ... -)) は消すか、プリプロセッサコメント #@# に変換

一通り変換が済んだら bitclust の
bin/bc-list.rb でパースのテストをしてみてください。

```
実行例
% ruby -I./lib bin/bc-list.rb String.rd.off
#<BitClust::LibraryDescription:0x00002a96076618
 @classes=[#<class String>],
 @methods=
  [#<smethod String.new>,
   #<imethod String#+>,
   #<imethod String#*>,
   #<imethod String#%>,
   #<imethod String#==,>,>,<,<=>,
   #<imethod String#<<,concat>,
   #<imethod String#=~>,
```

これでちゃんと全部のエントリが表示されていれば OK です。
String.rd.off を String.rd に svn mv して作業を終えます。
どうせあとでまたちゃんとチェックするので、
いまのところはだいたい通っていればよいことにします。
とにかく全部を変換するのが先決です。

## 作業手順のまとめ

1. 変換するファイルを決める (仮に _builtin/Hash とする)。
1. refm/api/ASSIGN の _builtin/Hash の行に自分のアカウント名を書いてコミットする。
1. bitclust の bin/bc-convert.rb で変換してみる。
1. diff をとったりして変な変換をしていないか確認する。
1. エディタでざっと見て残りを潰す。変な文章が目についたらついでに直してもよい。
1. bitclust の bin/bc-list.rb にかけてチェックする。
1. 大丈夫そうならコミット。
1. Hash.rd.off を Hash.rd に svn mv して再度コミットする。

わからないことがあったら ruby-reference-manual ML で聞いてください。
ツールがバグってる場合や、新しい機能が欲しいときも ML で聞いてください。
