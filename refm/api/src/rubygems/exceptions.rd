
RubyGems で使用する例外クラスを定義したライブラリです。

= class Gem::Exception < RuntimeError

RubyGems で扱う全ての例外のスーパークラスです。

= class Gem::CommandLineError < Gem::Exception

コマンドラインの例外です。

= class Gem::DependencyError < Gem::Exception

依存関係の例外です。

= class Gem::DependencyRemovalException < Gem::Exception

Gem を削除出来なかった場合に使用する例外です。

= class Gem::GemNotInHomeException < Gem::Exception

Gem が適切なディレクトリにインストールされていない場合に使用する例外です。

= class Gem::DocumentError < Gem::Exception

システムに RDoc がインストールされていない場合に使用する例外です。

= class Gem::EndOfYAMLException < Gem::Exception

YAML データが不正である場合に使用する例外です。

= class Gem::FilePermissionError < Gem::Exception

ファイルの権限に関する例外です。

= class Gem::FormatException < Gem::Exception

フォーマットに関する例外です。

= class Gem::GemNotFoundException < Gem::Exception

Gem が見つからなかった場合の例外です。

= class Gem::InstallError < Gem::Exception

何らかの理由で Gem をインストール出来なかった場合に使用する例外です。

= class Gem::InvalidSpecificationException < Gem::Exception

不正な gemspec に関する例外です。

= class Gem::OperationNotSupportedError < Gem::Exception

サポートされていない操作を行った場合に使用する例外です。

= class Gem::RemoteError < Gem::Exception
#@# 現在使用されていない

リモートで問題が発生した場合に使用する例外です。

= class Gem::RemoteInstallationCancelled < Gem::Exception
#@# 現在使用されていない

???

= class Gem::RemoteInstallationSkipped < Gem::Exception
#@# 現在使用されていない

???

= class Gem::RemoteSourceException < Gem::Exception

HTTP 経由でネットワークにアクセス出来ない場合に使用する例外です。

= class Gem::VerificationError < Gem::Exception

Gem の検証でエラーになった場合に使用する例外です。

= class Gem::SystemExitException < SystemExit

何らかの理由でコマンドを実行出来ない場合に使用する例外です。
