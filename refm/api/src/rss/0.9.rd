= class RSS::Rss < RSS::Element
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
#@todo

--- version
--- version=
#@todo

= class RSS::Rss::Channel < RSS::Element
== Instance Methods

--- categories
#@todo

--- category
--- category=
#@todo

--- copyright
--- copyright=
#@todo

--- date
--- pubDate
--- date=
--- pubDate=
#@todo

--- description
--- description=
#@todo

--- docs
--- docs=
#@todo

--- image
--- image=
#@todo

--- items
#@todo

--- item
--- item=
#@todo

--- language
--- language=
#@todo

--- lastBuildDate
--- lastBuildDate=
#@todo

--- link
--- link=
#@todo

--- managingEditor
--- managingEditor=
#@todo

--- rating
--- rating=
#@todo

--- skipDays
--- skipDays=
#@todo

--- skipHours
--- skipHours=
#@todo

--- textInput
--- textInput=
#@todo

--- title
--- title=
#@todo

--- webMaster
--- webMaster=
#@todo

= class RSS::Rss::SkipDays < RSS::Element
== Instance Methods

--- day
--- day=
--- days
#@todo

= class RSS::Rss::SkipHours < RSS::Element
== Instance Methods

--- hour
--- hour=
--- hours
#@todo

= class RSS::Rss::Channel::Image < RSS::Element
== Instance Methods

--- description
--- description=
#@todo

--- height
--- height=
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

--- width
--- width=
#@todo

= class RSS::Rss::Channel::Cloud < RSS::Element
== Instance Methods

--- domain
--- domain=
#@todo

--- path
--- path=
#@todo

--- port
--- port=
#@todo

--- protocol
--- protocol=
#@todo

--- registerProcedure
--- registerProcedure=
#@todo

= class RSS::Rss::Channel::Item < RSS::Element
include RSS::TrackBackModel20

== Instance Methods

--- categories
#@todo

--- category
--- category=
#@todo

--- date
--- date=
#@todo

--- description
--- description=
#@todo

--- enclosure
--- enclosure=
#@todo

--- link
--- link=
#@todo

--- source
--- source=
#@todo

--- title
--- title=
#@todo

= class RSS::Rss::Channel::Item::Source < RSS::Element
== Instance Methods

--- content
--- content=
#@todo

--- url
--- url=
#@todo

= class RSS::Rss::Channel::Item::Enclosure < RSS::Element
== Instance Methods

--- length
--- length=
#@todo

--- type
--- type=
--- url
#@todo

--- url=
#@todo

= class RSS::Rss::Channel::Item::Category < RSS::Element
== Instance Methods

--- content
--- content=
#@todo

--- domain
--- domain=
#@todo

= class RSS::Rss::Channel::TextInput < RSS::Element
== Instance Methods

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

