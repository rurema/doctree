= class RSS::Rss < RSS::Element
== Instance Methods

--- channel
--- channel=

--- encoding
--- encoding=

--- image

--- items

--- rss_version
--- rss_version=

--- standalone
--- standalone=

--- textinput

--- version
--- version=

= class RSS::Rss::Channel < RSS::Element
== Instance Methods

--- categories

--- category
--- category=

--- copyright
--- copyright=

--- date
--- pubDate
--- date=
--- pubDate=

--- description
--- description=

--- docs
--- docs=

--- image
--- image=

--- items

--- item
--- item=

--- language
--- language=

--- lastBuildDate
--- lastBuildDate=

--- link
--- link=

--- managingEditor
--- managingEditor=

--- rating
--- rating=

--- skipDays
--- skipDays=

--- skipHours
--- skipHours=

--- textInput
--- textInput=

--- title
--- title=

--- webMaster
--- webMaster=

= class RSS::Rss::SkipDays < RSS::Element
== Instance Methods

--- day
--- day=
--- days

= class RSS::Rss::SkipHours < RSS::Element
== Instance Methods

--- hour
--- hour=
--- hours

= class RSS::Rss::Channel::Image < RSS::Element
== Instance Methods

--- description
--- description=

--- height
--- height=

--- link
--- link=

--- title
--- title=

--- url
--- url=

--- width
--- width=

= class RSS::Rss::Channel::Cloud < RSS::Element
== Instance Methods

--- domain
--- domain=

--- path
--- path=

--- port
--- port=

--- protocol
--- protocol=

--- registerProcedure
--- registerProcedure=

= class RSS::Rss::Channel::Item < RSS::Element
== Instance Methods

--- categories

--- category
--- category=

--- date
--- date=

--- description
--- description=

--- enclosure
--- enclosure=

--- link
--- link=

--- source
--- source=

--- title
--- title=

= class RSS::Rss::Channel::Item::Source < RSS::Element
== Instance Methods

--- content
--- content=

--- url
--- url=

= class RSS::Rss::Channel::Item::Enclosure < RSS::Element
== Instance Methods

--- length
--- length=

--- type
--- type=
--- url

--- url=

= class RSS::Rss::Channel::Item::Category < RSS::Element
== Instance Methods

--- content
--- content=

--- domain
--- domain=

= class RSS::Rss::Channel::TextInput < RSS::Element
== Instance Methods

--- description
--- description=

--- link
--- link=

--- name
--- name=

--- title
--- title=

