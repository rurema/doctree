= String

* String#((<String/split>))は最後の空文字列を削除するので…。

    string = ""
    p string.split(//) #=> []
    
  つねにStringが返るとは限りません。

  最後の空文字列を取り除きたくない場合は、第2引数を指定します。

    string = ""
    p string.split(//, -1) #=> [""]

  ただし、この場合以下のようになることに注意。

    string = "abc"
    p string.split(//, -1) #=> ["a", "b", "c", ""]

* String#((<String/[]>)) は、引数が1つの整数の場合は、整数を返します。文字列ではありません。

    p 'hoge'[2, 1] # => "g"
    p 'hoge'[2] # => 103

* 全角半角の変換で、全角を半角アルファベットにしたいんだけど tr("Ａ-Ｚ","A-Z")ができないのはなぜ？ 

  jcode を require しましょう。

   $ ruby -Ke -rjcode -e 'p "Ａ-Ｚ".tr("Ａ-Ｚ","A-Z")'
   "A-Z"
