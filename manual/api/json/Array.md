---
library: json
include:
#%until 4.1
  - JSON::Ext::Generator::GeneratorMethods::Array
#%else
  - JSON::GeneratorMethods
#%end
---
# reopen Array

