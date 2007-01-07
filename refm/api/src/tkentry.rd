#@if(version <= "1.8.1")
require tk
#@include(tk/entry/TkEntry)
#@include(tk/entry/TkEntry__ValidateCmd)
#@include(tk/entry/TkEntry__ValidateCmd__Action)
#@include(tk/entry/TkEntry__ValidateCmd__ValidateArgs)
#@else
require tk/entry

#@end
