###nonref

= 執筆者募集

下の「((<Link|URL:index.cgi?cmd=view;name=%BC%B9%C9%AE%BC%D4%CA%E7%BD%B8;num_links=all%23link#link>))」で参照されるページにRubyリファレンスマニュアルの記述が不完
全な部分が含まれています。

あなたの記述をみんな待ってます。よろしくお願いします。

((<RD>))というフォーマットで書きます。

== 執筆の心得

(1) できるだけリンクを張る。(ただし同じ言葉に対してのリンクはうるさくなら
    ないように)
    * リンクの張り方

      ((<String>))
        ((<String>))
      ((<String#gsub|String/gsub>))
        ((<String#gsub|String/gsub>))
      ((<String/gsub>))
        ((<String/gsub>))
      ((<mailread>))
        ((<mailread>))
      ((<mailread/Mail.new>))
        ((<mailread/Mail.new>))
      ((<"net/http">))
        ((<"net/http">))
      ((<URL:http://www.ruby-lang.org/ja/man/>))
        ((<URL:http://www.ruby-lang.org/ja/man/>))
      ((<Rubyリファレンスマニュアル|URL:http://www.ruby-lang.org/ja/man/>))
        ((<Rubyリファレンスマニュアル|URL:http://www.ruby-lang.org/ja/man/>))
      ((<"縦棒「|」を含むリンク"|URL:http://www.ruby-lang.org/ja/man/>))
        ((<"縦棒「|」を含むリンク"|URL:http://www.ruby-lang.org/ja/man/>))
      ((<"ruby-src:sample/sieve.rb">))
        ((<"ruby-src:sample/sieve.rb">))

(1) 記述を追加したいが内容に関していまいち自信がなかったりする場合、以下の
    いずれかの方法で問い合わせる
    * footnote に (('((- これであってる？-))')) などと書く
    * マニュアル執筆編集に関する議論をするためのメーリングリスト
      rubyist@freeml.com(((<参加方法|URL:http://www.freeml.com/ml_info.php?ml=rubyist>)), ((<アーカイブ|URL:http://www.freeml.com/ctrl/html/MessageListForm/rubyist@freeml.com>)))
      に確認する。
    * 広くRubyコミュニティと議論したい場合は
      ((<ruby-list ML|URL:http://www.ruby-lang.org/ja/20020104.html>)) に
      「この記述怪しいんですが…。」などと問い合わせる。
    * MLに参加してない人は((<あらい|URL:mailto:jca02266@nifty.ne.jp>))宛
      に直接問い合わせても構わないです。

      * 記述内容にわかりにくい箇所とかもあれば上記の方法で問い合わせてくだ
        さいませ。できるだけ改善したいと思います。

(1) メソッドの記述には「---」ではじめるリスト ((<MethodList|URL:http://www2.pos.to/~tosh/ruby/rdtool/ja/doc/rd-draft.html#label:28>)) を使います。以下の例を参照して下さい。

 #
 --- Array#each {|i| ... } 
     各項目に対してブロックを評価する。

--- Array#each {|i| ... } 
    各項目に対してブロックを評価する。

さらに詳しくは ((<ruby-list:24445>)) などを参照して下さい。

文章中の引数名に関しては (('((|variable|))')) と書くと、 
((|variable|)) ((('<var>variable</var>'))) とマークアップされます。

== その他雑多なこと

その他雑多なことに関しては ((<Manuals' style|URL:http://pub.cozmixng.org/~the-rwiki/rw-cgi.rb?cmd=view;name=Manuals%27+style>))も参照してください。

((<作業中のページ>))

((<ToDo>))
