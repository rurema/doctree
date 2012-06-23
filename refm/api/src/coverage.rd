#@since 1.9.1
category Development

カバレッジを測定するためのライブラリです。

=== 使い方

以下のようにして測定を行います。

  (1) require "coverage" する
  (2) Coverage.start を実行する
  (3) require か load を実行する
  (4) Coverage.result の結果を確認する

=== 例

まず測定対象のソースを用意します。

  # foo.rb
  s = 0
  10.times do |x|
    s += x
  end

  if s == 45
    p :ok
  else
    p :ng
  end

以下のようにして測定を行います。

  require "coverage"
  Coverage.start
  require "foo"
  p Coverage.result # => {"foo.rb"=>[1, 1, 10, nil, nil, 1, 1, nil, 0, nil]}

Coverage.result["foo.rb"]から得られる配列は各行の実行回数になっています。

= class Coverage

カバレッジを測定する機能を提供するクラスです。

実験的な機能のため、APIは将来変更になる可能性があります。

== Class Methods

--- start  -> nil

カバレッジの測定を開始します。既に実行されていた場合には何も起こりません。

--- result  -> Hash

測定結果をファイル名をキー、各行の実行回数を配列にした値のハッシュを返
します。空行やコメントのみの行などの測定結果は nil になります。result
メソッドが実行された後はカバレッジの測定を行いません。

@return 測定結果を表すハッシュ

@raise RuntimeError [[m:Coverage.start]] を実行する前に実行された場合に
                    発生します。

#@end
