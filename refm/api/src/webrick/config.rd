require webrick/httpversion
require webrick/httputils
require webrick/utils
require webrick/log

= module WEBrick::Config

色々なクラスの設定のデフォルト値を提供するモジュールです。

== Constants

--- General -> Hash

[[c:WEBrick::GenericServer]] の設定のデフォルト値を保持したハッシュです。

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
    :DoNotReverseLookup => nil,
  }

--- HTTP -> Hash

[[c:WEBrick::HTTPServer]] の設定のデフォルト値を保持したハッシュです。

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
    :DoNotReverseLookup => nil,

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


--- BasicAuth -> Hash

[[c:WEBrick::HTTPAuth::BasicAuth]] の設定のデフォルト値を保持したハッシュです。

    WEBrick::Config::BasicAuth = {
      :AutoReloadUserDB     => true,
    }

--- DigestAuth -> Hash

[[c:WEBrick::HTTPAuth::DigestAuth]] の設定のデフォルト値を保持したハッシュです。

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
#@todo
