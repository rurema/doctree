
= class TkVariable < Object

extend TkCore
include Tk
include Comparable

Tclの変数をアクセスするためのクラスです。
((-Tclの配列としての振る舞いは仕様が不安定のようです-))

  require "tk"
  p TkVariable.new(0).value                     # => "0"
  p TkVariable.new(1.2).value                   # => "1.2"
  p TkVariable.new(["a", "b"]).value            # => {"0"=>"a", "1"=>"b"}
  p TkVariable.new(1=>"a", 2=>"b").value        # => {"1"=>"a", "2"=>"b"}


== Class Methods

--- callback(args)
#@todo

[[m:TkVariable#trace]]により登録されたProcオブジェクトを実行します。
args は、 [TkVariableのインスタンス, "キー", "操作"]
である配列です。

--- new(val="")
#@todo

値がvalであるTkVariableオブジェクトを生成します。valが
[[c:Array]] または [[c:Hash]] のオブジェクトである場合、生成されたインス
タンスは Tclの配列として振る舞います。

--- new_hash(val = {})
#@todo

== Instance Methods

--- wait
#@todo

値が変化するまで待ちます。

--- value
#@todo

値を返します。selfがTclの配列ならば(Tclの配列は連想配列な
ので) [[c:Hash]]として返します。それ以外では常に文字列を返します。

--- value=(val)
#@todo

値をvalに設定します。

--- set_value(val)
#@todo

値を val に設定し、self を返します。

--- set_value_type(val)
--- value_type=
#@todo


--- [](index)
#@todo

index番目の値を返します。
selfはTclの配列でなければなりません。

--- []=(index, val)
#@todo

index番目の要素をvalにします。
selfはTclの配列でなければなりません。

--- to_i
#@todo

値を数値([[c:Fixnum]])として返します。(現状のTkVariableは、
Bignumを値にすることはできません)

--- element_to_i(*idxs)
#@todo


--- to_f
#@todo

値を数値([[c:Float]])として返します。


--- element_to_f(*idxs)
#@todo


--- to_s
#@todo

値を文字列([[c:String]])として返します。

--- to_a
#@todo

値を配列([[c:Array]])として返します。

--- ==(other)
#@todo

値がotherと同じである場合に真です。otherは、
TkVariable, String, Integer, Float, Arrayのいずれかです。

--- <=>(other)
#@todo

--- &(other)
#@todo

--- |(other)
#@todo

--- +(other)
#@todo

--- -(other)
#@todo

--- *(other)
#@todo

--- /(other)
#@todo

--- %(other)
#@todo

--- **(other)
#@todo

--- =~(other)
#@todo

--- unset(elem=nil)
--- remove(elem=nil)
#@todo

値がTcl配列であるとき、elemの値を削除します。

--- id
#@todo

--- is_hash?
#@todo

--- is_scalar?
#@todo

--- keys
#@todo

--- ref(*idxs)
#@todo

--- exist?(*elems)
#@todo


--- trace_callback(elem, op)
#@todo

[[m:TkVariable#trace]]により登録されたProcオブジェクトを引数にself,
elem, opを指定して実行します。

  require "tk"

  var = TkVariable.new(0)

  var.trace "rwu", proc {|arg| puts "callback called with #{arg.inspect}"}
  var.trace_callback([], "r")

--- trace(opts, cmd)
#@todo

optsは、"r", "w", "u" のいずれか、またはこれらの組み合わせで、それぞれ
変数が参照、設定、削除 されたときに[[c:Proc]]オブジェクト cmd を
呼び出します。2回目以降の呼び出しでは、opts が以前の設定と異なれ
ばcmdを再設定します。

cmdは、引数に、self、空配列、"操作" を渡されて呼ばれ
ます。"配列のキー" は、変数が配列の場合以外は空文字列です。"操作"は、
"r","w","u" のいずれかです。

  require "tk"
  
  var = TkVariable.new(0)
  
  var.trace "rwu", proc {|arg| puts "callback called with #{arg.inspect}"}
  
  p var.value
  p var.value = 1
  p var.unset
  
  =>callback called with [<TkVariable: v00000>, [], "r"]
    "0"
    callback called with [<TkVariable: v00000>, [], "w"]
    "1"
    callback called with [<TkVariable: v00000>, [], "u"]
    ""

--- trace_element(elem, opts, cmd)
#@todo

--- trace_vinfo
#@todo

#@if (version <= "1.8.2")
--- trace_vinfo_for_element(elem)
#@todo

#@end

--- trace_vdelete(opts, cmd)
#@todo

[[m:TkVariable#trace]] で設定したcmdを削除します。opts が TkVariable#trace で
設定したときと一致しなければ何もしません。

--- trace_vdelete_for_element(elem, opts, cmd)
#@todo

--- clear
#@todo

--- coerce(other)
#@todo

--- size
#@todo

--- lappend(*elems)
#@todo

--- element_lappend(idxs, *elems)
#@todo

--- lindex(idx)
--- lget(idx)
#@todo

--- element_lindex(elem_idxs, idx)
--- element_lget(elem_idxs, idx)
#@todo

--- lget_i(idx)
#@todo

--- element_lget_i(elem_idxs, idx)
#@todo

--- lget_f(idx)
#@todo

--- element_lget_f(elem_idxs, idx)
#@todo

--- lset(idx, val)
#@todo

--- element_lset(elem_idxs, idx, val)
#@todo


--- bool
#@todo

--- bool=
--- set_bool
#@todo

--- list
#@todo

--- list=
#@todo

--- set_list(val)
#@todo

--- list_element(*idxs)
--- element_to_a(*idxs)
#@todo

--- list_type=
--- set_list_type(val)
#@todo

--- set_list_element_type(idxs, val)
#@todo


--- numeric
#@todo

--- numeric=
#@todo

--- set_numeric(val)
#@todo

--- numeric_element(*idxs)
#@todo

--- set_numeric_element(idxs, val)
#@todo

--- set_numeric_type(val)
--- numeric_type=
#@todo

--- set_numeric_element_type(idxs, val)
#@todo



--- bool_element
#@todo

--- set_bool_element
#@todo

--- bool_type=
--- set_bool_type(val)
#@todo

--- set_bool_element_type(idxs, val)
#@todo

--- numlist
#@todo

--- numlist_element(*idxs)
#@todo

--- set_numlist(val)
--- numlist=
#@todo

--- set_numlist_type(val)
--- numlist_type=
#@todo

--- set_numlist_element_type(idxs, val)
#@todo

--- set_list_element(idxs, val)
--- set_numlist_element(idxs, val)
#@todo

--- procedure
#@todo

--- set_procedure(cmd)
--- procedure=
#@todo

--- procedure_element(*idxs)
#@todo

--- set_procedure_element(idxs, cmd)
#@todo

--- procedure_type=
--- set_procedure_type(cmd)
#@todo

--- set_procedure_element_type(idxs, cmd)
#@todo

--- string
#@todo

--- string=
--- set_string(val)
#@todo

--- element_to_s(*idxs)
--- string_element(*idxs)
#@todo

--- set_string_element(idxs, val)
#@todo

--- string_type=
--- set_string_type(val)
#@todo

--- set_string_element_type(idxs, val)
#@todo

--- set_element_value(idxs, val)
#@todo

--- set_element_value_type(idxs, val)
#@todo


--- default_value(val = nil)
--- default_value(val = nil) { .... }
#@todo

--- default_value=
#@todo

--- set_default_value(val)
#@todo

--- default_element_value_type(idxs)
#@todo

--- default_value_type
#@todo

--- default_value_type=
--- set_default_value_type(type)
#@todo

--- set_default_element_value_type(idxs, type)
#@todo


--- default_proc(cmd = Proc.new)
#@todo

--- undef_default
#@todo

--- eventloop_wait(check_root = false)
#@todo

--- thread_wait(check_root = false)
#@todo

--- tkwait(on_thread = true)
#@todo

--- eventloop_tkwait
#@todo

--- thread_tkwait
#@todo

--- to_eval
#@todo

--- symbol
--- to_sym
#@todo

--- element_to_sym(*idxs)
#@todo


--- symbol=
--- set_symbol(val)
#@todo

--- symbol_element
#@todo

--- symbol_type=
--- set_symbol_type(val)
#@todo

--- set_symbol_element(idxs, val)
#@todo

--- set_symbol_element_type(idxs, val)
#@todo


--- update(hash)
#@todo

--- variable
#@todo

--- set_variable(var)
--- variable=
#@todo

--- variable_element(*idxs)
#@todo

--- set_variable_element(*idxs)
#@todo

--- set_variable_type(var)
--- variable_type=
#@todo

--- set_variable_element_type(idxs, var)
#@todo

--- window
#@todo

--- set_window(win)
--- window=
#@todo

--- window_element(*idxs)
#@todo

--- set_window_element(idxs, win)
#@todo

--- set_window_type(win)
--- window_type=
#@todo

--- set_window_element_type(idxs, win)
#@todo


--- zero?
#@todo

--- nonzero?
#@todo

== Constants

--- TkVar_CB_TBL
#@todo

コールバック関数を記録するハッシュです。内部で利用しています。

--- Tk_VARIABLE_ID
#@todo

Tclレベルの変数名をインスタンスに割り当てるために内部で利用されています。

Tk_VARIABLE_IDは、配列ですが0番目の要素しか使われていません。
Rubyにおける定数が値を変更できないためです。

--- TkCommandNames
#@todo

--- TkVar_ID_TBL
#@todo

--- USE_TCLs_SET_VARIABLE_FUNCTIONS
#@todo

= class TkVarAccess < TkVariable

Tclライブラリなどで既に定義されている変数にアクセスするためのクラスで
す。((-Tclのスコープを意識して利用しないとうまくアクセスできないと思わ
れる。また、現状Tclの配列にはアクセスすることはできない-))

  require 'tk'
  p TkCore::INTERP._eval("set tclvar 1")  # => 1
  var = TkVarAccess.new("tclvar", 2)
  p TkCore::INTERP._eval("set tclvar")    # => 2
  var.value = 3
  p TkCore::INTERP._eval("set tclvar")    # => 3

== Class Methods

--- new(name, *args)
#@todo

Tcl変数 varname と生成したインスタンスを関連付けます。
val を指定すると値の設定も行います。

--- new_hash(name, *args)
#@todo

