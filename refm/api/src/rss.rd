#@if (version >= "1.8.2")
category FileFormat

#@# = rss

RSS を扱うためのライブラリです。

=== 参考

  * RSS 0.91 [[url:http://backend.userland.com/rss091]]
  * RSS 1.0  [[url:http://purl.org/rss/1.0/spec]]
  * RSS 2.0  [[url:http://www.rssboard.org/rss-specification]]
  * Atom 1.0 [[url:https://www.ietf.org/rfc/rfc4287.txt]]
#@include(rss/Tutorial)
#@include(rss/0.9.rd)
#@include(rss/1.0.rd)
#@include(rss/2.0.rd)
#@include(rss/dublincore.rd)
#@include(rss/syndication.rd)
#@include(rss/taxonomy.rd)
#@include(rss/image.rd)
#@include(rss/trackback.rd)
#@include(rss/content.rd)
#@include(rss/XMLStyleSheet)
#@include(rss/maker/Categories)
#@include(rss/maker/Channel)
#@include(rss/maker/Maker)
#@include(rss/maker/XMLStyleSheet)
#@include(rss/maker/SkipDays)
#@include(rss/maker/SkipHours)
#@include(rss/maker/Image)
#@include(rss/maker/Items)
#@include(rss/maker/Textinput)
#@include(rss/Parser)

= class RSS::Element < Object
== Instance Methods

--- full_name
#@todo

--- tag_name
#@todo

= module RSS::RootElementMixin
== Instance Methods

--- output_encoding
--- output_encoding=
#@todo

--- to_xml
#@todo

= class RSS::Error < StandardError

= class RSS::InvalidRSSError < RSS::Error

= class RSS::OverlappedPrefixError < RSS::Error
= class RSS::MissingTagError < RSS::InvalidRSSError
= class RSS::TooMuchTagError < RSS::InvalidRSSError
= class RSS::MissingAttributeError < RSS::InvalidRSSError
= class RSS::UnknownTagError < RSS::InvalidRSSError
= class RSS::NotExpectedTagError < RSS::InvalidRSSError
= class RSS::NotAvailableValueError < RSS::InvalidRSSError
= class RSS::UnknownConversionMethodError < RSS::Error
= class RSS::ConversionError < RSS::Error
= class RSS::NotSetError < RSS::Error

#@end
