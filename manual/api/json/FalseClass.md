---
library: json
include:
#%until 4.1
  - JSON::Ext::Generator::GeneratorMethods::FalseClass
#%else
  - JSON::GeneratorMethods
#%end
---
# reopen FalseClass

