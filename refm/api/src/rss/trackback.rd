require rss/1.0
require rss/2.0

= module RSS::BaseTrackBackModel
== Instance Methods

--- trackback_about
--- trackback_about=

--- trackback_abouts

--- trackback_ping
--- trackback_ping=


= module RSS::TrackBackModel10
include BaseTrackBackModel

= class RSS::TrackBackModel10::TrackBackPing < RSS::Element
== Instance Methods

--- resource
--- resource=

--- value
--- value=

= class RSS::TrackBackModel10::TrackBackAbout < RSS::Element
== Instance Methods

--- resource
--- resource=

--- value
--- value=


= module RSS::TrackBackModel20
include BaseTrackBackModel

= class RSS::TrackBackModel20::TrackBackPing < RSS::Element
== Instance Methods
--- content
--- content=

--- value
--- value=

= class RSS::TrackBackModel20::TrackBackAbout < RSS::Element
== Instance Methods
--- content
--- content=

--- value
--- value=
