#@since 1.8.2
require tk
require tk/entry

= class TkSpinbox < TkEntry

== Constants

--- TkCommandNames
#@# = ['spinbox'.freeze].freeze

--- WidgetClassName
#@# = 'Spinbox'.freeze

--- WidgetClassNames
#@# [WidgetClassName] = self



== Instance Methods

--- __validation_class_list

--- command

--- identify(x, y)

--- set(str)

--- spindown

--- spinup


= class TkSpinbox::SpinCommand < TkValidateCommand

== Class Methods

--- _config_keys


= class TkSpinbox::SpinCommand::ValidateArgs < TkUtil::CallbackSubst

== Constants

--- KEY_TBL

--- PROC_TBL

== Class Methods

--- ret_val(val)


== Instance Methods

--- current

--- direction

--- widget


#@end
