require rubygems/command
require rubygems/doc_manager
require rubygems/install_update_options
require rubygems/dependency_installer
require rubygems/local_remote_options
require rubygems/validator
require rubygems/version_option

Gem パッケージをローカルリポジトリにインストールするためのライブラリです。

  Usage: gem install GEMNAME [GEMNAME ...] [options] -- --build-flags [options]
    Options:
          --platform PLATFORM          指定されたプラットフォームの Gem パッケージをインストールします
      -v, --version VERSION            指定されたバージョンの Gem パッケージをインストールします
    Install/Update Options:
      -i, --install-dir DIR            Gem パッケージのインストー先を指定します
      -n, --bindir DIR                 Gem パッケージに含まれるバイナリファイルの配置先を指定します
      -d, --[no-]rdoc                  インストール時に RDoc を生成します
          --[no-]ri                    インストール時に RI ドキュメントを生成します
      -E, --[no-]env-shebang           インストールするスクリプトの shebang line を書き換えます(/usr/bin/env)
      -f, --[no-]force                 依存関係のチェックをバイパスして強制的にインストールします
      -t, --[no-]test                  インストール時にユニットテストを実行します
      -w, --[no-]wrappers              Use bin wrappers for executables
                                       DOSHISH なプラットフォーム上では無効です
      -P, --trust-policy POLICY        Specify gem trust policy
          --ignore-dependencies        依存している Gem パッケージをインストールしません
      -y, --include-dependencies       依存している Gem パッケージをインストールします
          --[no-]format-executable     Make installed executable names match ruby.
                                       If ruby is ruby18, foo_exec will be
                                       foo_exec18
#@include(local_remote_options)
#@include(common_options)
    Arguments:
      GEMNAME       インストールする Gem パッケージ名を指定します
    Summary:
      Gem パッケージをローカルにインストールします
    Defaults:
      --both --version '>= 0' --rdoc --ri --no-force
      --no-test --install-dir /usr/lib/ruby/gems/1.8


= class Gem::Commands::InstallCommand < Gem::Command
include Gem::VersionOption
include Gem::LocalRemoteOptions
include Gem::InstallUpdateOptions

Gem パッケージをローカルリポジトリにインストールするためのクラスです。
