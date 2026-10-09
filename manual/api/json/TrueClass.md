---
library: json
include:
#%until 4.1
  - JSON::Ext::Generator::GeneratorMethods::TrueClass
#%else
  - JSON::GeneratorMethods
#%end
---
# reopen TrueClass
