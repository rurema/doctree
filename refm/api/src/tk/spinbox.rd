require tk
require tk/entry

= class TkSpinbox < TkEntry

== Constants

--- TkCommandNames
#@todo
#@# = ['spinbox'.freeze].freeze

--- WidgetClassName
#@todo
#@# = 'Spinbox'.freeze

--- WidgetClassNames
#@todo
#@# [WidgetClassName] = self



== Instance Methods

--- __validation_class_list
#@todo

--- command
#@todo

--- identify(x, y)
#@todo

--- set(str)
#@todo

--- spindown
#@todo

--- spinup
#@todo


= class TkSpinbox::SpinCommand < TkValidateCommand

== Class Methods

--- _config_keys
#@todo


= class TkSpinbox::SpinCommand::ValidateArgs < TkUtil::CallbackSubst

== Constants

--- KEY_TBL
#@todo

--- PROC_TBL
#@todo

== Class Methods

--- ret_val(val)
#@todo


== Instance Methods

--- current
#@todo

--- direction
#@todo

--- widget
#@todo


