#@since 1.8.2

require tk
require tkextlib/setup
require tkextlib/tktrans/setup

#@include(TkTrans)

= reopen TkWindow
== Instance Methods
--- tktrans_set_image(img)

--- tktrans_get_image

= reopen TkRoot
== Instance Methods
--- tktrans_set_image(img)

--- tktrans_get_image

= reopen TkToplevel
--- tktrans_set_image

--- tktrans_get_image

#@end
