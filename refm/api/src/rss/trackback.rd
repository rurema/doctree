#@#require rss/1.0
#@#require rss/2.0

= module RSS::BaseTrackBackModel
== Instance Methods

--- trackback_about
--- trackback_about=
#@todo

--- trackback_abouts
#@todo

--- trackback_ping
--- trackback_ping=
#@todo


= module RSS::TrackBackModel10
extend RSS::BaseTrackBackModel

= class RSS::TrackBackModel10::TrackBackPing < RSS::Element
== Instance Methods

--- resource
--- resource=
#@todo

--- value
--- value=
#@todo

= class RSS::TrackBackModel10::TrackBackAbout < RSS::Element
== Instance Methods

--- resource
--- resource=
#@todo

--- value
--- value=
#@todo


= module RSS::TrackBackModel20
extend RSS::BaseTrackBackModel

= class RSS::TrackBackModel20::TrackBackPing < RSS::Element
== Instance Methods
--- content
--- content=
#@todo

--- value
--- value=
#@todo

= class RSS::TrackBackModel20::TrackBackAbout < RSS::Element
== Instance Methods
--- content
--- content=
#@todo

--- value
--- value=
#@todo
