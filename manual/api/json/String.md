---
library: json
include:
#%until 4.1
  - JSON::Ext::Generator::GeneratorMethods::String
#%else
  - JSON::GeneratorMethods
#%end
extend:
#%until 4.0
  - JSON::Ext::Generator::GeneratorMethods::String::Extend
#%end
---
# reopen String

