[[c:Shell]] で使用するビルトインコマンドを定義しているライブラリです。

= class Shell::BuiltInCommand < Shell::Filter

クラスとして実装されている全てのビルトインコマンドのスーパークラスです。

== Instance Methods

--- active? -> true
#@todo

--- wait?   -> false
#@todo

= class Shell::AppendFile < Shell::AppendIO

== Singleton Methods

--- new(sh, filename)
#@todo

== Instance Methods

--- input=(filter)
#@todo

= class Shell::AppendIO < Shell::BuiltInCommand

== Singleton Methods

--- new(sh, filename)
#@todo

== Instance Methods

--- input=(filter)
#@todo


= class Shell::Cat < Shell::BuiltInCommand

== Singleton Methods

--- new(sh, *filenames)
#@todo

== Instance Methods

--- each(rs = nil){|line| ... }
#@todo

= class Shell::Concat < Shell::BuiltInCommand

== Singleton Methods

--- new(sh, *jobs)
#@todo

== Instance Methods

--- each(rs = nil){|job| ... }
#@todo


= class Shell::Echo < Shell::BuiltInCommand


== Singleton Methods

--- new(sh, *strings)
#@todo

== Instance Methods

--- each(rs = nil){|str| ... }
#@todo


= class Shell::Glob < Shell::BuiltInCommand

== Singleton Methods

--- new(sh, pattern)
#@todo

== Instance Methods

--- each(rs = nil){|file| ... }
#@todo

= class Shell::Tee < Shell::BuiltInCommand

== Singleton Methods

--- new(sh, filename)
#@todo

== Instance Methods

--- each(rs = nil){|line| ... }
#@todo

#@since 1.9.1

= class Shell::Void < Shell::BuiltInCommand

何もしないコマンドです。

== Singleton Methods

--- new(sh, *opts)

== Instance Methods

--- each(rs = nil){ ... } -> nil

何もしません。

#@end
