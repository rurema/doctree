---
library: json
include:
#%until 4.1
  - JSON::Ext::Generator::GeneratorMethods::Float
#%else
  - JSON::GeneratorMethods
#%end
---
# reopen Float

