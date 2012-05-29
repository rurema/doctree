require rubygems/command
require rubygems/version_option
require rubygems/uninstaller

Gem パッケージをアンインストールするためのライブラリです。

Usage: gem uninstall GEMNAME [GEMNAME ...] [options]
  Options:
    -a, --[no-]all                   Uninstall all matching versions
    -I, --[no-]ignore-dependencies   Ignore dependency requirements while
                                     uninstalling
    -x, --[no-]executables           Uninstall applicable executables without
                                     confirmation
    -i, --install-dir DIR            Directory to uninstall gem from
    -n, --bindir DIR                 Directory to remove binaries from
    -v, --version VERSION            Specify version of gem to uninstall
        --platform PLATFORM          Specify the platform of gem to uninstall
#@include(common_options)
  Arguments:
    GEMNAME       アンインストールする Gem パッケージ名を指定します。
  Summary:
    Gem パッケージをアンインストールします
  Defaults:
    --version '>= 0' --no-force --install-dir /usr/lib/ruby/gems/1.8


= class Gem::Commands::UninstallCommand < Gem::Command
include Gem::VersionOption

Gem パッケージをアンインストールするためのクラスです。

