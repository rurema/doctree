require tk
require tk/button

= class TkRadioButton < TkButton

ラジオボタンウィジェットのクラスです。
ラジオボタンは、複数の選択項目のうちの1つを選択するウィジェットです。

  require "tk"
  v  = TkVariable.new
  c = proc {print v, "\n"}
  TkRadioButton.new {text "a"; variable v; value 1; select;   command c; pack}
  TkRadioButton.new {text "b"; variable v; value 2; deselect; command c; pack}
  TkRadioButton.new {text "c"; variable v; value 3; deselect; command c; pack}
  Tk.mainloop

== Instance Methods

--- deselect
#@todo

ラジオボタンをチェックしない状態にします。

--- select
#@todo

ラジオボタンをチェックした状態にします。

#@if (version <= "1.8.2")
--- variable(v)
#@todo

ラジオボタンの状態と [[c:TkVariable]] オブジェクトvの値を関連付けます。
同じTkVariableオブジェクトに関連付けされたラジオボタンは同じグループに
なります。ラジオボタンがチェックされるとvが
[[m:TkRadioButton#value]] で指定した値になります。

#@end

--- get_value
#@todo

--- set_value(val)
#@todo

ラジオボタンをチェックしたときの値をvalにします。

