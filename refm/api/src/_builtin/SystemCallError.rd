= class SystemCallError < StandardError

システムコールが失敗した時に発生する例外です。実際には
SystemCallError そのものではなく、サブクラスである [[c:Errno]]
モジュールの内部クラス(各errnoと同じ名前)です。

== Class Methods

--- new(error_message)
#@if (version >= "1.8.0")
--- new(error_message, errno)
--- new(errno)

errno を指定しない一番目の形式では、SystemCallError オ
ブジェクトを生成して返します。それ以外では、整数 errno に該
当する[[c:Errno::EXXX]] オブジェクトを生成して返します。

例:

  p SystemCallError.new("message")
  p SystemCallError.new("message", 2)
  p SystemCallError.new(2)
  p SystemCallError.new(256)
  
  # => #<SystemCallError: unknown error - message>
       #<Errno::ENOENT: No such file or directory - message>
       #<Errno::ENOENT: No such file or directory>
       #<SystemCallError: Unknown error 256>
#@else
SystemCallError オブジェクトを生成して返します。
#@end

#@if (version >= "1.7.0")
--- ===(other)

other が SystemCallError のサブクラスであれば真です。
([[m:Module#===]] と同じ)。

また、左辺が SystemCallError のサブクラスである場合、
other.errno の値(nil ならば そのクラスの
[[unknown:Errno|Errno::EXXX/Errno]] 定数の値)が
self::Errno と同じ場合に真を返します。

このメソッドにより、システムによって errno が同じ値の例外に対して
以下の例のように捕捉できるようになっていました。

  p Errno::EAGAIN::Errno
  p Errno::EWOULDBLOCK::Errno
  begin
    raise Errno::EAGAIN, "pseudo error"
  rescue Errno::EWOULDBLOCK
    p $!
  end
  
  # => 11
       11
       #<Errno::EAGAIN: pseudo error>

現在、 SystemCallError#=== のこの特徴は特に意味がありません。
(以下のように同一のオブジェクトになっているからです)

  p Errno::EAGAIN
  p Errno::EWOULDBLOCK
  p Errno::EWOULDBLOCK.object_id
  p SystemCallError.new(11).class.object_id
  
  => Errno::EAGAIN
     Errno::EAGAIN
     537747360
     537747360
#@end

== Instance Methods

--- errno

システムから返された errno の値を返します。
実際にシステムコールエラーが発生してなければ nil を返します。

例:

二つ目の例のように raiseによって故意にエラーが発生しているかのように
見せかける場合は注意してください。

  begin
    open("nonexistent file")
  rescue Errno::ENOENT
    p Errno::ENOENT::Errno      # => 2
    p $!.errno                  # => 2
  end
  
  begin
    raise Errno::ENOENT
  rescue Errno::ENOENT
    p Errno::ENOENT::Errno      # => 2
    p $!.errno                  # => nil
  end

#@if (version >= "1.8.0")
Errno::EXXX 例外オブジェクトは対応する
errno 値を初期化時に設定するようになりました。

  begin
    raise Errno::ENOENT
  rescue Errno::ENOENT
    p Errno::ENOENT::Errno      # => 2
    p $!.errno                  # => 2
  end

発生してない例外に対応する errno の値を知りたい場合は
[[unknown:Errno::EXXX::Errno|Errno::EXXX/Errno]] 定数を使用してください。
#@end
