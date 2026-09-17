---
library: rss
---
# class RSS::Maker::ChannelBase < Object

channel要素の値を設定します。

RSS 1.0を生成する場合はabout、title、link、
descriptionを設定しなければいけません。

RSS 0.91を生成する場合はtitle、link、
description、languageを設定しなければいけません。

RSS 2.0を生成する場合はtitle、link、
descriptionを設定しなければいけません。

maker.channelになんらかの値を設定しておきながら、上記のmaker.channelが要求する値を設定していない場合は
RSS::NotSetError例外が発生します。どの値も設定していない場合は例外は発生しません。

## Instance Methods

### def about
### def about=(about)
#%todo

### def title
### def title=(title)
#%todo

### def link
### def link=(link)
#%todo

### def description
### def description=(description)
#%todo

### def language
### def language=(language)
#%todo

### def copyright
### def copyright=(copyright)
#%todo

### def managingEditor
### def managingEditor=(managingEditor)
#%todo

### def webMaster
### def webMaster=(webMaster)
#%todo

### def rating
### def rating=(rating)
#%todo

### def docs
### def docs=(docs)
#%todo

### def date
### def date=(date)
#%todo

### def pubDate
#%todo
maker.channel.dateの別名です。

### def pubDate=(pubDate)
#%todo
maker.channel.date=の別名です。

### def lastBuildDate
### def lastBuildDate=(lastBuildDate)
#%todo

### def generator
### def generator=(generator)
#%todo

### def ttl
### def ttl=(ttl)
#%todo

### def categories
#%todo
categoriesを返します。

### def cloud
#%todo
cloudを返します。

### def skipDays
#%todo
skipDaysを返します。

### def skipHours
#%todo
skipHoursを返します。

# class RSS::Maker::RSS09::Channel < RSS::Maker::ChannelBase

# class RSS::Maker::RSS10::Channel < RSS::Maker::ChannelBase

# class RSS::Maker::RSS20::Channel < RSS::Maker::RSS09::Channel
