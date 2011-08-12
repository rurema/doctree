
= module IRB::Notifier

== Module Functions

--- def_notifier(prefix = "", output_method = StdioOutputMethod.new)

= class IRB::Notifier::AbstractNotifier < Object

== Instance Methods

--- prefix

--- notify? -> bool

サブクラスで再定義します。

--- print(*opts)

--- printn(*opts)

--- printf(format, *opts)

--- puts(*objs)

--- pp(*objs)

--- ppx(prefix, *objs)

--- exec_if{|base_notifier| ... }

= class IRB::Notifier::CompositeNotifier < IRB::Notifier::AbstractNotifier



= class IRB::Notifier::LeveledNotifier < IRB::Notifier::AbstractNotifier



= class IRB::Notifier::NoMsgNotifier < IRB::Notifier::LeveledNotifier


