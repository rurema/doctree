---
library: json
include:
  - JSON::Ext::Generator::GeneratorMethods::String
extend:
#%until 4.0
  - JSON::Ext::Generator::GeneratorMethods::String::Extend
#%end
---
# reopen String

