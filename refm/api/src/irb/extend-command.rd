= module IRB::ExtendCommandBundle

== Singleton Methods

--- def_extend_command(cmd_name, cmd_class, load_file = nil, *aliases)
#@todo

--- extend_object(obj)
#@todo

--- install_extend_commands
#@# -> discard
#@todo 内部用

--- irb_original_method_name -> String
#@todo 内部用

== Instance Methods

--- install_alias_method(to, from, override = NO_OVERRIDE)
#@todo 内部用？

--- irb
#@todo

--- irb_change_workspace
#@todo

--- irb_context
#@todo

--- irb_current_working_workspace
#@todo

--- irb_exit(ret = 0)
#@todo

--- irb_fg
#@todo

--- irb_help
#@todo

--- irb_jobs
#@todo

--- irb_kill
#@todo

--- irb_load
#@todo

--- irb_pop_workspace
#@todo

--- irb_push_workspace
#@todo

--- irb_require
#@todo

--- irb_source
#@todo

--- irb_workspaces
#@todo

#@# == Constants
#@# 内部用の定数
#@# --- EXCB
#@# --- NO_OVERRIDE
#@# --- OVERRIDE_ALL
#@# --- OVERRIDE_PRIVATE_ONLY
