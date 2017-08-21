require webrick/httpversion
require webrick/httputils
require webrick/utils
require webrick/log

= module WEBrick::Config

色々なクラスの設定のデフォルト値を提供するモジュールです。

== Constants

--- General -> Hash

[[c:WEBrick::GenericServer]] の設定のデフォルト値を保持したハッシュです。

  require 'webrick'
  WEBrick::Config::General = {
    :ServerName     => Utils.getservername,
    :BindAddress    => nil,   # "0.0.0.0" or "::" or nil
    :Port           => nil,   # users MUST specify this!!
    :MaxClients     => 100,   # maximum number of the concurrent connections
    :ServerType     => nil,   # default: WEBrick::SimpleServer
    :Logger         => nil,   # default: WEBrick::Log.new
    :ServerSoftware => "WEBrick/#{WEBrick::VERSION} " +
                       "(Ruby/#{RUBY_VERSION}/#{RUBY_RELEASE_DATE})",
    :TempDir        => ENV['TMPDIR']||ENV['TMP']||ENV['TEMP']||'/tmp',
    :DoNotListen    => false,
    :StartCallback  => nil,
    :StopCallback   => nil,
    :AcceptCallback => nil,
#@since 2.4.0
    :DoNotReverseLookup => true,
#@else
    :DoNotReverseLookup => nil,
#@end
  }

--- HTTP -> Hash

[[c:WEBrick::HTTPServer]] の設定のデフォルト値を保持したハッシュです。

  require 'webrick'
  WEBrick::Config::HTTP = {
    :ServerName     => Utils.getservername,
    :BindAddress    => nil,   # "0.0.0.0" or "::" or nil
    :Port           => 80,
    :MaxClients     => 100,   # maximum number of the concurrent connections
    :ServerType     => nil,   # default: WEBrick::SimpleServer
    :Logger         => nil,   # default: WEBrick::Log.new
    :ServerSoftware => "WEBrick/#{WEBrick::VERSION} " +
                       "(Ruby/#{RUBY_VERSION}/#{RUBY_RELEASE_DATE})",
    :TempDir        => ENV['TMPDIR']||ENV['TMP']||ENV['TEMP']||'/tmp',
    :DoNotListen    => false,
    :StartCallback  => nil,
    :StopCallback   => nil,
    :AcceptCallback => nil,
#@since 2.4.0
    :DoNotReverseLookup => true,
#@else
    :DoNotReverseLookup => nil,
#@end

    :RequestTimeout => 30,
    :HTTPVersion    => HTTPVersion.new("1.1"),
    :AccessLog      => nil,
    :MimeTypes      => HTTPUtils::DefaultMimeTypes,
    :DirectoryIndex => ["index.html","index.htm","index.cgi","index.rhtml"],
    :DocumentRoot   => nil,
    :DocumentRootOptions => { :FancyIndexing => true },
    :RequestCallback => nil,
    :ServerAlias    => nil,

    :CGIInterpreter => nil,
    :CGIPathEnv     => nil,

    :Escape8bitURI  => false
  }

--- FileHandler -> Hash

[[c:WEBrick::HTTPServlet::FileHandler]] の設定のデフォルト値を保持したハッシュです。

    require 'webrick'
    WEBrick::Config::FileHandler = {
      :NondisclosureName => [".ht*", "*~"],
      :FancyIndexing     => false,
      :HandlerTable      => {},
      :HandlerCallback   => nil,
      :DirectoryCallback => nil,
      :FileCallback      => nil,
      :UserDir           => nil,  # e.g. "public_html"
      :AcceptableLanguages => []  # ["en", "ja", ... ]
    }

: :AcceptableLanguages

コンテンツの言語を選択するオプション。設定値は文字列の配列。

クライアントからのリクエストに含まれるAccept-Languageの内容がfrで、
かつ:AcceptableLanguagesには['ja', 'en']が設定されている場合、
WEBrick::HTTPServlet::FileHandlerは以下の順番でファイルを探す。
  (1) index.html
  (2) index.html.fr
  (3) index.html.ja
  (4) index.html.en

: :FancyIndexing
クライアントがディレクトリをリクエストしたが表示するファイルが無い場合の挙動を決める。
値は真偽値。

trueならば、代わりにファイル一覧を表示する。
falseならばエラー(403 Forbidden)となる。

: :DirectoryCallback
: :FileCallback
: :HandlerCallback
: :HandlerTable
: :NondisclosureName
インデックスに表示したくないファイルの指定。値は文字列の配列。
表示したくないファイルをワイルドカードで指定する。

: :UserDir
ユーザ毎のドキュメントルートのディレクトリ名。値は文字列。

ユーザfooのホームディレクトリが/home/fooで、:UserDirにpublic_htmlを設定した場合、
クライアントから/~foo/index.htmlがリクエストされると/home/foo/public_html/index.htmlの内容を表示される。

この設定を有効にするには以下の条件が必要。
  * [[lib:etc]]ライブラリが使える状態である。
  * 環境変数 SCRIPT_NAME が空(空文字列)である。

--- BasicAuth -> Hash

[[c:WEBrick::HTTPAuth::BasicAuth]] の設定のデフォルト値を保持したハッシュです。

    require 'webrick'
    WEBrick::Config::BasicAuth = {
      :AutoReloadUserDB     => true,
    }

--- DigestAuth -> Hash

[[c:WEBrick::HTTPAuth::DigestAuth]] の設定のデフォルト値を保持したハッシュです。

    require 'webrick'
    WEBrick::Config::DigestAuth = {
      :Algorithm            => 'MD5-sess', # or 'MD5'
      :Domain               => nil,        # an array includes domain names.
      :Qop                  => [ 'auth' ], # 'auth' or 'auth-int' or both.
      :UseOpaque            => true,
      :UseNextNonce         => false,
      :CheckNc              => false,
      :UseAuthenticationInfoHeader => true,
      :AutoReloadUserDB     => true,
      :NonceExpirePeriod    => 30*60,
      :NonceExpireDelta     => 60,
      :InternetExplorerHack => true,
      :OperaHack            => true,
    }

--- LIBDIR -> String

このファイルのあるディレクトリのパスを返します。

