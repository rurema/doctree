---
library: json
include:
#%until 4.1
  - JSON::Ext::Generator::GeneratorMethods::Hash
#%else
  - JSON::GeneratorMethods
#%end
---
# reopen Hash

