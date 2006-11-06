#@since 1.8.0
= module Signal

UNIX のシグナル関連の操作を行うモジュールです。

== Module Functions

--- list

シグナル名とシグナル番号を対応づけた [[c:Hash]] オブジェクトを返し
ます。

例:

  p Signal.list   # => {"WINCH"=>28, "PROF"=>27, ...}
#@end

#@since 1.8.0
--- trap(signal, command)
--- trap(signal) { ... }

signal で指定された割り込みにたいするハンドラとして
command を登録します。signal はシグナル名の
文字列か [[c:Symbol]]、またはシグナル番号で指定します。
さらに特別な値として 0 または "EXIT" が指定できます。
これは「プログラムの終了時」を表します。

command は文字列またはブロックで指定します。
nil、空文字列""、"SIG_IGN" または
"IGNORE" を指定した時は、可能ならばそのシグナルを
無視します。
"SIG_DFL" または "DEFAULT" を指定した時は、
シグナルハンドラをデフォルトに戻します。
"EXIT"を指定した時は、シグナルを受け取ると[[unknown:終了処理]]を
行ったあとステータス 0 で終了します。

いくつかのシグナルに対して、Ruby インタプリタは例外 [[c:Interrupt]] や
[[c:SignalException]] を発生させます。このようなシグナルは例外処理によっ
て捕捉することもできます。

例:

  begin
    Process.kill :QUIT, $$   # 自身にSIGQUITを送信
  rescue SignalException
    puts "rescue #$!"
  end
  # => rescue SIGQUIT

trap により捕捉されたシグナルは例外を発生させません。

trap は前回の trap で設定したハンドラを返します。
ブロックを登録していたらそれを [[c:Proc]] オブジェクト
として返します。文字列や "EXIT" を設定していた場合は
それを返します。"IGNORE" や "DEFAULT" に対しては nil
を返します。また、何も登録されていないときも nil
を返します。

また、ruby の仕組みの外でシグナルハンドラが登録された場合
(例えば拡張ライブラリが独自に sigaction を呼んだ場合など)
も nil を返します。

例:

  p Signal.trap(:INT, "p true")     # => nil
  p Signal.trap(:INT) { }           # => "p true"
  p Signal.trap(:INT, "SIG_IGN")    # => #<Proc:0x401b1328>
  p Signal.trap(:INT, "DEFAULT")    # => nil
  p Signal.trap(:INT, "EXIT")       # => nil
  p Signal.trap(:INT, nil)          # => "EXIT"

システムに定義されていないシグナルを trap に指定した場合は
例外 [[c:ArgumentError]] が発生します。例えばネイティブな
Windows システム (mswin32, mingw など) で動く ruby では
INT ILL FPE SEGV TERM BREAK ABRT EXIT しか定義されていません。

#@end
