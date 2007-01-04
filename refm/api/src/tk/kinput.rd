#@since 1.8.2

require tk

= module TkKinput
extend Tk
include Tk

== Class Methods

--- start(win, style = TkUtil::None)

--- send_spot(win)

--- input_start(win, keys = nil)

--- attribute_config(win, slot, value = TkUtil::None)

--- attribute_info(win, slot = nil)

--- input_end(win)

== Instance Methods

--- kinput_start(style = TkUtil::None)

--- kinput_send_spot

--- kanji_input_start(keys = nil)

--- kinput_attribute_config(slot, value = TkUtil::None)

--- kinput_attribute_info(slot = nil)

--- kanji_input_end

== Constants

--- TkCommandNames

#@end
