#@if (version >= "1.7.0")
= class NameError < StandardError
#@else
= class NameError < ScriptError
#@end

未定義のローカル変数や定数を使用したときに発生します。

== Class Methods

#@if (version >= "1.8.0")
--- new(error_message[, name])

例外オブジェクトを生成して返します。nameは未定義だったシンボルです。

例:

  err = NameError.new("message", "foo")
  p err
  p err.name

  # => #<NameError: message>
             "foo"
#@end

== Instance Methods

--- name

未定義だったシンボルを返します。

例:

  begin
    foobar
  rescue NameError
    p $!
    p $!.name
  end
  # => #<NameError: undefined local variable or method `foobar' for main:Object>
       :foobar
