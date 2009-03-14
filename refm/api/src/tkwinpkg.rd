#@if(version <= "1.8.1")
require tk

#@include(tk/winpkg/TkWinDDE)
#@include(tk/winpkg/TkWinRegistry)

#@else
require tk/winpkg

#@end
