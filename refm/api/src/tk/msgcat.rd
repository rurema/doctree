#@since 1.8.2

require tk

= class TkMsgCatalog < TkObject
extend Tk
include TkCore

== Class Methods

#@since 1.8.3
--- package_name
#@end

--- callback(namespace, locale, src_str, *args)

--- new(namespace = nil)

--- translate(*args)
--- mc(*args)
--- [](*args)

--- maxlen(*src_strings)

--- locale

--- locale=(locale)

--- preferences

--- load_tk(dir)

--- load_rb(dir)
--- load(dir)

--- set_translation(locale, src_str, trans_str = Tk::None, enc = "utf-8")

--- set_translation_list(locale, trans_list, enc = "utf-8")

--- def_unknown_proc(cmd = Proc.new)

== Instance Methods

--- msgcat_ext
--- msgcat_ext=(value)

--- method_missing(id, *args)

--- translate(*args)
--- mc(*args)
--- [](*args)

--- maxlen(*src_strings)

--- locale

--- locale=(locale)

--- preferences

--- load_tk(dir)

--- load_rb(dir)
--- load(dir)

--- set_translation(locale, src_str, trans_str = Tk::None, enc = "utf-8")

--- set_translation_list(locale, trans_list, enc = "utf-8")

--- def_unknown_proc(cmd = Proc.new)

== Constants

--- TkCommandNames

#@since 1.8.3
--- PACKAGE_NAME
#@end

--- MSGCAT_EXT

--- UNKNOWN_CBTBL

= reopen Kernel

== Constants

--- TkMsgCat

#@end
