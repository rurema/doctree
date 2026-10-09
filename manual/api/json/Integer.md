---
library: json
include:
#%until 4.1
  - JSON::Ext::Generator::GeneratorMethods::Integer
#%else
  - JSON::GeneratorMethods
#%end
---
# reopen Integer

