---
library: _builtin
---
# module Signal

UNIX のシグナル関連の操作を行うモジュールです。

## Module Functions

### module_function def list    -> Hash

シグナル名とシグナル番号を対応づけた [c:Hash] オブジェクトを返し
ます。

```ruby title="例"
p Signal.list   # => {"WINCH"=>28, "PROF"=>27, ...}
```

- **SEE** [m:Signal?.signame]

### module_function def trap(signal, command)    -> String | Proc | nil
### module_function def trap(signal) { ... }     -> String | Proc | nil

指定された割り込み signal に対するハンドラとして
command を登録します。
指定したシグナルが捕捉された時には例外が発生せず、代わりに command が実行されます。
ブロックを指定した場合にはブロックをハンドラとして登録します。

trap は前回の trap で設定したハンドラを返します。
文字列を登録していた場合はそれを、
ブロックを登録していたらそれを [c:Proc] オブジェクトに変換して返します。
また何も登録されていないときも nil を返します。
ruby の仕組みの外でシグナルハンドラが登録された場合
(例えば拡張ライブラリが独自に sigaction を呼んだ場合など)
も nil を返します。

- **param** `signal` -- シグナル名を表す文字列か [c:Symbol]、またはシグナル番号を指定します。
              さらに特別な値として 0 または "EXIT" が指定できます。
              これは「プログラムの終了時」を表します。

- **param** `command` -- シグナルハンドラとして Ruby プログラムを表す文字列か Proc オブジェクト、また次に挙げる文字列を
               指定します。nil、空文字列""、"SIG_IGN" または"IGNORE" を指定した時は、
               可能ならばそのシグナルを無視します。
               "SIG_DFL" または "DEFAULT" を指定した時は、シグナルハンドラをデフォルトに戻します。
               "EXIT"を指定した時は、シグナルを受け取ると終了処理を
               行ったあとステータス 0 で終了します。
               文字列の代わりに [c:Symbol] で指定することも出来ます。

- **raise** `ArgumentError` -- 引数 signalに SEGV BUS ILL FPE VTALRM を指定した場
                     合に発生します。また、システムに定義されていないシ
                     グナルを引数 signal に指定した場合に発生します。
                     例えばネイティブな Windows システム (mswin32,
                     mingw など) で動く ruby では INT ILL FPE SEGV
                     TERM BREAK ABRT EXIT しか定義されていません。

いくつかのシグナルに対して、Ruby インタプリタは例外 [c:Interrupt] や
[c:SignalException] を発生させます。このようなシグナルは例外処理によっ
て捕捉することもできます。

```ruby title="例"
begin
  Process.kill :QUIT, $$   # 自身にSIGQUITを送信
rescue SignalException
  puts "rescue #$!"
end
# => rescue SIGQUIT
```

```ruby title="例"
p Signal.trap(:INT, "p true")     # => "DEFAULT"
p Signal.trap(:INT) { p false }   # => "p true"
p Signal.trap(:INT, proc{ p nil })  # => #<Proc:0x8e45ae0 -:2>
p Signal.trap(:INT, "SIG_IGN")    # => #<Proc:0x8e45914 -:3>
p Signal.trap(:INT, "DEFAULT")    # => "IGNORE"
p Signal.trap(:INT, "EXIT")       # => "DEFAULT"
p Signal.trap(:INT, nil)          # => "EXIT"
```

```ruby title="例"
Signal.trap(0, proc { puts "Terminating: #{$$}" })
Signal.trap("CLD")  { puts "Child died" }
fork && Process.wait

# => Terminating: 13939
# => Child died
# => Terminating: 13907
```

- **SEE** [d:spec/terminate]

### module_function def signame(signo) -> String | nil

引数で指定されたシグナル番号をシグナル名に変換して返します。
対応するシグナル番号が存在しない場合は nil を返します。

```ruby
Signal.trap("INT") { |signo| puts Signal.signame(signo) }
p Process.kill("INT", 0)
# => INT
```

- **SEE** [m:Signal?.list]
