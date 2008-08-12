
RubyGems で使用する例外クラスを定義したライブラリです。

= class Gem::Exception < RuntimeError

RubyGems で扱う全ての例外のスーパークラスです。

= class Gem::CommandLineError < Gem::Exception

コマンドラインの例外です。

= class Gem::DependencyError < Gem::Exception

依存関係の例外です。

= class Gem::DependencyRemovalException < Gem::Exception

???

= class Gem::GemNotInHomeException < Gem::Exception

???

= class Gem::DocumentError < Gem::Exception

???

= class Gem::EndOfYAMLException < Gem::Exception

???

= class Gem::FilePermissionError < Gem::Exception

ファイルの権限に関する例外です。

= class Gem::FormatException < Gem::Exception

フォーマットに関する例外です。

= class Gem::GemNotFoundException < Gem::Exception

Gem が見つからなかった場合の例外です。

= class Gem::InstallError < Gem::Exception

???

= class Gem::InvalidSpecificationException < Gem::Exception

不正な gemspec に関する例外です。

= class Gem::OperationNotSupportedError < Gem::Exception

???

= class Gem::RemoteError < Gem::Exception

???

= class Gem::RemoteInstallationCancelled < Gem::Exception

???

= class Gem::RemoteInstallationSkipped < Gem::Exception

???

= class Gem::RemoteSourceException < Gem::Exception

???

= class Gem::VerificationError < Gem::Exception

???

= class Gem::SystemExitException < SystemExit

???
