[[c:Class]]、[[c:Module]]、[[c:Kernel]] といった基本的なクラスを拡張す
るためのサブライブラリです。

[注意] [[m:Object.psych_to_yaml]] などのメソッドは [[lib:syck]] が先に
読み込まれていた場合のために定義されています。[[lib:syck]] の廃止と共に
使用できなくなる予定ですので、psych_ のない方を利用してください。

= reopen Object

== Class Methods

--- yaml_tag(url)
#@todo

--- to_yaml(options = {}) -> String
--- psych_to_yaml(options = {}) -> String
#@todo

Convert an object to YAML.  See [[m:Psych.dump]] for more information
on the available options.

@see [[m:Psych.dump]]

= reopen Module

== Instance Methods

--- yaml_as(url)
--- psych_yaml_as(url)
#@todo

= reopen Kernel

== Instance Methods

--- y(*objects) -> String
--- psych_y(*objects) -> String
#@todo
