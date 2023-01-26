#@since 3.0
= NEWS for Ruby 3.0.0

このドキュメントは前回リリース以降のバグ修正を除くユーザーに影響のある機能の変更のリストです。

それぞれのエントリーは参照情報があるため短いです。
十分な情報と共に書かれた全ての変更のリストはリンク先を参照してください。

== 言語仕様の変更

  * Keyword arguments are now separated from positional arguments.
    Code that resulted in deprecation warnings in Ruby 2.7 will now
    result in ArgumentError or different behavior. [[feature:14183]]
  * Procs accepting a single rest argument and keywords are no longer
    subject to autosplatting.  This now matches the behavior of Procs
    accepting a single rest argument and no keywords.
    [[feature:16166]]

#@samplecode
pr = proc{|*a, **kw| [a, kw]}

pr.call([1])
# 2.7 => [[1], {}]
# 3.0 => [[[1]], {}]

pr.call([1, {a: 1}])
# 2.7 => [[1], {:a=>1}] # and deprecation warning
# 3.0 => [[[1, {:a=>1}]], {}]
#@end

  * Arguments forwarding (`...`) now supports leading arguments.
    [[feature:16378]]

//emlist{
def method_missing(meth, ...)
  send(:"do_#{meth}", ...)
end
//}

    * Pattern matching (`case/in`) is no longer experimental. [[feature:17260]]
    * One-line pattern matching is redesigned.  [EXPERIMENTAL]
        * `=>` is added. It can be used like a rightward assignment.
          [[feature:17260]]
      * `in` is changed to return `true` or `false`. [[feature:17371]]

//emlist{
0 => a
p a #=> 0

{b: 0, c: 1} => {b:}
p b #=> 0
//}

//emlist{
# version 3.0
0 in 1 #=> false

# version 2.7
0 in 1 #=> raise NoMatchingPatternError
//}

  * Find-pattern is added.  [EXPERIMENTAL]
    [[feature:16828]]

//emlist{
case ["a", 1, "b", "c", 2, "d", "e", "f", 3]
in [*pre, String => x, String => y, *post]
  p pre  #=> ["a", 1]
  p x    #=> "b"
  p y    #=> "c"
  p post #=> [2, "d", "e", "f", 3]
end
//}

  * Endless method definition is added.  [EXPERIMENTAL]
    [[feature:16746]]

//emlist{
def square(x) = x * x
//}

  * Interpolated String literals are no longer frozen when
    `# frozen-string-literal: true` is used. [[feature:17104]]
  * Magic comment `shareable_constant_value` added to freeze constants.
    See {Magic Comments}[rdoc-ref:doc/syntax/comments.rdoc@Magic+Comments] for more details.
    [[feature:17273]]
  * A {static analysis}[rdoc-label:label-Static+analysis] foundation is
    introduced.
      * {RBS}[rdoc-label:label-RBS] is introduced. It is a type definition
        language for Ruby programs.
      * {TypeProf}[rdoc-label:label-TypeProf] is experimentally bundled. It is a
        type analysis tool for Ruby programs.
  * Deprecation warnings are no longer shown by default (since Ruby 2.7.2).
    Turn them on with `-W:deprecated` (or with `-w` to show other warnings too).
    [[feature:16345]]
  * `$SAFE` and `$KCODE` are now normal global variables with no special behavior.
    C-API methods related to `$SAFE` have been removed.
    [[feature:16131]] [[feature:17136]]
  * yield in singleton class definitions in methods is now a SyntaxError
    instead of a warning. yield in a class definition outside of a method
    is now a SyntaxError instead of a LocalJumpError.  [[feature:15575]]
  * When a class variable is overtaken by the same definition in an
    ancestor class/module, a RuntimeError is now raised (previously,
    it only issued a warning in verbose mode).  Additionally, accessing a
    class variable from the toplevel scope is now a RuntimeError.
    [[bug:14541]]
  * Assigning to a numbered parameter is now a SyntaxError instead of
    a warning.

== Command line options

=== `--help` option

When the environment variable `RUBY_PAGER` or `PAGER` is present and has
a non-empty value, and the standard input and output are tty, the `--help`
option shows the help message via the pager designated by the value.
[[feature:16754]]

=== `--backtrace-limit` option

The `--backtrace-limit` option limits the maximum length of a backtrace.
[[feature:8661]]

== Core classes updates

Outstanding ones only.

  * Array
    * The following methods now return Array instances instead of subclass instances when called on subclass instances: [[bug:6087]]
      * Array#drop
      * Array#drop_while
      * Array#flatten
      * Array#slice!
      * Array#slice / Array#[]
      * Array#take
      * Array#take_while
      * Array#uniq
      * Array#*
    * Can be sliced with Enumerator::ArithmeticSequence

#@samplecode
dirty_data = ['--', 'data1', '--', 'data2', '--', 'data3']
dirty_data[(1..).step(2)] # take each second element
# => ["data1", "data2", "data3"]
#@end

  * Binding
    * Binding#eval when called with one argument will use `"(eval)"` for `__FILE__` and `1` for `__LINE__` in the evaluated code. [[bug:4352]] [[bug:17419]]
  * ConditionVariable
    * ConditionVariable#wait may now invoke the `block`/`unblock` scheduler hooks in a non-blocking context. [[feature:16786]]
  * Dir
    * Dir.glob and Dir.[] now sort the results by default, and accept the `sort:` keyword option.  [[feature:8709]]
  * ENV
    * ENV.except has been added, which returns a hash excluding the given keys and their values.  [[feature:15822]]
    * Windows: Read ENV names and values as UTF-8 encoded Strings [[feature:12650]]
  * Encoding
    * Added new encoding IBM720.  [[feature:16233]]
    * Changed default for Encoding.default_external to UTF-8 on Windows [[feature:16604]]
  * Fiber
    * Fiber.new(blocking: true/false) allows you to create non-blocking execution contexts. [[feature:16786]]
    * Fiber#blocking? tells whether the fiber is non-blocking. [[feature:16786]]
    * Fiber#backtrace and Fiber#backtrace_locations provide per-fiber backtrace. [[feature:16815]]
    * The limitation of Fiber#transfer is relaxed. [[bug:17221]]
  * GC
    * GC.auto_compact= and GC.auto_compact have been added to control when compaction runs.  Setting `auto_compact=` to `true` will cause compaction to occur during major collections.  At the moment, compaction adds significant overhead to major collections, so please test first!  [[feature:17176]]
  * Hash
    * Hash#transform_keys and Hash#transform_keys! now accept a hash that maps keys to new keys.  [[feature:16274]]
    * Hash#except has been added, which returns a hash excluding the given keys and their values.  [[feature:15822]]
  * IO
    * IO#nonblock? now defaults to `true`. [[feature:16786]]
    * IO#wait_readable, IO#wait_writable, IO#read, IO#write and other related methods (e.g. IO#puts, IO#gets) may invoke the scheduler hook `#io_wait(io, events, timeout)` in a non-blocking execution context. [[feature:16786]]
  * Kernel
    * Kernel#clone when called with the `freeze: false` keyword will call `#initialize_clone` with the `freeze: false` keyword. [[bug:14266]]
    * Kernel#clone when called with the `freeze: true` keyword will call `#initialize_clone` with the `freeze: true` keyword, and will return a frozen copy even if the receiver is unfrozen. [[feature:16175]]
    * Kernel#eval when called with two arguments will use `"(eval)"` for `__FILE__` and `1` for `__LINE__` in the evaluated code. [[bug:4352]]
    * Kernel#lambda now warns if called without a literal block. [[feature:15973]]
    * Kernel.sleep invokes the scheduler hook `#kernel_sleep(...)` in a non-blocking execution context. [[feature:16786]]
  * Module
    * Module#include and Module#prepend now affect classes and modules that have already included or prepended the receiver, mirroring the behavior if the arguments were included in the receiver before the other modules and classes included or prepended the receiver. [[feature:9573]]
    * Module#public, Module#protected, Module#private, Module#public_class_method, Module#private_class_method, toplevel "private" and "public" methods now accept single array argument with a list of method names. [[feature:17314]]
    * Module#attr_accessor, Module#attr_reader, Module#attr_writer and Module#attr methods now return an array of defined method names as symbols. [[feature:17314]]
    * Module#alias_method now returns the defined alias as a symbol. [[feature:17314]]

#@samplecode
class C; end
module M1; end
module M2; end
C.include M1
M1.include M2
p C.ancestors #=> [C, M1, M2, Object, Kernel, BasicObject]
#@end

  * Mutex
    * `Mutex` is now acquired per-`Fiber` instead of per-`Thread`. This change should be compatible for essentially all usages and avoids blocking when using a scheduler. [[feature:16792]]
  * Proc
    * Proc#== and Proc#eql? are now defined and will return true for separate Proc instances if the procs were created from the same block. [[feature:14267]]
  * Queue / SizedQueue
    * Queue#pop, SizedQueue#push and related methods may now invoke the `block`/`unblock` scheduler hooks in a non-blocking context. [[feature:16786]]
  * Ractor
    * New class added to enable parallel execution. See rdoc-ref:ractor.md for more details.
  * Random
    * `Random::DEFAULT` now refers to the `Random` class instead of being a `Random` instance, so it can work with `Ractor`. [[feature:17322]]
    * `Random::DEFAULT` is deprecated since its value is now confusing and it is no longer global, use `Kernel.rand`/`Random.rand` directly, or create a `Random` instance with `Random.new` instead. [[feature:17351]]
  * String
    * The following methods now return or yield String instances instead of subclass instances when called on subclass instances: [[bug:10845]]
      * String#*
      * String#capitalize
      * String#center
      * String#chomp
      * String#chop
      * String#delete
      * String#delete_prefix
      * String#delete_suffix
      * String#downcase
      * String#dump
      * String#each_char
      * String#each_grapheme_cluster
      * String#each_line
      * String#gsub
      * String#ljust
      * String#lstrip
      * String#partition
      * String#reverse
      * String#rjust
      * String#rpartition
      * String#rstrip
      * String#scrub
      * String#slice!
      * String#slice / String#[]
      * String#split
      * String#squeeze
      * String#strip
      * String#sub
      * String#succ / String#next
      * String#swapcase
      * String#tr
      * String#tr_s
      * String#upcase
  * Symbol
    * Symbol#to_proc now returns a lambda Proc.  [[feature:16260]]
    * Symbol#name has been added, which returns the name of the symbol if it is named.  The returned string is frozen.  [[feature:16150]]
  * Fiber
    * Introduce Fiber.set_scheduler for intercepting blocking operations and Fiber.scheduler for accessing the current scheduler. See rdoc-ref:fiber.md for more details about what operations are supported and how to implement the scheduler hooks. [[feature:16786]]
    * Fiber.blocking? tells whether the current execution context is blocking. [[feature:16786]]
    * Thread#join invokes the scheduler hooks `block`/`unblock` in a non-blocking execution context. [[feature:16786]]
  * Thread
    * Thread.ignore_deadlock accessor has been added for disabling the default deadlock detection, allowing the use of signal handlers to break deadlock. [[bug:13768]]
  * Warning
    * Warning#warn now supports a category keyword argument. [[feature:17122]]

== Stdlib updates

Outstanding ones only.

  * BigDecimal
    * Update to BigDecimal 3.0.0
    * This version is Ractor compatible.
  * Bundler
    * Update to Bundler 2.2.3
  * CGI
    * Update to 0.2.0
    * This version is Ractor compatible.
  * CSV
    * Update to CSV 3.1.9
  * Date
    * Update to Date 3.1.1
    * This version is Ractor compatible.
  * Digest
    * Update to Digest 3.0.0
    * This version is Ractor compatible.
  * Etc
    * Update to Etc 1.2.0
    * This version is Ractor compatible.
  * Fiddle
    * Update to Fiddle 1.0.5
  * IRB
    * Update to IRB 1.2.6
  * JSON
    * Update to JSON 2.5.0
    * This version is Ractor compatible.
  * Set
    * Update to set 1.0.0
    * SortedSet has been removed for dependency and performance reasons.
    * Set#join is added as a shorthand for `.to_a.join`.
    * Set#<=> is added.
  * Socket
    * Add :connect_timeout to TCPSocket.new [[feature:17187]]
  * Net::HTTP
    * Net::HTTP#verify_hostname= and Net::HTTP#verify_hostname have been added to skip hostname verification.  [[feature:16555]]
    * Net::HTTP.get, Net::HTTP.get_response, and Net::HTTP.get_print can take the request headers as a Hash in the second argument when the first argument is a URI.  [[feature:16686]]
  * Net::SMTP
    * Add SNI support.
    * Net::SMTP.start arguments are keyword arguments.
    * TLS should not check the host name by default.
  * OpenStruct
    * Initialization is no longer lazy. [[bug:12136]]
    * Builtin methods can now be overridden safely. [[bug:15409]]
    * Implementation uses only methods ending with `!`.
    * Ractor compatible.
    * Improved support for YAML. [[bug:8382]]
    * Use officially discouraged. Read OpenStruct@Caveats section.
  * Pathname
    * Ractor compatible.
  * Psych
    * Update to Psych 3.3.0
    * This version is Ractor compatible.
  * Reline
    * Update to Reline 0.1.5
  * RubyGems
    * Update to RubyGems 3.2.3
  * StringIO
    * Update to StringIO 3.0.0
    * This version is Ractor compatible.
  * StringScanner
    * Update to StringScanner 3.0.0
    * This version is Ractor compatible.

== Compatibility issues

Excluding feature bug fixes.

  * Regexp literals and all Range objects are frozen. [[feature:8948]] [[feature:16377]] [[feature:15504]]

#@samplecode
/foo/.frozen? #=> true
(42...).frozen? # => true
#@end

  * EXPERIMENTAL: Hash#each consistently yields a 2-element array. [[bug:12706]]
    * Now `{ a: 1 }.each(&->(k, v) { })` raises an ArgumentError due to lambda's arity check.
  * When writing to STDOUT redirected to a closed pipe, no broken pipe error message will be shown now.  [[feature:14413]]
  * `TRUE`/`FALSE`/`NIL` constants are no longer defined.
  * Integer#zero? overrides Numeric#zero? for optimization.  [[misc:16961]]
  * Enumerable#grep and Enumerable#grep_v when passed a Regexp and no block no longer modify Regexp.last_match. [[bug:17030]]
  * Requiring 'open-uri' no longer redefines `Kernel#open`. Call `URI.open` directly or `use URI#open` instead. [[misc:15893]]
  * SortedSet has been removed for dependency and performance reasons.

== Stdlib compatibility issues

  * Default gems
    * The following libraries are promoted to default gems from stdlib.
      * English
      * abbrev
      * base64
      * drb
      * debug
      * erb
      * find
      * net-ftp
      * net-http
      * net-imap
      * net-protocol
      * open-uri
      * optparse
      * pp
      * prettyprint
      * resolv-replace
      * resolv
      * rinda
      * set
      * securerandom
      * shellwords
      * tempfile
      * tmpdir
      * time
      * tsort
      * un
      * weakref
    * The following extensions are promoted to default gems from stdlib.
      * digest
      * io-nonblock
      * io-wait
      * nkf
      * pathname
      * syslog
      * win32ole
  * Bundled gems
    * net-telnet and xmlrpc have been removed from the bundled gems. If you are interested in maintaining them, please comment on your plan to https://github.com/ruby/xmlrpc or https://github.com/ruby/net-telnet.
  * SDBM has been removed from the Ruby standard library. [[bug:8446]]
    * The issues of sdbm will be handled at https://github.com/ruby/sdbm
  * WEBrick has been removed from the Ruby standard library. [[feature:17303]]
    * The issues of WEBrick will be handled at https://github.com/ruby/webrick

== C API updates

  * C API functions related to `$SAFE` have been removed. [[feature:16131]]
  * C API header file `ruby/ruby.h` was split. [[url:https://github.com/ruby/ruby/pull/2991]] This should have no impact on extension libraries, but users might experience slow compilations.
  * Memory view interface [EXPERIMENTAL]
    * The memory view interface is a C-API set to exchange a raw memory area, such as a numeric array or a bitmap image, between extension libraries. The extension libraries can share also the metadata of the memory area that consists of the shape, the element format, and so on. Using these kinds of metadata, the extension libraries can share even a multidimensional array appropriately. This feature is designed by referring to Python's buffer protocol. [[feature:13767]] [[feature:14722]]
  * Ractor related C APIs are introduced (experimental) in "include/ruby/ractor.h".

== Implementation improvements

  * New method cache mechanism for Ractor. [[feature:16614]]
    * Inline method caches pointed from ISeq can be accessed by multiple Ractors in parallel and synchronization is needed even for method caches. However, such synchronization can be overhead so introducing new inline method cache mechanisms, (1) Disposable inline method cache (2) per-Class method cache and (3) new invalidation mechanism. (1) can avoid per-method call synchronization because it only uses atomic operations. See the ticket for more details.
  * The number of hashes allocated when using a keyword splat in a method call has been reduced to a maximum of 1, and passing a keyword splat to a method that accepts specific keywords does not allocate a hash.
  * `super` is optimized when the same type of method is called in the previous call if it's not refinements or an attr reader or writer.

=== JIT

  * Performance improvements of JIT-ed code
    * Microarchitectural optimizations
        * Native functions shared by multiple methods are deduplicated on JIT compaction.
        * Decrease code size of hot paths by some optimizations and partitioning cold paths.
    * Instance variables
        * Eliminate some redundant checks.
        * Skip checking a class and a object multiple times in a method when possible.
        * Optimize accesses in some core classes like Hash and their subclasses.
    * Method inlining support for some C methods
        * `Kernel`: `#class`, `#frozen?`
        * `Integer`: `#-@`, `#~`, `#abs`, `#bit_length`, `#even?`, `#integer?`, `#magnitude`, `#odd?`, `#ord`, `#to_i`, `#to_int`, `#zero?`
        * `Struct`: reader methods for 10th or later members
    * Constant references are inlined.
    * Always generate appropriate code for `==`, `nil?`, and `!` calls depending on a receiver class.
    * Reduce the number of PC accesses on branches and method returns.
    * Optimize C method calls a little.
  * Compilation process improvements
    * It does not keep temporary files in /tmp anymore.
    * Throttle GC and compaction of JIT-ed code.
    * Avoid GC-ing JIT-ed code when not necessary.
    * GC-ing JIT-ed code is executed in a background thread.
    * Reduce the number of locks between Ruby and JIT threads.

== Static analysis

=== RBS

  * RBS is a new language for type definition of Ruby programs. It allows writing types of classes and modules with advanced types including union types, overloading, generics, and _interface types_ for duck typing.
  * Ruby ships with type definitions for core/stdlib classes.
  * `rbs` gem is bundled to load and process RBS files.

=== TypeProf

  * TypeProf is a type analysis tool for Ruby code based on abstract interpretation.
    * It reads non-annotated Ruby code, tries inferring its type signature, and prints the analysis result in RBS format.
    * Though it supports only a subset of the Ruby language yet, we will continuously improve the coverage of language features, analysis performance, and usability.

#@samplecode
# test.rb
def foo(x)
  if x > 10
    x.to_s
  else
    nil
  end
end

foo(42)
#@end

//emlist{
$ typeprof test.rb
# Classes
class Object
  def foo : (Integer) -> String?
end
//}

== Miscellaneous changes

  * Methods using `ruby2_keywords` will no longer keep empty keyword splats, those are now removed just as they are for methods not using `ruby2_keywords`.
  * When an exception is caught in the default handler, the error message and backtrace are printed in order from the innermost. [[feature:8661]]
  * Accessing an uninitialized instance variable no longer emits a warning in verbose mode. [[feature:17055]]
#@end
