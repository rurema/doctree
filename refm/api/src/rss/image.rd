#@#require rss/1.0
#@#require rss/dublincore

= module RSS::ImageItemModel

== Instance Methods

--- image_item
--- image_item=

= class RSS::ImageItemModel::ImageItem < RSS::Element
include DublinCoreModel

== Instance Methods

--- about
--- about=

--- date
--- date=

--- image_height
--- image_height=
--- height
--- height=

--- image_width
--- image_width=
--- width
--- width=

--- resource
--- resource=

= module RSS::ImageFaviconModel
== Instance Methods
--- image_favicon
--- image_favicon=

= class RSS::ImageFaviconModel::ImageFavicon < RSS::Element
include DublinCoreModel
== Instance Methods

--- about
--- about=

--- date
--- date=

--- image_size
--- size
--- image_size=
--- size=
