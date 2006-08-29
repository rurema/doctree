= ブロック付きメソッド呼び出し

* 配列内の値の変換
    a = [1,2,3]
    a.each{|item| item = item + 10} # 誤り
    a.collect!{|item| item + 10}
  代入した時点で元の item (配列に格納されているもの)とは別の
  オブジェクトをさすためです。従って、

    a = ['a','b','c']
    a.each{|item| item.replace('x')}

  など、破壊的メソッドは有効となります。

* 逆に自作のオブジェクトのeachを作るときにyieldに渡したオブジェクトを
  yield後にeachの中で変更するとsortやcollectが変になることがある。
