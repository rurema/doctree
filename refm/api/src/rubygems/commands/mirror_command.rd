require rubygems/command

リモートリポジトリをローカルリポジトリにミラーするためのライブラリです。

  Usage: gem mirror [options]
#@include(common_options)
    Summary:
      Gem リポジトリをミラーします
    Description:
      このコマンドは ~/.gemmirrorrc ファイルを使用してリモート Gem リポジトリを
      ローカルにミラーします。設定ファイルは YAML で以下のように書きます。
      
        ---
        - from: http://gems.example.com # source repository URI
          to: /path/to/mirror           # destination directory
      
      複数の取得元と配置先を指定することができます。


= class Gem::Commands::MirrorCommand < Gem::Command

リモートリポジトリをローカルリポジトリにミラーするためのクラスです。
