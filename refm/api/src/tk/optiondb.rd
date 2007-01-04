#@since 1.8.2
require tk

= module TkOptionDB
extend Tk
include Tk

== Constants

--- CmdClassID

--- RAND_BASE_CHAR

--- RAND_BASE_CNT

--- RAND_BASE_HEAD

--- TkCommandNames

== Module Functions

--- add(pat, value, pri = Tk::None)

--- clear

--- eval_under_random_base(parent = nil, &block)

--- get(win, name, klass)

--- new_proc_class(klass, func, safe = 4, add = false, parent = nil, &block)

--- new_proc_class_random(klass, func, safe = 4, add = false, &block)

--- read_entries(file, f_enc = nil)

--- readfile(file, pri = Tk::None)
--- read_file(file, pri = Tk::None)

--- read_with_encoding(file, f_enc = nil, pri = Tk::None)


= module TkOptionDB::Priority

== Constants

--- Interactive

--- StartupFile

--- UserDefault

--- WidgetDefault



#@end
