#@since 1.8.0
= module Process::GID

グループ ID を操作するメソッドを集めたモジュール
[[c:Process::UID]] と同じメソッドが定義されています。
#@end

== Module Functions

#@since 1.8.0
--- change_privilege(id)
#@# => fixnum

Change the current process's real and effective group ID to that
specified by integer. Returns the new group ID. Not available
on all platforms.

   [Process.gid, Process.egid]          #=> [0, 0]
   Process::GID.change_privilege(33)    #=> 33
   [Process.gid, Process.egid]          #=> [33, 33]
#@end

#@since 1.8.0
--- eid
#@# => fixnum

Returns the effective group ID for this process. Not available
on all platforms.

   Process.egid   #=> 500
#@end

#@since 1.8.0
--- grant_privilege(id)
--- eid = id
#@# => fixnum

Set the effective group ID, and if possible, the saved group
ID of the process to the given integer. Returns the new effective
group ID. Not available on all platforms.

   [Process.gid, Process.egid]          #=> [0, 0]
   Process::GID.grant_privilege(31)     #=> 33
   [Process.gid, Process.egid]          #=> [0, 33]

#@end

#@since 1.8.0
--- re_exchange
#@# => fixnum

Exchange real and effective group IDs and return the new effective
group ID. Not available on all platforms.

   [Process.gid, Process.egid]   #=> [0, 33]
   Process::GID.re_exchange      #=> 0
   [Process.gid, Process.egid]   #=> [33, 0]

#@end

#@since 1.8.0
--- re_exchangeable?
#@# => true or false

Returns true if the real and effective group IDs of a process
may be exchanged on the current platform.

#@end

#@since 1.8.0
--- rid
#@# => fixnum

Returns the (real) group ID for this process.

   Process.gid   #=> 500

#@end

#@since 1.8.0
--- sid_available?
#@# => true or false

Returns true if the current platform has saved group ID functionality.

#@end

#@since 1.8.0
#@# bc-rdoc: detected missing name: switch
--- switch
#@# => fixnum
--- switch {|| block}
#@# => object

Switch the effective and real group IDs of the current process.
If a block is given, the group IDs will be switched back after
the block is executed. Returns the new effective group ID if
called without a block, and the return value of the block if
one is given.

#@end
