require tk

= class TkTimer < Object

extend TkCore
include TkCore

== Class Methods

--- new(*args) { .... }

--- start(*args) { .... }

--- callback(obj_id)

--- info(obj = nil)

== Instance Methods

--- do_callback

--- set_callback(sleep, args=nil)

--- set_next_callback(args)

--- after_id

--- after_script

--- current_proc

--- current_args

--- current_sleep
--- current_interval

--- return_value

--- loop_exec
--- loop_exec=

--- cb_call

--- get_procs

--- current_status

--- cancel_on_exception?

--- cancel_on_exception=(mode)

--- running?

--- loop_rest

--- loop_rest=(rest)

--- set_interval(interval)

--- set_procs(interval, loop_exec, *procs)

--- add_procs(*procs)

--- delete_procs(*procs)

--- delete_at(n)

--- set_start_proc(sleep=nil, init_proc=nil, *init_args) { .... }

--- start(*init_args) { .... }

--- reset(*reset_args)

--- restart(*restart_args) { .... }

--- cancel
--- stop

--- continue(wait=nil)

--- skip

--- info

--- wait(on_thread = true, check_root = false)

--- eventloop_wait(check_root = false)

--- thread_wait(check_root = false)

--- tkwait(on_thread = true)

--- eventloop_tkwait

--- thread_tkwait

== Constants

--- TkCommandName

--- Tk_CBID

--- Tk_CBTBL

--- DEFAULT_IGNORE_EXCEPTIONS

#@since 1.8.3

= class TkRTTimer < TkTimer

== Instance Methods

--- start(*args) { .... }

--- cancel
--- stop

--- continue(wait=nil)

--- set_interval(interval)

--- set_next_callback(args)

--- cb_call

== Constants

--- DEFAULT_OFFSET_LIST_SIZE

#@end

