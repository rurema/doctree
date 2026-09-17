---
library: json
include:
#%until 4.1
  - JSON::Ext::Generator::GeneratorMethods::FalseClass
#%end
#%since 4.1
  - JSON::GeneratorMethods
#%end
---
# reopen FalseClass

