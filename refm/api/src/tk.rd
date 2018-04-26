category GUI

require tcltklib
require tkutil
require tk/autoload
#@#require tkextlib/version
#@#require tkextlib/setup
require tk/variable

sublibrary tcltklib
sublibrary tkutil
sublibrary remote-tk
sublibrary multi-tk
sublibrary tkafter
sublibrary tkbgerror
sublibrary tkcanvas
sublibrary tkclass
sublibrary tkconsole
sublibrary tkdialog
sublibrary tkentry
sublibrary tkfont
sublibrary tkmacpkg
sublibrary tkmenubar
sublibrary tkmngfocus
sublibrary tkpalette
sublibrary tkscrollbox
sublibrary tktext
sublibrary tkvirtevent
sublibrary tkwinpkg
sublibrary tkextlib/ICONS
sublibrary tkextlib/blt
sublibrary tkextlib/bwidget
sublibrary tkextlib/itcl
sublibrary tkextlib/itk
sublibrary tkextlib/iwidgets
sublibrary tkextlib/pkg_checker
sublibrary tkextlib/tcllib
sublibrary tkextlib/tclx
sublibrary tkextlib/tile
sublibrary tkextlib/tkDND
sublibrary tkextlib/tkHTML
sublibrary tkextlib/tkimg
sublibrary tkextlib/tktable
sublibrary tkextlib/tktrans
sublibrary tkextlib/treectrl
sublibrary tkextlib/vu
sublibrary tkextlib/winico

tkを用いてGUIアプリケーションを作成するためのライブラリです。

#@since 1.8.0
 * multi-tk 複数の Tcl インタープリタをサポートする
 Ruby/Tk [[ruby-dev:20949]]
#@end
 * tcltk Tcl/Tk ライブラリ tk とは異なり直接 Tcl/Tk を呼び出すインタフェース)
 * tk    Ruby/Tk [[url:http://ns103.net/~arai/ruby/rubytk.html.gz]] を参照のこと

=== 参考

 * [[unknown:RubyTkFAQ]]
 * "Rubyist Magazine - 0003-Ruby/Tk の動向"[[url:https://magazine.rubyist.net/articles/0003/0003-RubyTkMovement.html]]

=== 注意

このライブラリは 2.4.0 で gem ライブラリとして切り離されました。2.4.0
以降ではそちらを利用してください。

 * [[url:https://rubygems.org/gems/tk]]

#@include(tk/TclTkIp)
#@include(tk/TkComm)
#@include(tk/TkCore)
#@include(tk/TkCore__Tk_OBJECT_TABLE)
#@include(tk/TkCore__INTERP)
#@include(tk/Tk)
#@include(tk/TkBindCore)
#@include(tk/TkConfigMethod)
#@include(tk/TclTkLib)
#@include(tk/TkTreatFont)
#@include(tk/TkObject)
#@include(tk/TkWindow)


