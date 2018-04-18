= セキュリティモデル

RubyにはCGI等のプログラミングを安全に行うことを助ける為に、セキュリティ
機構が備わっています。

Rubyのセキュリティモデルは「オブジェクトの汚染」と「セーフレベル」という
仕組みによってなりたっています。

=== オブジェクトの汚染

Rubyではオブジェクトは「汚染されている」とみなされることがあります。この
しくみは大きく分けて二つの使われ方をします。

ひとつ目は、信用できない入力をもとに作られたオブジェクトを「汚染されてい
る」とみなし、「危険な操作」の引数として使えないようにすることです。悪意
あるデータによって、プログラムが意図しない動作をする事を防ぐことを目的と
しています。

もうひとつは、信用しているオブジェクト(汚染されていないオブジェクト)を
信用できないプログラムから守るという使い方です。
#@until 2.1.0
セーフレベル4で汚染されていないオブジェクトへの操作が大幅に制限されるの
はこの事を意図しています。
#@end

オブジェクトの汚染に関連するメソッド

:  Object#taint
     オブジェクトを汚染する

:  Object#tainted?
     オブジェクトが汚染されている場合に真を返す

:  Object#untaint
     オブジェクトの汚染を取り除く

=== セーフレベル

各スレッドは固有の「セーフレベル」を持っています。セーフレベルが高くなるほ
ど、行える操作は制限されます。セーフレベルはスレッドローカル変数 [[m:$SAFE]] で
設定します。

[[ruby-list:37415]]

[[m:$SAFE]] に関するルール

  * プログラム開始時の$SAFEの値は0
  * 各スレッドは作られた時点での親スレッドの$SAFEの値を引き継ぐ
//emlist{
      $SAFE = 1
      th = Thread.new{
        p $SAFE #=> 1
        $SAFE = 3
      }
      th.join
      p $SAFE #=> 1
//}
  * $SAFE の値を現在の値より小さく変更する事はできない
//emlist{
      $ ruby -e '$SAFE = 1; $SAFE = 0'
      -e:1: tried to downgrade safe level from 1 to 0 (SecurityError)
//}
原則として、各セキュリティレベルにはそれ以下のセキュリティレベルの制限も
適用されます。たとえばレベル1で許されない操作はレベル2でも行えません。

==== レベル 0

デフォルトのセーフレベルです。

===== 汚染されるオブジェクト

   * IOや環境変数、コマンドライン引数(ARGV)から得られた文字列

       $ ruby -e 'p ARGV[0].tainted?' hoge
       true

環境変数PATHだけは例外で、値に危険なパスを含む場合のみ汚染されます。

ここでは危険なパスとは誰でも変更／書き込みが可能なパスをいいます。
ルートディレクトリから階層が順番にチェックされ、一箇所でも誰でも
変更可能な個所があればそのパスは危険とみなされます。

なお、DOSISH(DOSとWindows)、cygwin では権限をチェックしません。

===== 禁止される操作

   * 特になし

==== レベル 1

信用しているプログラムで信用できないデータを処理する為のレベルです。
CGI等でユーザからの入力を処理するのに適しています。

===== 汚染されるオブジェクト

   * レベル0と同様

===== 禁止される操作
   * 汚染された文字列を引数とした以下の操作

      * [[c:Dir]], [[c:IO]], [[c:File]], [[c:FileTest]] のメソッド呼び出し
//emlist{
          $ ruby -e '$SAFE = 1; open(ARGV[0])' hoge
          -e:1:in `initialize': Insecure operation - initialize (SecurityError)
                  from -e:1
//}
      * ファイルテスト演算子の使用、ファイルの更新時刻比較
      * 外部コマンド実行 ([[m:Kernel.#system]], [[m:Kernel.#exec]], [[m:Kernel.#`]], [[m:Kernel.#spawn]] など)
      * [[m:Kernel.#eval]]
#@until 2.1.0
        ([[ref:level4]]の説明も参照)
#@end
      * トップレベルへの [[m:Kernel.#load]] (第二引数を指定してラップすれば実行可能)
      * [[m:Kernel.#require]]
      * [[m:Kernel.#trap]]


==== レベル 2

#@since 2.3.0
廃止されました。
#@else
===== 汚染されるオブジェクト

   * レベル1と同様

=====  禁止される操作
レベル1の制限に加え、以下の操作が禁止されます。

   * [[m:Dir.chdir]] [[m:Dir.chroot]] [[m:Dir.mkdir]] [[m:Dir.rmdir]]
   * [[m:File.chown]] [[m:File.chmod]] [[m:File.umask]] [[m:File.truncate]]
     [[m:File#lstat]] [[m:File#chmod]] [[m:File#chown]] [[m:File.delete]] [[m:File.unlink]]
     [[m:File#truncate]] [[m:File#flock]]
     および [[c:FileTest]] モジュールのメソッド
   * [[m:IO#ioctl]], [[m:IO#fcntl]]
   * [[m:Process.fork]] [[m:Process.#setpgid]] [[m:Process.#setsid]]
     [[m:Process.#setpriority]] [[m:Process.#egid=]] [[m:Process.#kill]]
   * 危険なパスからの [[m:Kernel.#load]]
   * 汚染された文字列を引数にしての [[m:Kernel.#load]] (ラップされていても)
   * [[m:Kernel.#syscall]]
   * [[m:Kernel.#exit!]]
   * [[m:Kernel.#trap]]
#@end

==== レベル 3

#@since 2.3.0
廃止されました。
#@else
生成される全てのオブジェクトが汚染されます。
#@until 2.1.0
レベル4でプログラムを実行する環境を作り上げるのに適しています。
#@end

===== 汚染されるオブジェクト

   * 生成される全てのオブジェクト

===== 禁止される操作
レベル2の制限に加え、以下の操作が禁止されます。

   * [[m:Object#untaint]]
#@end

====[a:level4] レベル 4

#@since 2.1.0
廃止されました。
#@else
信用することのできないプログラムを実行するためのレベルです。

レベル4は信頼できないプログラムによる危険な操作をほぼ全て検出できますが、
完全な安全性は保証されません。

このレベルではレベル3では禁止されている「汚染された文字列のeval」が許可
されています。([[m:Kernel.#eval]] で実行すると危険な操作は全て禁止されているからです。)

===== 汚染されるオブジェクト

   * レベル3と同様

===== 禁止される操作

レベル3の制限(上記のとおりevalは除く)に加え、以下の操作が禁止されます。

   * [[m:Object#taint]]
   * トップレベルの定義の変更([[m:Kernel.#autoload]], [[m:Kernel.#load]], [[m:Module#include]])
   * 既存のメソッドの再定義
   * [[c:Object]] クラスの定義の変更
   * 汚染されていないクラスやモジュールの定義の変更およびクラス変数の変更
   * 汚染されていないオブジェクトの状態の変更
   * グローバル変数の変更
   * 汚染されていない [[c:IO]] や [[c:File]] を使用する処理
   * [[c:IO]] への出力
   * プログラムの終了([[m:Kernel.#exit]], [[m:Kernel.#abort]])
     (なお out of memory でも fatal にならない)
   * 他のスレッドに影響が出る [[c:Thread]] クラスの操作および他のスレッドの [[m:Thread#[] ]]
   * [[m:ObjectSpace.#_id2ref]]
#@since 1.8.0
   * [[m:ObjectSpace.#each_object]]
#@end
   * 環境変数の変更
   * [[m:Kernel.#srand]]
#@end

=== セーフレベルに関するその他の詳細

   * requireは$SAFE = 0で実行される
   * Level 1以上では起動時に以下の違いがある
//emlist{
      * 環境変数 RUBYLIB を $: に加えない
      * 環境変数 RUBYOPT を処理しない
      * 以下のスイッチを使用できない
        -s -S -e -r -i -I -x
        (スクリプトがsetgid, setuidされている時も同様)
      * 標準入力からのプログラム読み込みを行わない
        (スクリプトがsetgid, setuidされている時も同様)
//}
   * setuid, setgid されたスクリプトは $SAFE = 1 以上で実行される。
   * [[c:Proc]] はその時点でのセーフレベルを記憶する。
     その [[c:Proc]] オブジェクトが call されると、記憶していたセーフレベルで実行される。
   * 汚染された文字列を第二引数に指定して [[m:Kernel.#trap]]/[[m:Kernel.#trace_var]] を
     実行するとその時点で例外 [[c:SecurityError]] が発生する。
   * 実装の都合上 [[c:Fixnum]], [[c:Symbol]], true, false, nil は汚染されない。
     なお [[c:Bignum]], [[c:Float]] は汚染されることは注意が必要。

=== 使用例

一旦高くした$SAFEレベルを低く変更する事はできませんが、以下のようにスレッ
ドを使うことで、プログラムの一部だけを高いセーフレベルで実行することが可
能です。

例:

     def safe(level)
       result = nil
       Thread.start {
         $SAFE = level
         result = yield
       }.join
       result
     end

     lib = "insecure_library".taint # 外部から受け取った文字列(仮)
     safe(1) { require lib }        # $SAFE が 1 なので例外
     require lib                    # 外側は影響を受けない

=== 拡張ライブラリでの扱い

 * 拡張ライブラリではオブジェクトの汚染状態を適切に伝播させる必要があります。
 * グローバルな状態を変更する場合や外部とのやりとりの前にセキュリティレベルを
   チェックする必要があります。

@see [[ruby-list:37407]]
