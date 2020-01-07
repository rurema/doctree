
require tk

= class TkMsgCatalog < TkObject
alias TkMsgCat
extend Tk
include TkCore

== Class Methods

--- package_name
#@todo

--- callback(namespace, locale, src_str, *args)
#@todo

--- new(namespace = nil)
#@todo

--- translate(*args)
--- mc(*args)
--- [](*args)
#@todo

--- maxlen(*src_strings)
#@todo

--- locale
#@todo

--- locale=(locale)
#@todo

--- preferences
#@todo

--- load_tk(dir)
#@todo

--- load_rb(dir)
--- load(dir)
#@todo

--- set_translation(locale, src_str, trans_str = Tk::None, enc = "utf-8")
#@todo

--- set_translation_list(locale, trans_list, enc = "utf-8")
#@todo

--- def_unknown_proc(cmd = Proc.new)
#@todo

== Instance Methods

--- msgcat_ext
--- msgcat_ext=(value)
#@todo

--- method_missing(id, *args)
#@todo

--- translate(*args)
--- mc(*args)
--- [](*args)
#@todo

--- maxlen(*src_strings)
#@todo

--- locale
#@todo

--- locale=(locale)
#@todo

--- preferences
#@todo

--- load_tk(dir)
#@todo

--- load_rb(dir)
--- load(dir)
#@todo

--- set_translation(locale, src_str, trans_str = Tk::None, enc = "utf-8")
#@todo

--- set_translation_list(locale, trans_list, enc = "utf-8")
#@todo

--- def_unknown_proc(cmd = Proc.new)
#@todo

== Constants

--- TkCommandNames
#@todo

--- PACKAGE_NAME
#@todo

--- MSGCAT_EXT
#@todo

--- UNKNOWN_CBTBL
#@todo

