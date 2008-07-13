require webrick/version
require webrick/httpversion
require webrick/httputils
require webrick/utils
require webrick/log

= module WEBrick::Config

色々なクラスの設定のデフォルト値を提供するモジュールです。

== Constants

--- General

[[c:WEBrick::GenericServer]] の設定のデフォルト値を保持したハッシュです。

  WEBrick::Config::General = {
    :ServerName     => Utils.getservername,
    :BindAddress    => nil,   # "0.0.0.0" or "::" or nil
    :Port           => nil,   # users MUST specifiy this!!
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

--- HTTP

[[m:WEBrick::HTTPServer]] の設定のデフォルト値を保持したハッシュです。

  HTTP = {
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

--- FileHandler
#@todo

--- BasicAuth
#@todo

--- DigestAuth
#@todo

--- LIBDIR
#@todo
