#@until 3.1
軽量スレッド Fiber をコルーチン的に扱うためのライブラリです。

@see [[c:Fiber]]

= reopen Fiber

== Singleton Methods

#@include(_builtin/Fiber.current)

== Public Instance Methods

#@include(_builtin/Fiber.transfer)
#@include(_builtin/Fiber.alive_p)

#@end
