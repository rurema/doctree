---
library: json
include:
#%until 4.1
  - JSON::Ext::Generator::GeneratorMethods::NilClass
#%else
  - JSON::GeneratorMethods
#%end
---
# reopen NilClass

