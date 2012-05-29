= Time
== タイムゾーン

rubyが出力するタイムゾーン文字列はOSの実装に依存しています。以下のよう
な文字列を返すOSさえあります。
((-Windowsで環境変数TZを設定していないときにこのようになることがあるようです。-))

  $ ruby -e 'p Time.now'
  Mon Sep 04 17:32:11 東京 (標準時) 2000

また、カレントのタイムゾーンを返す実装も多く、Time.gmtime などの
効力が及ばない場合があります。

  puts Time.now.gmtime.strftime("%H:%M %Z") #-> 06:09 GMT+9:00

OSによらずruby自身が"UTC"を出力する場合もあるのでさらに複雑です。
((- ((<version 1.7|ruby 1.7 feature>))では ((<Time#zone|Time>)) は"UTC"
を返します-))

  $ ruby -e 'p Time.now.gmtime.zone'
  "GMT"
  $ ruby -e 'p Time.now.gmtime'
  Tue Jan 16 17:09:22 UTC 2001

これらの問題の影響を受けるメソッドには以下のものがあります。
  * Time#strftime
  * Time#zone
  * Time#to_s
  * Time#inspect
  * Time#to_a
