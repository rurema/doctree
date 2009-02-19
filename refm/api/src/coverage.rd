#@since 1.9.1
カバレッジを測定するためのライブラリです。

= class Coverage

Coverage provides coverage measurement feature for Ruby.
This feature is experimental, so these APIs may be changed in future.

=== 使い方

(1) require "coverage"
(2) Coverage.start を実行
(3) Ruby の source file を require または load する
(4) Coverage.result で結果がかえる

=== 例

  [foo.rb]
  s = 0
  10.times do |x|
    s += x
  end

  if s == 45
    p :ok
  else
    p :ng
  end
  [EOF]

  require "coverage"
  Coverage.start
  require "foo.rb"
  p Coverage.result  #=> {"foo.rb"=>[1, 1, 10, nil, nil, 1, 1, nil, 0, nil]}

== Class Methods

--- Coverage.start  -> nil
カバレッジの測定を開始します。

--- Coverage.result  -> Hash
測定結果を返します。

Returns a hash that contains filename as key and coverage array as value
and disables coverage measurement.

#@end
