#@until 2.2.0
--- int rb_exec(const struct rb_exec_arg *e)

この関数は deprecated です。

--- int rb_exec_arg_addopt(struct rb_exec_arg *e, VALUE key, VALUE val)

この関数は deprecated です。

--- void rb_exec_arg_fixup(struct rb_exec_arg *e)

この関数は deprecated です。

--- VALUE rb_exec_arg_init(int argc, VALUE *argv, int accept_shell, struct rb_exec_arg *e)

この関数は deprecated です。

--- int rb_exec_err(const struct rb_exec_arg *e, char *errmsg, size_t errmsg_buflen)

この関数は deprecated です。

--- rb_pid_t rb_fork(int *status, int (*chfunc)(void*), void *charg, VALUE fds)

この関数は deprecated です。

--- rb_pid_t rb_fork_err(int *status, int (*chfunc)(void*, char *, size_t), void *charg, VALUE fds, char *errmsg, size_t errmsg_buflen)

この関数は deprecated です。

--- int rb_proc_exec_n(int argc, VALUE *argv, const char *prog)

この関数は deprecated です。

--- int rb_run_exec_options(const struct rb_exec_arg *e, struct rb_exec_arg *s)

この関数は deprecated です。

--- int rb_run_exec_options_err(const struct rb_exec_arg *e, struct rb_exec_arg *s, char *errmsg, size_t errmsg_buflen)

この関数は deprecated です。
#@end
