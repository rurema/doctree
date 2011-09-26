#@since 1.9.2
require syck/ypath

= module Syck::BaseNode
#@else
require yaml/ypath

= module YAML::BaseNode
#@end

== instance methods

--- [](*key)
#@todo

--- at(segment)
#@todo

--- children
#@todo

--- children_with_index
#@todo

--- emit
#@todo

--- match_path(ypath_str)
#@todo

--- match_segment(ypath, depth)
#@todo

--- search(ypath_str)
#@todo

--- select(ypath_str)
#@todo

--- select!(ypath_str)
#@todo
