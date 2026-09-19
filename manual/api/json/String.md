---
library: json
include:
#%until 4.1
  - JSON::Ext::Generator::GeneratorMethods::String
#%end
#%since 4.1
  - JSON::GeneratorMethods
#%end
extend:
#%until 4.0
  - JSON::Ext::Generator::GeneratorMethods::String::Extend
#%end
---
# reopen String

