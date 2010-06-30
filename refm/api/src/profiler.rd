プロファイラの実装です。
現在、[[lib:profile]] ライブラリは profiler ライブラリを
利用して実装されています。

= module Profiler__

プロファイラの実装です。
Profiler__.start_profile 実行から、Profiler__.stop_profile までの
区間の実行コードのプロファイルを取得します。

以下の使用例を参照してください。

    require 'profiler'

    Profiler__.start_profile
    require 'tk'    # このコードのプロファイルが測定される
    Profiler__.print_profile(STDOUT)

    # =>
     %   cumulative   self              self     total
    time   seconds   seconds    calls  ms/call  ms/call  name
    51.64     1.10      1.10        3   366.67   776.67  Kernel.require
    17.37     1.47      0.37        1   370.00   370.00  TclTkIp#initialize
     8.92     1.66      0.19      514     0.37     0.37  Module#method_added
     6.57     1.80      0.14        1   140.00   140.00  Profiler__.start_profile
     4.23     1.89      0.09       15     6.00    10.67  Kernel.extend
     3.29     1.96      0.07       15     4.67     4.67  Module#extend_object
     3.29     2.03      0.07      133     0.53     0.53  Kernel.singleton_method_added
     2.82     2.09      0.06       28     2.14     2.86  Module#attr
     1.88     2.13      0.04       19     2.11     2.11  Module#private
     1.41     2.16      0.03       29     1.03     1.38  Module#include
     0.94     2.18      0.02       10     2.00     4.00  Module#module_function
     0.94     2.20      0.02        2    10.00    10.00  Array#collect
       :
       :
    <snip>

== Module Functions

--- start_profile -> object

プロファイルの取得を開始します。

--- stop_profile -> nil

プロファイルの取得を停止します。

--- print_profile(file) -> ()

stop_profile を実行し、プロファイルの結果を file に出力します。
file には printf メソッドが定義されていなければいけません。

@param file [[c:File]] のインスタンスを指定します。

== Constants

--- PROFILE_PROC -> Proc

内部で使用します。
