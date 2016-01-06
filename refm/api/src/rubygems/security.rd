require rubygems
require rubygems/gem_openssl

このライブラリは暗号署名を RubyGems パッケージに使用するために使用します。

==== 署名付きの Gem パッケージ

===== 目次

 * 概要
 * 解説
 * コマンドラインオプション
 * OpenSSL リファレンス
 * Bugs / TODO
 * 作者について

===== 概要

このライブラリは暗号署名を RubyGems パッケージに使用するために使用します。
以下のセクションでは、署名付きの Gem パッケージを作成する方法を
ステップバイステップで解説しています。

===== 解説
#@todo メソッドではない

あなたが自分の Gem に署名するためには、秘密鍵と自己署名した証明書が必要です。
以下のコマンドを実行するとそれらを作成することができます。

  # gemmaster@example.com のための秘密鍵と証明書を作成します
  $ gem cert --build gemmaster@example.com

あなたのコンピュータの性能にもよりますが、これには 5 秒から 10 分程度かかります。
(公開鍵を作成するアルゴリズムは世界で一番速いものを使っているわけではない)
それが完了すると、カレントディレクトリに "gem-private_key.pem", "gem-public_cert.pem"
の二つのファイルができます。

まずは、なるべくあなただけがアクセスできる場所に "gem-private_key.pem" を移動させて
ください。 FD, CD-ROM など同じくらい安全なものでかまいません。
そして秘密鍵を秘密のままにしておいてください。もし、それが第三者に漏洩した場合は、
誰かがあなたのフリをしてパッケージに署名することができます。(NOTE: 後述しますが
PKI には盗まれた鍵によるリスクを軽減する方法があります。)

さて、Gem に署名しましょう。この例では Imlib2-Ruby を使用しますが、
あなたは好きな Gem を使用してもいいですよ。あなたの gemspec ファイルを開いて
以下の内容を追加してください。

   # signing key and certificate chain
   s.signing_key = '/mnt/floppy/gem-private_key.pem'
   s.cert_chain  = ['gem-public_cert.pem']

("/mnt/floppy" はあなた自身の秘密鍵の置いてあるパスに読み替えてくださいね。)

それから、いつも通りあなたの Gem をビルドします。
おめでとう！たった今、あなたの最初の署名付き Gem がビルドできました。
出来上がった Gem ファイルの中を覗いてみると、追加されたファイルがあることがわかります。

   $ tar tf tar tf Imlib2-Ruby-0.5.0.gem
   data.tar.gz
   data.tar.gz.sig
   metadata.gz
   metadata.gz.sig

さあ、署名を検証してみましょう。以下のように "-P HighSecurity" オプションを
付けて Gem をインストールしてみてください。

   # install the gem with using the security policy "HighSecurity"
   $ sudo gem install Imlib2-Ruby-0.5.0.gem -P HighSecurity

この -P オプションはセキュリティポリシーを設定します。
このような話をしているうちに…。えーと、なんだ。これは？

   Attempting local installation of 'Imlib2-Ruby-0.5.0.gem'
   ERROR:  Error installing gem Imlib2-Ruby-0.5.0.gem[.gem]: Couldn't
   verify data signature: Untrusted Signing Chain Root: cert =
   '/CN=gemmaster/DC=example/DC=com', error = 'path
   "/root/.rubygems/trust/cert-15dbb43a6edf6a70a85d4e784e2e45312cff7030.pem"
   does not exist'

このエラーの原因はセキュリティポリシーにあります。RubyGems にはいくつかの
異なるセキュリティポリシーがあります。少し休憩してから、セキュリティポリシー
の説明をしましょう。以下に、現在使用可能なセキュリティポリシーの一覧を示します。

: NoSecurity
  なんのセキュリティもありません。署名付きのパッケージも署名無しのパッケージの
  ように扱います。
: LowSecurity
  ほとんどなんのセキュリティもありません。RubyGems は署名付きのパッケージを
  検証しますが、証明書が失効していなければ検証は成功します。悪意のあるユーザは
  このようなセキュリティを簡単に回避することができます。
: MediumSecurity
  LowSecurity, NoSecurity よりも良いですが、まだ不確実です。
  パッケージの内容は、署名付きの証明書に対して検証されます。
  証明書の正当性が検証されます。証明書は残りの証明書チェーンに対して検証されます。
  (あなたが証明書チェーンについて知らない場合は、すぐに説明するので少し待ってください)
  LowSecurity ポリシーからの最大の改善点は MediumSecurity ポリシーは信頼出来ない
  ソースが署名したパッケージをインストールしないことです。
  不幸なことに MediumSecurity ポリシーは完全にセキュアというわけではありません。
  悪意のあるユーザは、署名を外したり、署名なしの Gem を配布すると、 Gem を展開する
  ことができます。
: HighSecurity
  この厄介事は私たちをこんな状態にしました。 HighSecurity ポリシーは
  署名なしの Gem をインストールしないということを除いて MediumSecurity と同じです。
  悪意のあるユーザは、なんの手段も持っていない。悪意のあるユーザは、署名を
  無効にすることなしにパッケージ内容を変更することができません。また、署名を変更したり
  削除したり、証明書チェーンを削除することができません。RubyGems はそのような
  パッケージのインストールを単に拒否します。あー、奴がすっごい強運を持っていたら
  CPAN ユーザに何か問題を引き起こすかもね(笑)


というわけで、RubyGems が我々の輝かしい新しい署名付きの Gem のインストールを拒否した
理由は、それが信頼されていないソースに由来するものだったからなのです。えーと、
私のコードは絶対確実(笑)なので、自分自身を信頼されたソースに追加します。

以下のようにしてください。

    # add trusted certificate
    gem cert --add gem-public_cert.pem

私の公開証明書を信頼されたソースとして追加しました。今では私の秘密鍵で署名した
パッケージを煩わしい事をせずにインストールすることが出来ます。さあ、上述の
インストールコマンドをもう一度実行してください。

  # install the gem with using the HighSecurity policy
  # (今度はなんの問題もありません)
  $ sudo gem install Imlib2-Ruby-0.5.0.gem -P HighSecurity

今回は、RubyGems はあなたの署名付きパッケージを受け入れ、インストールを開始するはずです。
RubyGems が魔法をかけている間に、他のセキュリティに関するコマンドを見ておきましょう。

   Usage: gem cert [options]

   Options:
      -a, --add CERT                   信頼する証明書を追加します。
      -l, --list                       信頼している証明書のリストを表示します。
      -r, --remove STRING              STRING を含む証明書を削除します。
      -b, --build EMAIL_ADDR           EMAIL_ADDR に対する秘密鍵や自己署名証明書を
                                       作成します。
      -C, --certificate CERT           --sign で使用する証明書を指定します。
      -K, --private-key KEY            --sign で使用する秘密鍵を指定します。
      -s, --sign NEWCERT               自分の鍵を用いて証明書に署名します。
  
(ところで、"gem cert --help" を実行するといつでも好きな時に上記のリストの英語版を
見ることが出来ますよ)

ふむ。私たちは、"--build" オプションは既に見ました。 "--add", "--list", "--remove" の
各オプションは極めて直観的ですね。あなたの信頼された証明書のリストに証明書を追加したり、
一覧を出力したり、証明書を削除したりできます。しかし "--sign" オプションとは何でしょうか？

その質問に答えるために、先ほど言及した "証明書チェーン" という概念を見ていきましょう。
自己署名証明書には二つの問題があります。一つは、自己署名証明書が全体のセキュリティを
提供していないことです。もちろん証明書は、まつもとゆきひろと名乗りますが、個人的に
証明書を受け取らない限り、それが本当に matz によって生成されたことをどうやって確認
するのでしょうか？

二つ目の問題は拡張性です。もちろん 50 人の Gem 開発者がいる場合に、50 の証明書を
扱うのは問題ありません。Gem 開発者が 500 人や 1000 人になったらどうなりますか？
信頼された証明書を追加し続けるのは苦痛です。それに、実際はRubyGems ユーザが新しい
証明書を闇雲に信頼することによってこの信頼性システムは安全でなくなってしまいます。

#@# この段落はなんか変
証明書チェーンがどこから来るのか示します。証明書チェーンは、ある発行証明書と
子の証明書の間で適宜長い信頼性の鎖を成立させます。だから私たちは、証明書を
開発者ごとに信頼するかわりに、論理的な信頼の階層を構築する PKI の概念である
証明書チェーンを使用します。信頼の階層の例を図示します。


                         --------------------------
                         | rubygems@rubyforge.org |
                         --------------------------
                                     |
                   -----------------------------------
                   |                                 |
       ----------------------------    -----------------------------
       | seattle.rb@zenspider.com |    | dcrubyists@richkilmer.com |
       ----------------------------    -----------------------------
            |                |                 |             |
     ---------------   ----------------   -----------   --------------
     | alf@seattle |   | bob@portland |   | pabs@dc |   | tomcope@dc |
     ---------------   ----------------   -----------   --------------


さて、4 つの信頼された証明書(alf@seattle, bob@portland, pabs@dc, tomcope@dc)
がありますが、実際にはユーザは、一つの証明書("rubygems@rubyforge.org")を信頼
するだけでいいのです。以下にそれがどのように働くか説明します。

私は "alf@seattle" が署名した "Alf2000-Ruby-0.1.0.gem" をインストールします。
私は "alf@seattle" なんて聞いたこともありませんが、彼の証明書は "seattle.rb@zenspider.com"
の証明書から有効であると証明されています。"seattle.rb@zenspider.com" は
"rubygems@rubyforge.org" から有効であると証明されています。
素晴らしい！要するに、 "rubygems@rubyforge.org" へつながるチェーンを成立させることが
できるので "alf@seattle" によって署名されたパッケージを信頼するのにものすごく便利だということです。

"--sign" オプションはこれらを全て行います。
開発者が "--build" オプションで証明書を作成します。
地方で行われる Ruby 会議や Ruby 勉強会にその証明書を持っていって(例の信頼の階層のように)、
上流の証明書を持っている人に署名してもらいます。あるいは、次回の RubyConf でトップレベルの
証明書を持っている人に署名してもらいます。どちらの場合でも署名をする人は
同じコマンドを実行します。

  # sign a certificate with the specified key and certificate
  # (note that this modifies client_cert.pem!)
  $ gem cert -K /mnt/floppy/issuer-priv_key.pem -C issuer-pub_cert.pem --sign client_cert.pem

発行された証明書の持ち主 (このケースの場合 "alf@seattle") は自分のパッケージに署名するために
この証明書を使用することができます。ところで、みんなに彼の新しい素敵な署名済みの証明書を
知らせるには、"alf@seattle" は彼の gemspec を以下のように変更する必要があります。

  # signing key (still kept in an undisclosed location!)
  s.signing_key = '/mnt/floppy/alf-private_key.pem'
  
  # certificate chain (includes the issuer certificate now too)
  s.cert_chain  = ['/home/alf/doc/seattlerb-public_cert.pem',
                   '/home/alf/doc/alf_at_seattle-public_cert.pem']

言うまでもなく、この RubyGems の信頼基盤はまだ存在していません。
また、「現実世界」でも発行者たちはリクエストがあれば、証明書を発行しています。
この階層システムには証明書を取り消す仕組みが欠けています。
これらの問題は、将来修正されるでしょう。

ここまでに、新しい署名付きの Gem をインストール済みだと思います(あなたが
Rails とその依存している Gem をインストールしている最中でなければ)。
ここでは、学んだことと興味深いことをおさらいしておきましょう。

 * 署名と証明書を用いて Gem をビルドすること
 * 署名をサポートするように既に存在する Gem を修正すること
 * セキュリティポリシーを調整すること
 * 信頼済みの証明書のリストを編集すること
 * 証明書に署名すること

===== コマンドラインオプション

以下に、署名付き Gem に関係するコマンドラインオプションをまとめておきます。

  gem install
    -P, --trust-policy POLICY        Gem の信頼するポリシーを指定します。
  
  gem cert
    -a, --add CERT                   信頼する証明書を追加します。
    -l, --list                       信頼している証明書のリストを表示します。
    -r, --remove STRING              STRING を含む証明書を削除します。
    -b, --build EMAIL_ADDR           EMAIL_ADDR に対する秘密鍵や自己署名証明書を
                                     作成します。
    -C, --certificate CERT           --sign で使用する証明書を指定します。
    -K, --private-key KEY            --sign で使用する秘密鍵を指定します。
    -s, --sign NEWCERT               自分の鍵を用いて証明書に署名します。

それぞれのオプションに関するより詳しい解説は、前節を参照してください。

===== OpenSSL リファレンス

gem cert --build, gem cert --sign を使用して作成できる *.pem ファイルは
基本的な OpenSSL PEM ファイルのみです。以下にいくつかの便利なコマンドを
紹介しておきます。

  X509 フォーマットの PEM ファイルを DER フォーマットに変換する
  (ノート:Windows の *.cer ファイルは X509 証明書の DER フォーマットです) :
  $ openssl x509 -in input.pem -outform der -out output.der

  人間に読みやすいフォーマットで証明書を出力する :
  $ openssl x509 -in input.pem -noout -text

秘密鍵に対しても同じことができます。

  PEM フォーマットの RSA 鍵を DER フォーマットに変換します :
  $ openssl rsa -in input_key.pem -outform der -out output_key.der
  
  鍵を人間に読みやすいフォーマットで出力します :
  $ openssl rsa -in input_key.pem -noout -text

= module Gem::Security

== Singleton Methods

--- add_trusted_cert(cert, options = {}) -> nil

信頼済み証明書リストに与えられた証明書を追加します。

Note: しばらくの間 OPT[:trust_dir] に保存されますが、今後変更される可能性があります。

@param cert 証明書を指定します。

@param options オプションを指定します。

--- build_cert(name, key, options = {}) -> OpenSSL::X509::Certificate

与えられた DN と秘密鍵を使用して証明書を作成します。

@param name DN を指定します。

@param key 秘密鍵を指定します。

@param options オプションを指定します。

--- build_self_signed_cert(email_addr, options = {}) -> Hash

与えられたメールアドレスを元にして自己署名証明書を作成します。

@param email_addr メールアドレスを指定します。

@param options オプションを指定します。

@return 鍵と証明書とそれらを保存したパスを表すハッシュを返します。

--- sign_cert(cert, signing_key, signing_cert, options = {}) -> OpenSSL::X509::Certificate

与えられた署名用の鍵と証明書を用いて証明書に署名します。

@param cert 署名する証明書を指定します。

@param signing_key 署名にしようする鍵を指定します。

@param signing_cert 署名に使用する証明書を指定します。

@param options オプションを指定します。

@return 署名された証明書を返します。

--- verify_trust_dir(path, perms)
#@# -> discard
信頼するディレクトリが存在することを確認します。

与えられたパスが存在する場合、ディレクトリであることを確認します。
そうでない場合は、ディレクトリを作成してパーミッションを変更します。

@param path 確認するパスを指定します。

@param perms ディレクトリを作成する場合のパーミッションを指定します。

@raise Gem::Security::Exception path がディレクトリでない場合に発生します。

== Constants

--- AlmostNoSecurity -> Gem::Security::Policy

ほとんどの検証を行わないポリシーです。

署名されたデータの検証のみ行います。

このポリシーは何もしないよりはマシですが、ほとんど役に立たない上、
簡単に騙すことができるので、使用しないでください。

    :verify_data      => true,
    :verify_signer    => false,
    :verify_chain     => false,
    :verify_root      => false,
    :only_trusted     => false,
    :only_signed      => false

--- HighSecurity -> Gem::Security::Policy

高レベルのセキュリティポリシーです。

署名された Gem のみインストール可能です。

ルート証明書のみを信頼して、全ての検証を行います。
ただし、信頼するように指定された証明書は信頼します。

このセキュリティポリシーはバイパスするのがものすごく困難です。

    :verify_data      => true,
    :verify_signer    => true,
    :verify_chain     => true,
    :verify_root      => true,
    :only_trusted     => true,
    :only_signed      => true

--- LowSecurity -> Gem::Security::Policy

低レベルのセキュリティのポリシーです。

署名されたデータと署名者の検証を行います。

このポリシーは何もしないよりはマシですが、ほとんど役に立たない上、
簡単に騙すことができるので、使用しないでください。


    :verify_data      => true,
    :verify_signer    => true,
    :verify_chain     => false,
    :verify_root      => false,
    :only_trusted     => false,
    :only_signed      => false

--- MediumSecurity -> Gem::Security::Policy

中レベルのセキュリティポリシーです。

ルート証明書のみを信頼して、全ての検証を行います。
ただし、信頼するように指定された証明書は信頼します。

このポリシーは便利ですが、署名無しのパッケージを許可しているので、
邪悪な人物がパッケージの署名を単純に削除して検証をパスさせることができます。

    :verify_data      => true,
    :verify_signer    => true,
    :verify_chain     => true,
    :verify_root      => true,
    :only_trusted     => true,
    :only_signed      => false

--- NoSecurity -> Gem::Security::Policy

セキュリティなしのポリシーです。

全ての検証を行いません。

    :verify_data      => false,
    :verify_signer    => false,
    :verify_chain     => false,
    :verify_root      => false,
    :only_trusted     => false,
    :only_signed      => false

--- OPT -> Hash

ほとんどのメソッドで使用するデフォルトのオプションを返します。

--- Policies -> Hash

使用可能なポリシーの一覧を返します。

 * [[m:Gem::Security::NoSecurity]]
 * [[m:Gem::Security::AlmostNoSecurity]]
 * [[m:Gem::Security::LowSecurity]]
 * [[m:Gem::Security::MediumSecurity]]
 * [[m:Gem::Security::HighSecurity]]

= class Gem::Security::Policy

署名付きの Gem パッケージを検証するための設定をカプセル化しているクラスです。

ポリシーオブジェクトとしてこのクラスのインスタンスや、
このライブラリで定義済みの定数を使用することができます。

== Public Instance Methods

--- only_signed -> bool

この値が真である場合は、署名付きの Gem のみインストールします。

--- only_signed=(flag)

署名付きの Gem のみインストールするかどうかを設定します。

@param flag 真、または偽を指定します。

--- only_trusted -> bool

この値が真である場合は、検証済みの Gem のみインストールします。

--- only_trusted=(flag)

検証済みの Gem のみインストールするかどうかを設定します。

@param flag 真、または偽を指定します。

--- verify_chain -> bool

この値が真である場合は、証明書チェーンを検証します。

--- verify_chain=(flag)

証明書チェーンを検証するかどうかを設定します。

@param flag 真、または偽を指定します。

--- verify_data -> bool

この値が真である場合は、データを検証します。

--- verify_data=(flag)

データを検証するかどうかを設定します。

@param flag 真、または偽を指定します。

--- verify_gem(signature, data, chain, time = Time.now) -> Array

与えられたデータを与えられた署名と証明書チェーンで検証します。

@param signature 署名を指定します。

@param data 検証するデータを指定します。

@param chain 検証で使用する証明書チェーンを指定します。

@param time この時刻に有効であることを検証する。

@raise Gem::Security::Exception 検証に失敗した場合に発生します。


--- verify_root -> bool

この値が真である場合は、証明書チェーンのルートを検証します。

--- verify_root=(flag)

証明書チェーンのルートを検証するかどうかを設定します。

@param flag 真、または偽を指定します。

--- verify_signer -> bool

この値が真である場合は、署名者を検証します。

--- verify_signer=(flag)

署名者を検証するかどうかを設定します。

@param flag 真、または偽を指定します。

== Singleton Methods

--- new(policy = {}, options = {}) -> Gem::Security::Policy

@param policy モードを指定します。

@param options その他のオプションを指定します。

--- trusted_cert_path(cert, options) -> String

与えられた証明書へのパスを返します。

@param cert 証明書オブジェクトを指定します。

@param options その他のオプションを指定します。


= class Gem::Security::Signer

OpenSSL の署名者を扱うためのクラスです。

== Public Instance Methods

--- key -> OpenSSL::PKey::PKey

鍵を返します。

--- key=(key)

鍵をセットします。

--- cert_chain -> Array

証明書チェーンを返します。

--- cert_chain=(cert_chain)

証明書チェーンをセットします。

@param cert_chain 証明書チェーンを指定します。

--- sign(data)
#@# -> discard
自身に設定済みのダイジェストアルゴリズムを用いて与えられたデータに署名します。

@param data 署名対象のデータを指定します。

== Singleton Methods

--- new(key, cert_chain) -> Gem::Security::Signer

与えられた鍵と証明書チェーンを用いて自身を初期化します。

@param key 鍵を指定します。

@param cert_chain 証明書チェーンを指定します。

= class Gem::Security::Exception < Gem::Exception

セキュリティ関連のエラーを表します。
