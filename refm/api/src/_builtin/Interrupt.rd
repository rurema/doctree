#@if (version >= "1.7.0")
= class Interrupt < SignalException
#@else
= class Interrupt < Exception
#@end

[[m:Kernel#trap]] されていない SIGINT を受け取ると発生します。
SIGINT 以外のシグナル受信による例外は [[c:SignalException]] を参
照してください。
