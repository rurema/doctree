require rubygems/command
require rubygems/security

Gem パッケージの証明書や署名の設定を管理するためのライブラリです。

  Usage: gem cert [options]
    Options:
      -a, --add CERT                   信頼された証明書を追加します
      -l, --list                       信頼されている証明書の一覧を表示します
      -r, --remove STRING              STRING を含む証明書を削除します
      -b, --build EMAIL_ADDR           EMAIL_ADDR に対する自己署名証明書と秘密鍵
                                       を作成します
      -C, --certificate CERT           --sign で使用する証明書を指定します
      -K, --private-key KEY            --sign で使用する秘密鍵を指定します
      -s, --sign NEWCERT               証明書に秘密鍵で署名します
#@include(common_options)
    Summary:
      Manage RubyGems certificates and signing settings


= class Gem::Commands::CertCommand < Gem::Command

Gem パッケージの証明書や書名の設定を管理するためのクラスです。



