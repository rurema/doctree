# Mac OS X

Apple の OS です。現在は macOS と呼ばれています (旧称は Mac OS X、OS X)。Mac OS X の X は 10 を表し、「マックオーエステン」と読みます。

Ruby は Apple silicon (arm64) と Intel (x86_64) のどちらにも対応しています。
保守担当者 (platform maintainer) がいるプラットフォームのひとつです。

Ruby のコンパイルには C コンパイラが必要です。OpenSSL などの依存ライブラリを Homebrew で入れた場合は、`configure` に `--with-openssl-dir=$(brew --prefix openssl@3)` のように指定します。
手順の詳細は Ruby のソースツリーの `doc/contributing/building_ruby.md` を参照してください。

macOS には Ruby が添付されていますが、新しい版を使うには、パッケージマネージャやバージョンマネージャで Ruby をインストールします。詳しくは「Rubyのインストール」(<https://www.ruby-lang.org/ja/documentation/installation/>)を参照してください。

#%since 4.1
Ruby 4.1 は Mac OS X 10.6 以降を必要とします。Mac OS X 10.5 までと PowerPC Mac は対象外です。
#%end

削除されたプラットフォームの一覧は [d:platform/index] を参照してください。
