category Builtin

組み込みライブラリは Ruby 本体に組み込まれているライブラリです。
このライブラリに含まれるクラスやモジュールは、
require を書かなくても使うことができます。

#@include(_builtin/ARGF)
#@include(_builtin/ArgumentError)
#@include(_builtin/Array)
#@since 1.9.1
#@include(_builtin/BasicObject)
#@end
#@include(_builtin/Bignum)
#@include(_builtin/Binding)
#@include(_builtin/Class)
#@since 2.3.0
#@include(_builtin/ClosedQueueError)
#@end
#@include(_builtin/Comparable)
#@since 1.9.1
#@include(_builtin/Complex)
#@end
#@since 2.3.0
#@include(thread/ConditionVariable)
#@end
#@until 1.9.1
#@include(_builtin/Continuation)
#@end
#@include(_builtin/Data)
#@include(_builtin/Dir)
#@include(_builtin/ENV)
#@include(_builtin/EOFError)
#@since 1.9.1
#@include(_builtin/Encoding)
#@include(_builtin/Encoding__Converter)
#@end
#@include(_builtin/Enumerable)
#@since 1.9.1
#@include(_builtin/Enumerator)
#@since 2.0.0
#@include(_builtin/Enumerator__Lazy)
#@end
#@end
#@since 1.8.7
#@until 1.9.1
#@include(_builtin/Enumerable__Enumerator)
#@end
#@end
#@include(_builtin/Exception)
#@include(_builtin/FalseClass)
#@since 1.9.1
#@include(_builtin/Fiber)
#@end
#@include(_builtin/File)
#@include(_builtin/FileTest)
#@include(_builtin/File__Constants)
#@include(_builtin/File__Stat)
#@include(_builtin/Fixnum)
#@include(_builtin/Float)
#@include(_builtin/FloatDomainError)
#@include(_builtin/GC)
#@since 1.9.1
#@include(_builtin/GC__Profiler)
#@end
#@include(_builtin/Hash)
#@include(_builtin/IO)
#@include(_builtin/IOError)
#@since 1.9.2
#@include(_builtin/IO__WaitReadable)
#@include(_builtin/IO__WaitWritable)
#@end
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
#@since 1.9.1
#@include(thread/Mutex)
#@end
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
#@until 1.9.1
#@include(_builtin/Precision)
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
#@since 1.9.2
#@include(_builtin/Random)
#@end
#@include(_builtin/Range)
#@include(_builtin/RangeError)
#@since 1.9.1
#@include(_builtin/Rational)
#@end
#@include(_builtin/Regexp)
#@include(_builtin/RegexpError)
#@since 1.9.1
#@include(_builtin/RubyVM)
#@include(_builtin/RubyVM__InstructionSequence)
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
#@since 1.8.7
#@include(_builtin/StopIteration)
#@end
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
