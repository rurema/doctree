---
library: json
include:
#%until 4.1
  - JSON::Ext::Generator::GeneratorMethods::TrueClass
#%end
#%since 4.1
  - JSON::GeneratorMethods
#%end
---
# reopen TrueClass
