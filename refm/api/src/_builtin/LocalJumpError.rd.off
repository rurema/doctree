= class LocalJumpError < StandardError

スコープを出てしまった [[c:Proc]] からの
[[unknown:制御構造/return]],
[[unknown:制御構造/break]],
[[unknown:制御構造/retry]] で発生します。

[[c:Proc]] の例を参照してください。

== Instance Methods

#@if (version >= "1.8.0")
--- exit_value

例外 LocalJumpError を発生させた break や return に指定した
戻り値を返します。

例:

  def foo
    proc { return 10 }
  end
  
  begin
    foo.call
  rescue LocalJumpError
    p $!
    p $!.reason
    p $!.exit_value
  end
  
  => ruby 1.8.0 (2003-06-09) [i586-linux]
     #<LocalJumpError: return from block-closure>
     :return
     10
  
  begin
    Block.new { break 5 }.call
  rescue LocalJumpError
    p $!
    p $!.reason
    p $!.exit_value
  end
  
  => ruby 1.8.0 (2003-06-09) [i586-linux]
     #<LocalJumpError: break from block-closure>
     :break
     5

--- reason

例外を発生させた原因をシンボルで返します。返す値は、

  * :break
  * :redo
  * :retry
  * :next
  * :return
#@#       * :noreason

のいずれかです。[[m:LocalJumpError#exit_value]] の例を参照してください。
#@end
