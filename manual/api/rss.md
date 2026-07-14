---
type: library
category: FileFormat
---
#@# = rss

RSS を扱うためのライブラリです。

### 参考

  - RSS 0.91 <http://backend.userland.com/rss091>
  - RSS 1.0  <http://purl.org/rss/1.0/spec>
  - RSS 2.0  <http://www.rssboard.org/rss-specification>
  - Atom 1.0 <https://www.ietf.org/rfc/rfc4287.txt>
#@include(rss/Tutorial)

# class RSS::Element < Object
## Instance Methods

### def full_name
#@todo

### def tag_name
#@todo

# module RSS::RootElementMixin
## Instance Methods

### def output_encoding
### def output_encoding=
#@todo

### def to_xml
#@todo

# class RSS::Error < StandardError

# class RSS::InvalidRSSError < RSS::Error

# class RSS::OverlappedPrefixError < RSS::Error
# class RSS::MissingTagError < RSS::InvalidRSSError
# class RSS::TooMuchTagError < RSS::InvalidRSSError
# class RSS::MissingAttributeError < RSS::InvalidRSSError
# class RSS::UnknownTagError < RSS::InvalidRSSError
# class RSS::NotExpectedTagError < RSS::InvalidRSSError
# class RSS::NotAvailableValueError < RSS::InvalidRSSError
# class RSS::UnknownConversionMethodError < RSS::Error
# class RSS::ConversionError < RSS::Error
# class RSS::NotSetError < RSS::Error

