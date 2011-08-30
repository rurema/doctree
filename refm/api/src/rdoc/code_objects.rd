#@since 1.9.2
require rdoc/code_object
require rdoc/context
require rdoc/top_level
require rdoc/class_module
require rdoc/normal_class
require rdoc/normal_module
require rdoc/anon_class
require rdoc/single_class
require rdoc/any_method
require rdoc/alias
require rdoc/ghost_method
require rdoc/meta_method
require rdoc/attr
require rdoc/constant
require rdoc/require
require rdoc/include
#@else
require rdoc/tokenstream
#@end

Ruby のソースコード中にあるクラス、モジュール、メソッドなどの構成要素を
表現するためのサブライブラリです。

#@until 1.9.2
#@include(RDoc__CodeObject)
#@include(RDoc__Context)
#@include(RDoc__Context__Section)
#@include(RDoc__TopLevel)
#@include(RDoc__ClassModule)
#@include(RDoc__AnonClass)
#@include(RDoc__NormalClass)
#@include(RDoc__SingleClass)
#@include(RDoc__NormalModule)
#@include(RDoc__AnyMethod)
#@since 1.9.1
#@include(RDoc__GhostMethod)
#@include(RDoc__MetaMethod)
#@end
#@include(RDoc__Alias)
#@include(RDoc__Constant)
#@include(RDoc__Attr)
#@include(RDoc__Require)
#@include(RDoc__Include)
#@end
