require tcltklib
require tkutil
require tk/autoload
require tkextlib/version.rb
require tkextlib/setup.rb
require tk/variable


#@since 1.8.0
 * multi-tk 複数の Tcl インタープリタをサポートする
 Ruby/Tk [[ruby-dev:20949]]
#@end
 * tcltk Tcl/Tk ライブラリ tk とは異なり直接 Tcl/Tk を呼び出すインタフェース)
 * tk    Ruby/Tk [[url:http://ns103.net/~arai/ruby/rubytk.html.gz]] を参照のこと

=== 参考

 * [[unknown:RubyTkFAQ]]
 * "Rubyist Magazine - 0003-Ruby/Tk の動向"[[url:http://jp.rubyist.net/magazine/?0003-RubyTkMovement]]



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


