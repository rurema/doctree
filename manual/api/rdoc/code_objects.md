---
type: library
require:
  - rdoc/code_object
#%since 3.4
  - rdoc/code_object/context
  - rdoc/code_object/top_level
  - rdoc/code_object/class_module
  - rdoc/code_object/normal_class
  - rdoc/code_object/normal_module
#%until 4.1
  - rdoc/code_object/anon_class
#%end
  - rdoc/code_object/single_class
  - rdoc/code_object/any_method
  - rdoc/code_object/alias
#%until 4.1
  - rdoc/code_object/ghost_method
  - rdoc/code_object/meta_method
#%end
  - rdoc/code_object/attr
  - rdoc/code_object/constant
  - rdoc/code_object/require
  - rdoc/code_object/include
#%end
#%until 3.4
  - rdoc/context
  - rdoc/top_level
  - rdoc/class_module
  - rdoc/normal_class
  - rdoc/normal_module
  - rdoc/anon_class
  - rdoc/single_class
  - rdoc/any_method
  - rdoc/alias
  - rdoc/ghost_method
  - rdoc/meta_method
  - rdoc/attr
  - rdoc/constant
  - rdoc/require
  - rdoc/include
#%end
---
Ruby のソースコード中にあるクラス、モジュール、メソッドなどの構成要素を表現するためのサブライブラリです。

