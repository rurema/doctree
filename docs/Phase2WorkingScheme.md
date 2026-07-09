プロジェクトの第 2 段階では、
メソッドのエントリをすべて揃えます。

## 作業手順の概要

第 2 段階ではテンプレートとして rdoc (ri) を使います。

rdoc はソースコードを見てメソッドの存在を判定するので、
確実にすべてのメソッドのエントリが揃っています。
そこで、rdoc のデータベースと BitClust のデータベースを比較して、
足りないメソッドを検出します。

rdoc と BitClust のデータベースを比較するツール
bc-rdoc.rb を用意しました。メンバーは bc-rdoc.rb を使って、
各ファイルに足りないメソッドを発見し、エントリを書いてください。

以下、具体的に説明します。

## 前準備

まず、BitClust データベースが必要になるので、
以下のコマンドを打って BitClust データベースをビルドしておいてください。

```
~/c/rubydoc/refm/api $ bitclust -d ./db init version=1.8.5 encoding=euc-jp
~/c/rubydoc/refm/api $ bitclust -d ./db update --stdlibtree=src
```

それから、できるだけ多くのバージョンの ri データベースを作ります。
1.8.0 〜 1.8.5、それからできれば 1.8 HEAD と CVS trunk HEAD の
ソースコードをダウンロードして展開してください (コンパイルする必要はありません)。
ここでは、仮に ~/src/ruby-VERSION (VERSION は 1.8.0 〜 1.9.0)
に展開したとします。

展開が済んだら、以下のコマンドを打って rdoc データベースを作ります。

```
~/c/rubydoc/refm/api $ rdoc --ri --op ris/1.8.0 ~/src/ruby-1.8.0
~/c/rubydoc/refm/api $ rdoc --ri --op ris/1.8.1 ~/src/ruby-1.8.1
~/c/rubydoc/refm/api $ rdoc --ri --op ris/1.8.2 ~/src/ruby-1.8.2
~/c/rubydoc/refm/api $ rdoc --ri --op ris/1.8.3 ~/src/ruby-1.8.3
~/c/rubydoc/refm/api $ rdoc --ri --op ris/1.8.4 ~/src/ruby-1.8.4
~/c/rubydoc/refm/api $ rdoc --ri --op ris/1.8.5 ~/src/ruby-1.8.5
~/c/rubydoc/refm/api $ rdoc --ri --op ris/1.8   ~/src/ruby-1.8     # 1.8 HEAD
~/c/rubydoc/refm/api $ rdoc --ri --op ris/1.9.0 ~/src/ruby-1.9.0   # trunk HEAD
```

シェルの for 文や、バッチファイルを使うと楽に実行できます。

なお、rdoc を実行する ruby のバージョンと rdoc の相性があるようです。
とりあえず、現在の ruby 1.9.0 は rdoc がまともに動きません。
1.8 HEAD もどうも怪しげです。1.8.4 以上のリリース版を使いましょう。

## リファレンスの編集

次に、第 1 段階と同じように、レポジトリの ASSIGN ファイルの、
「OWNER」欄に自分のアカウントを書き込んでコミットします。
これでそのファイルの排他的編集権を得たものとします。

続いて、足りないエントリをチェックします。
例えば String クラスをチェックしたいときは以下のように打ちます。

```
~/c/rubydoc/refm/api % bc-rdoc diff --bc=db --ri=ris/1.8.5 String
+ String#<
+ String#<=
+ String#>
+ String#clone
+ String#dup
+ String#each
+ String#to_d
+ String#~
- String.yaml_new
- String#_expand_ch
- String#_regex_quote
- String#block_scanf
- String#bytes
- String#chr
- String#end_regexp
- String#end_with?
- String#expand_ch_hash
- String#initialize_copy
- String#is_binary_data?
- String#is_complex_yaml?
- String#lines
- String#ord
- String#original_succ
- String#original_succ!
- String#quote
- String#rpartition
- String#start_with?
- String#to_yaml
- String#toutf32
```

すると、このように、BitClust だけにあるメソッドが「+」、
rdoc だけにあるメソッドには「-」が前置されてリストされます。
これを見て、足りないメソッドがあることがわかったら、
次のように -c (--content) オプションを追加して実行します。

```
~/c/rubydoc/refm/api % bc-rdoc diff --bc=./db --ri=ris/1.8.5 String --content
#@# bc-rdoc: detected missing name: bytes
--- str.bytes   => anEnumerator

Returns an enumerator that gives each byte in the string.

   "hello".bytes.to_a        #=> [104, 101, 108, 108, 111]

#@# bc-rdoc: detected missing name: chr
--- string.chr    ->  string

Returns a one-character string at the beginning of the string.

   a = "abcde"
   a.chr    #=> "a"

(以下略)
```

するとこのように、足りないメソッドの rdoc だけがまとめて出力されます。
これを BitClust の文法に直して既存のファイルに追加してください。

例えば、出力が

```
[ダメな例]
  --- str.lines(separator=$/)   => anEnumerator
```

である場合、「str.」を取り除き、「separator=$/」は空白を入れて「seperator = $/」
とするのがベストです。

```
[理想的]

  --- lines(separator = $/)
  #@# => anEnumerator
```

プロジェクトの第 2 段階ではエントリが揃えばいいので、
ドキュメントを書く必要はありません (書きたければ書いても構いません)。

さて、すべてのエントリを追加しおわったら、まずファイルをコミットします。
続いて ASSIGN ファイルの「STATUS」欄を「done」にして、
こちらもコミットします。これで編集完了です。

## 注意点

bc-rdoc.rb diff で出力されたエントリをすべて追加すべきとは限りません。

例えば上記の例で言うと、
yaml_new や original_succ は追加すべきではありません。
yaml_new は yaml ライブラリが追加するメソッドなので
_builtin/String に書くのは不適切ですし、
original_succ は (おそらく) jcode ライブラリが一時的に作成する alias で、
一般ユーザが呼び出すことを意図しているとは思えません。

また、特定の Ruby バージョンにしかないメソッドもあります。
上記の例では chr, ord, bytes, lines あたりは Ruby 1.9 にしかありません。
メソッドのエントリを追加するときは、以上の点に注意する必要があります。

メソッドがいつから存在するのか確認するときにも bc-rdoc.rb が使えます。
以下のように bc-rdoc history コマンドを使うと、
指定したクラスの全メソッドについて、
どのバージョンで rdoc が存在するかどうかが一覧できます。

```
~/c/bitclust % ./bin/bc-rdoc.rb history --ri=ris FileUtils
                                 180 181 182 183 184 185 190
FileUtils#cd                       o   o   o   o   o   o   o
FileUtils#chdir                    o   o   o   o   o   o   o
FileUtils#chmod                    o   o   o   o   o   o   o
FileUtils#chmod_R                  -   -   -   o   o   o   o
FileUtils#chown                    -   -   -   o   o   o   o
FileUtils#chown_R                  -   -   -   o   o   o   o
FileUtils#cmp                      o   o   o   o   o   o   o
FileUtils#compare_file             o   o   o   o   o   o   o
FileUtils#compare_stream           o   o   o   o   o   o   o
FileUtils#copy                     o   o   o   o   o   o   o
FileUtils#copy_entry               -   -   o   o   o   o   o
FileUtils#copy_file                o   o   o   o   o   o   o
FileUtils#copy_stream              o   o   o   o   o   o   o
FileUtils#cp                       o   o   o   o   o   o   o
FileUtils#cp_r                     o   o   o   o   o   o   o
FileUtils#fu_have_symlink?         -   -   -   o   o   o   o
FileUtils#fu_world_writable?       -   -   -   o   o   o   -
FileUtils#getwd                    o   o   o   o   o   o   o
FileUtils#identical?               o   o   o   o   o   o   o
FileUtils#install                  o   o   o   o   o   o   o
FileUtils#link                     o   o   o   o   o   o   o
FileUtils#ln                       o   o   o   o   o   o   o
FileUtils#ln_s                     o   o   o   o   o   o   o
FileUtils#ln_sf                    o   o   o   o   o   o   o
FileUtils#makedirs                 o   o   o   o   o   o   o
FileUtils#mkdir                    o   o   o   o   o   o   o
FileUtils#mkdir_p                  o   o   o   o   o   o   o
FileUtils#mkpath                   o   o   o   o   o   o   o
FileUtils#move                     o   o   o   o   o   o   o
FileUtils#mv                       o   o   o   o   o   o   o
FileUtils#pwd                      o   o   o   o   o   o   o
FileUtils#remove                   o   o   o   o   o   o   o
FileUtils#remove_dir               -   -   -   o   o   o   o
FileUtils#remove_entry             -   -   -   o   o   o   o
FileUtils#remove_entry_secure      -   -   -   o   o   o   o
FileUtils#remove_file              -   -   -   o   o   o   o
FileUtils#rm                       o   o   o   o   o   o   o
FileUtils#rm_f                     o   o   o   o   o   o   o
FileUtils#rm_r                     o   o   o   o   o   o   o
FileUtils#rm_rf                    o   o   o   o   o   o   o
FileUtils#rmdir                    o   o   o   o   o   o   o
FileUtils#rmtree                   o   o   o   o   o   o   o
FileUtils#safe_unlink              o   o   o   o   o   o   o
FileUtils#symlink                  o   o   o   o   o   o   o
FileUtils#touch                    o   o   o   o   o   o   o
FileUtils#uptodate?                o   o   o   o   o   o   o
```

「o」が表示されているバージョンには rdoc が存在し、
「-」と表示されているバージョンには rdoc が存在しないことを示します。

ただし、このコマンドもあくまでも「rdoc があるかどうか」を示しているだけで、
そのメソッドが本当に存在するかどうかはわかりません。
特に 1.8.0 と 1.8.1 の rdoc は非常に怪しいので、
あまり信用しないほうがいいでしょう。

## 実際の Ruby で調べる方法

Ruby 1.8.x をすべてインストールしている場合は、
実際に Ruby を動かしてメソッドを調べることもできます。
なお、1.8.x を共存する方法については HowToInstallRubys を見てください。

特定のライブラリに存在するクラスを調べるには bc-class.rb コマンドを使います。
strscan ライブラリに存在するクラスを調べる例を以下に示します。

```
~/c/bitclust $ ./bin/bc-classes.rb strscan
                      180 181 182 183 184 185 185 190
ScanError               o   o   -   -   -   -   -   -
StringScanner           o   o   o   o   o   o   o   o
StringScanner::Error    -   -   o   o   o   o   o   o
```

このように、bc-rdoc.rb と同じような表で
クラスが存在するかどうかが表示されます。

bc-class.rb コマンドでは、
ライブラリから再帰的に require しているライブラリのクラスも含まれてしまいます。
例えば以下は net/protocol を調べている例です。

```
~/c/bitclust % ./bin/bc-classes.rb net/protocol
                          180 181 182 183 184 185 185 190
BasicSocket                 o   o   o   o   o   o   o   o
IPSocket                    o   o   o   o   o   o   o   o
Net                         o   o   o   o   o   o   o   o
Net::BufferedIO             -   -   -   o   o   o   o   o
Net::InternetMessageIO      o   o   o   o   o   o   o   o
Net::NetPrivate             o   o   o   o   o   o   o   o
Net::ProtoAuthError         o   o   o   o   o   o   o   o
Net::ProtoCommandError      o   o   o   o   o   o   o   o
Net::ProtoFatalError        o   o   o   o   o   o   o   o
Net::ProtoRetriableError    o   o   o   o   o   o   o   o
Net::ProtoServerError       o   o   o   o   o   o   o   o
Net::ProtoSyntaxError       o   o   o   o   o   o   o   o
Net::ProtoUnknownError      o   o   o   o   o   o   o   o
Net::Protocol               o   o   o   o   o   o   o   o
Net::ProtocolError          o   o   o   o   o   o   o   o
Net::ReadAdapter            o   o   o   o   o   o   o   o
Net::WriteAdapter           o   o   o   o   o   o   o   o
Socket                      o   o   o   o   o   o   o   o
Socket::Constants           o   o   o   o   o   o   o   o
SocketError                 o   o   o   o   o   o   o   o
TCPServer                   o   o   o   o   o   o   o   o
TCPSocket                   o   o   o   o   o   o   o   o
Timeout                     o   o   o   o   o   o   o   o
Timeout::Error              o   o   o   o   o   o   o   o
UDPSocket                   o   o   o   o   o   o   o   o
UNIXServer                  o   o   o   o   o   o   o   o
UNIXSocket                  o   o   o   o   o   o   o   o
```

net/protocol ライブラリは socket や timeout を require しているので、
BasicSocket や Timeout が入ってしまいました。
このような余計なライブラリの影響を排除するには、
以下のように --reject オプションを使います。

```
~/c/bitclust % ./bin/bc-classes.rb net/protocol --reject=socket,timeout
                          180 181 182 183 184 185 185 190
Net                         o   o   o   o   o   o   o   o
Net::BufferedIO             -   -   -   o   o   o   o   o
Net::InternetMessageIO      o   o   o   o   o   o   o   o
Net::NetPrivate             o   o   o   o   o   o   o   o
Net::ProtoAuthError         o   o   o   o   o   o   o   o
Net::ProtoCommandError      o   o   o   o   o   o   o   o
Net::ProtoFatalError        o   o   o   o   o   o   o   o
Net::ProtoRetriableError    o   o   o   o   o   o   o   o
Net::ProtoServerError       o   o   o   o   o   o   o   o
Net::ProtoSyntaxError       o   o   o   o   o   o   o   o
Net::ProtoUnknownError      o   o   o   o   o   o   o   o
Net::Protocol               o   o   o   o   o   o   o   o
Net::ProtocolError          o   o   o   o   o   o   o   o
Net::ReadAdapter            o   o   o   o   o   o   o   o
Net::WriteAdapter           o   o   o   o   o   o   o   o
```

このように、うまく余計なクラスを排除できました。

次に、特定のクラスに存在するメソッドを調べるには、
bc-methods.rb コマンドを使います。
Enumerable モジュールに存在するメソッドを調べる例を以下に示します。

```
~/c/bitclust % ./bin/bc-methods.rb Enumerable
                            180 181 182 183 184 185 185 190
Enumerable#all?               o   o   o   o   o   o   o   o
Enumerable#any?               o   o   o   o   o   o   o   o
Enumerable#collect            o   o   o   o   o   o   o   o
Enumerable#count              -   -   -   -   -   -   -   o
Enumerable#detect             o   o   o   o   o   o   o   o
Enumerable#each_cons          -   -   -   -   -   -   -   o
Enumerable#each_slice         -   -   -   -   -   -   -   o
Enumerable#each_with_index    o   o   o   o   o   o   o   o
Enumerable#entries            o   o   o   o   o   o   o   o
Enumerable#enum_cons          -   -   -   -   -   -   -   o
Enumerable#enum_slice         -   -   -   -   -   -   -   o
Enumerable#enum_with_index    -   -   -   -   -   -   -   o
Enumerable#find               o   o   o   o   o   o   o   o
Enumerable#find_all           o   o   o   o   o   o   o   o
Enumerable#find_index         -   -   -   -   -   -   -   o
Enumerable#first              -   -   -   -   -   -   -   o
Enumerable#grep               o   o   o   o   o   o   o   o
Enumerable#group_by           -   -   -   -   -   -   -   o
Enumerable#include?           o   o   o   o   o   o   o   o
Enumerable#inject             o   o   o   o   o   o   o   o
Enumerable#map                o   o   o   o   o   o   o   o
Enumerable#max                o   o   o   o   o   o   o   o
Enumerable#max_by             -   -   -   -   -   -   -   o
Enumerable#member?            o   o   o   o   o   o   o   o
Enumerable#min                o   o   o   o   o   o   o   o
Enumerable#min_by             -   -   -   -   -   -   -   o
Enumerable#none?              -   -   -   -   -   -   -   o
Enumerable#one?               -   -   -   -   -   -   -   o
Enumerable#partition          o   o   o   o   o   o   o   o
Enumerable#reject             o   o   o   o   o   o   o   o
Enumerable#select             o   o   o   o   o   o   o   o
Enumerable#sort               o   o   o   o   o   o   o   o
Enumerable#sort_by            o   o   o   o   o   o   o   o
Enumerable#to_a               o   o   o   o   o   o   o   o
Enumerable#zip                o   o   o   o   o   o   o   o
Enumerable::Enumerator        -   -   -   -   -   -   -   o
```

## どのバージョンから追加されたのかわからないときは……

いろいろ書きましたが、この段階で一番重要なのは、
次の安定版リリースである 1.8.6 のメソッドをきっちり揃えることです。
「そのメソッドがいつ追加されたか」というのは追加的な情報にすぎません。
どのバージョンから追加されたのかよくわからないときは、
「#@# 追加されたバージョンは不明」とでもコメントを書いておいて、
次のファイルに進みましょう。たぶんそのうち誰かが調べます。

## 作業手順のまとめ

1. 編集するファイルを決める。仮に _builtin/String.rd とする。
1. ASSIGN ファイルの _builtin/String の「OWNER」欄に自分のアカウントを書き込む。
1. ASSIGN ファイルをコミットする。
1. bc-rdoc.rb diff を使って、BitClust データベースに入っていないメソッドをチェックする。
1. bc-rdoc.rb diff -c を使って、BitClust データベースに入っていないメソッドを追加する。
1. _builtin/String.rd を編集する。
1. _builtin/String.rd をコミットする。
1. ASSIGN ファイルの _builtin/String の「STATUS」欄に「done」と書き込む。
1. ASSIGN ファイルをコミットする。

## See Also

* [[ClassReferenceManualFormat]]
* [[BitClust]]
* [[SubversionRepository]]
* [[ProjectResources]]
