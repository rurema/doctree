= Regexp
* \wに日本語文字も含まれるが、$KCODEを適切に設定するか、
  個別に指定する必要がある。
  (\bは\wと\Wを表す幅0の正規表現。)

    # euc-jpの環境の場合
    /a\b/ === 'あaあ'  #=> 2
    /\ba/ === 'あaあ'  #=> nil
    /\ba/e === 'あaあ' #=> nil
    /\ba/e === 'あaあ' #=> nil

    # Shift_JISの環境の場合
    /a\b/ === 'あaあ'  #=> 3
    /\ba/ === 'あaあ'  #=> nil
    /\ba/s === 'あaあ' #=> nil
    /\ba/s === 'あaあ' #=> nil

* Regexp#eql?とRegexp#hashは定義されていない
  (Object#eql?とObject#hashが使われる)ので、
  Hashのキーには向いていません。

    //.eql? // #=> false

    2003-05-07: 現在は定義されています。

    p(//.eql?(//))
    => ruby 1.6.8 (2002-12-24) [i586-linux]
       false
    => ruby 1.7.3 (2002-12-11) [i586-linux]
       false
    => ruby 1.8.0 (2002-12-31) [i586-linux]
       true

* ある文字列を含む正規表現を作る場合には
  ((<Regexp#quote|Regexp/quote>))する必要があります。
  ((-セキュリティホールになる可能性もあるので十分注意してください。-))

    a = 'a.c'
    /^#{a}$/ === 'abc'              #=> 0   (マッチした)
    /^#{Regexp.quote a}$/ === 'abc' #=> nil (マッチしない)

* Perlでは正規表現 $ にマッチできる箇所が文字列末尾の "\n" の中に2カ所
  ありますが、Rubyでは1カ所しかありません。(が、ruby 1.8 で Perl に
  従うようになりました。((<ruby-dev:20125>)))

      # Perl では $ は改行の前と文字列末尾にマッチする
      % perl -e '$s = "\n"; $s =~ s/$/o/g;   print "[$s]\n";'
      [o
      o]

      # Ruby では $ は改行の前にしかマッチしない
      % ruby -e '$s = "\n"; $s.gsub!(/$/, "o"); print "[#$s]\n"'
      [o
      ]

      % ruby-1.8.0-2003-05-01 -v -e '$s = "\n"; $s.gsub!(/$/, "o"); print "[#$s]\n"'
      ruby 1.8.0 (2003-05-01) [i586-linux]
      [o
      o]
