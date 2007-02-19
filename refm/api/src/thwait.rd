= class ThreadsWait < Object
#@# alias ThWait

provides synchronization for multiple threads.

== Class Methods

--- all_waits(thread1, ...)
#@todo

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

--- new(thread1, ...)
#@todo

creates synchronization object, specifying thread(s) to wait.

== Instance Methods

--- threads
#@todo

list threads to be synchronized

--- empty?
#@todo

is there any thread to be synchronized.

--- finished?
#@todo

is there already terminated thread.

--- join(thread1, ...)
#@todo

wait for specified thread(s).

--- join_nowait(threa1, ...)
#@todo

specifies thread(s) to wait.  non-blocking.

--- next_wait
#@todo

waits until any of specified threads is terminated.

--- all_waits
#@todo

waits until all of specified threads are terminated.
if a block is supplied for the method, evaluates it for
each thread termination.
