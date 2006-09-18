= class ThreadsWait < Object

provides synchronization for multiple threads.

== Class Methods

--- ThreadsWait.all_waits(thread1,...)

waits until all of specified threads are terminated.
if a block is supplied for the method, evaluates it for
each thread termination.

        require 'thwait'

        threads = []
        5.times {|i|
          threads << Thread.new { sleep 1; p Thread.current }
        }
        ThreadsWait.all_waits(*threads) {|th| p th }
        => #<Thread:0x401a0ca8 run>
           #<Thread:0x401a0d70 run>
           #<Thread:0x401a1130 run>
           #<Thread:0x401a13ec run>
           #<Thread:0x401a17d4 run>
           #<Thread:0x401a0ca8 dead>
           #<Thread:0x401a0d70 dead>
           #<Thread:0x401a1130 dead>
           #<Thread:0x401a13ec dead>
           #<Thread:0x401a17d4 dead>

--- ThreadsWait.new(thread1,...)

creates synchronization object, specifying thread(s) to wait.

== Instance Methods

--- ThreadsWait#threads

list threads to be synchronized

--- ThreadsWait#empty?

is there any thread to be synchronized.

--- ThreadsWait#finished?

is there already terminated thread.

--- ThreadsWait#join(thread1,...)

wait for specified thread(s).

--- ThreadsWait#join_nowait(threa1,...)

specifies thread(s) to wait.  non-blocking.

--- ThreadsWait#next_wait

waits until any of specified threads is terminated.

--- ThreadsWait#all_waits

waits until all of specified threads are terminated.
if a block is supplied for the method, evaluates it for
each thread termination.

= reopen Kernel

== Constants

--- ThWait
[[c:ThreadsWait]] §Œ ÃÃæ
