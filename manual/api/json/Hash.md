---
library: json
include:
#%until 4.1
  - JSON::Ext::Generator::GeneratorMethods::Hash
#%end
#%since 4.1
  - JSON::GeneratorMethods
#%end
---
# reopen Hash

