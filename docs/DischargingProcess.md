DischargingProcess
==================

強制的に担当を交代する方法を説明します。
[[ruby-reference-manual:2099](http://www.fdiary.net/ml/ruby-reference-manual/msg/2099)] 以降のスレッドを参照。

0. done になってないライブラリで担当がついているライブラリを探す
1. 奪いたいライブラリについて #@todo を全て無くすようなパッチを書く
2. Pull Requestする
3. 一週間待っても何も無ければPull Requestした人が refm/api/ASSIGN{,.low} を書き換えてコミットする
4. 新担当がマージする

これとは別に、一ヶ月以上放置されているパッチがある場合は、気付いた人があてることが出来る。
ただし、この場合は担当は奪わなくても良い。
