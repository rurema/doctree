---
library: json
include:
#%until 4.1
  - JSON::Ext::Generator::GeneratorMethods::Object
#%else
  - JSON::GeneratorMethods
#%end
---
# reopen Object

