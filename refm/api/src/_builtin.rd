category Builtin

組み込みライブラリは Ruby 本体に組み込まれているライブラリです。
このライブラリに含まれるクラスやモジュールは、
require を書かなくても使うことができます。

#@include(_builtin/ARGF)
#@include(_builtin/ArgumentError)
#@include(_builtin/Array)
#@include(_builtin/BasicObject)
#@until 2.4.0
#@include(_builtin/Bignum)
#@end
#@include(_builtin/Binding)
#@include(_builtin/Class)
#@since 2.3.0
#@include(_builtin/ClosedQueueError)
#@end
#@include(_builtin/Comparable)
#@include(_builtin/Complex)
#@since 2.3.0
#@include(thread/ConditionVariable)
#@end
#@include(_builtin/Data)
#@include(_builtin/Dir)
#@include(_builtin/ENV)
#@include(_builtin/EOFError)
#@include(_builtin/Encoding)
#@include(_builtin/Encoding__Converter)
#@include(_builtin/Enumerable)
#@include(_builtin/Enumerator)
#@since 2.0.0
#@include(_builtin/Enumerator__Lazy)
#@end
#@include(_builtin/Exception)
#@include(_builtin/FalseClass)
#@include(_builtin/Fiber)
#@include(_builtin/File)
#@include(_builtin/FileTest)
#@include(_builtin/File__Constants)
#@include(_builtin/File__Stat)
#@until 2.4.0
#@include(_builtin/Fixnum)
#@end
#@include(_builtin/Float)
#@include(_builtin/FloatDomainError)
#@since 2.5.0
#@include(_builtin/FrozenError)
#@end
#@include(_builtin/GC)
#@include(_builtin/GC__Profiler)
#@include(_builtin/Hash)
#@include(_builtin/IO)
#@include(_builtin/IOError)
#@include(_builtin/IO__WaitReadable)
#@include(_builtin/IO__WaitWritable)
#@include(_builtin/IndexError)
#@include(_builtin/Integer)
#@include(_builtin/Interrupt)
#@include(_builtin/Kernel)
#@include(_builtin/KeyError)
#@include(_builtin/LoadError)
#@include(_builtin/LocalJumpError)
#@include(_builtin/Marshal)
#@include(_builtin/MatchData)
#@include(_builtin/Math)
#@include(_builtin/Method)
#@include(_builtin/Module)
#@include(thread/Mutex)
#@include(_builtin/NameError)
#@include(_builtin/NilClass)
#@include(_builtin/NoMemoryError)
#@include(_builtin/NoMethodError)
#@include(_builtin/NotImplementedError)
#@include(_builtin/Numeric)
#@include(_builtin/Object)
#@include(_builtin/ObjectSpace)
#@since 2.0.0
#@include(_builtin/ObjectSpace__WeakMap)
#@end
#@include(_builtin/Proc)
#@include(_builtin/Process)
#@include(_builtin/Process__GID)
#@include(_builtin/Process__Status)
#@include(_builtin/Process__Sys)
#@include(_builtin/Process__UID)
#@since 2.3.0
#@include(thread/Queue)
#@end
#@include(_builtin/Random)
#@include(_builtin/Range)
#@include(_builtin/RangeError)
#@include(_builtin/Rational)
#@include(_builtin/Regexp)
#@include(_builtin/RegexpError)
#@include(_builtin/RubyVM)
#@include(_builtin/RubyVM__InstructionSequence)
#@since 2.6.0
#@include(_builtin/RubyVM__MJIT)
#@end
#@include(_builtin/RuntimeError)
#@include(_builtin/ScriptError)
#@include(_builtin/SecurityError)
#@include(_builtin/Signal)
#@include(_builtin/SignalException)
#@since 2.3.0
#@include(thread/SizedQueue)
#@end
#@include(_builtin/StandardError)
#@include(_builtin/StopIteration)
#@include(_builtin/String)
#@include(_builtin/Struct)
#@include(_builtin/Struct__Tms)
#@include(_builtin/Symbol)
#@include(_builtin/SyntaxError)
#@include(_builtin/SystemCallError)
#@include(_builtin/SystemExit)
#@include(_builtin/SystemStackError)
#@include(_builtin/Thread)
#@since 2.0.0
#@include(_builtin/Thread__Backtrace__Location)
#@end
#@include(_builtin/ThreadError)
#@include(_builtin/ThreadGroup)
#@include(_builtin/Time)
#@since 2.0.0
#@include(_builtin/TracePoint)
#@end
#@include(_builtin/TrueClass)
#@include(_builtin/TypeError)
#@include(_builtin/UnboundMethod)
#@since 2.2.0
#@include(_builtin/UncaughtThrowError)
#@end
#@include(_builtin/ZeroDivisionError)
#@include(_builtin/fatal)
#@include(_builtin/main)
