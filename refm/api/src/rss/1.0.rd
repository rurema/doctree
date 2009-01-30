= class RSS::RDF < RSS::Element
include RSS::TaxonomyTopicModel
include RSS::RootElementMixin
include RSS::XMLStyleSheetMixin

== Instance Methods
--- channel
--- channel=
#@todo

--- encoding
--- encoding=
#@todo

--- image
--- image=
#@todo

--- item
--- item=
#@todo

--- items
#@todo

--- rss_version
--- rss_version=
#@todo

--- standalone
--- standalone=
#@todo

--- textinput
--- textinput=
#@todo

--- version
--- version=
#@todo

= module RSS::ImageModelUtils
#@todo

= module RSS::DublinCoreModel
#@todo

= class RSS::RDF::Channel < RSS::Element
include RSS::TaxonomyTopicsModel
include RSS::SyndicationModel
include RSS::ImageFaviconModel
include RSS::ImageModelUtils
include RSS::DublinCoreModel

== Instance Methods

--- about
--- about=
#@todo

--- date
--- date=
#@todo

--- description
--- description=
#@todo

--- image
--- image=
#@todo

--- items
--- items=
#@todo

--- link
--- link=
#@todo

--- textinput
--- textinput=
#@todo

--- title
--- title=
#@todo

= class RSS::RDF::Channel::Image < RSS::Element
== Instance Methods
--- resource
--- resource=
#@todo

= class RSS::RDF::Channel::Textinput < RSS::Element
== Instance Methods
--- resource
--- resource=
#@todo

= class RSS::RDF::Channel::Items < RSS::Element
== Instance Methods
--- resources
#@todo

= class RSS::RDF::Channel::ImageFavicon < RSS::Element
include RSS::DublinCoreModel

== Instance Methods

--- about
--- about=
#@todo

--- date
--- date=
#@todo

--- image_size
--- size
--- image_size=
--- size=
#@todo

= class RSS::RDF::Image < RSS::Element
include RSS::DublinCoreModel

== Instance Methods

--- about
--- about=
#@todo

--- date
--- date=
#@todo

--- link
--- link=
#@todo

--- title
--- title=
#@todo

--- url
--- url=
#@todo
 
= class RSS::RDF::Textinput < RSS::Element
include RSS::DublinCoreModel

== Instance Methods

--- about
--- about=
#@todo

--- date
--- date=
#@todo

--- description
--- description=
#@todo

--- link
--- link=
#@todo

--- name
--- name=
#@todo

--- title
--- title=
#@todo

= class RSS::RDF::Item < RSS::Element
include RSS::TaxonomyTopicsModel
include RSS::TrackBackModel10
include RSS::ImageItemModel
include RSS::ImageModelUtils
include RSS::DublinCoreModel
include RSS::ContentModel

== Instance Methods

--- about
--- about=
#@todo

--- date
--- date=
#@todo

--- description
--- description=
#@todo

--- link
--- link=
#@todo

--- title
--- title=
#@todo
