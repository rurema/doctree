= Ruby 標準 API リファレンスマニュアル

== 組み込みクラス

* ((<Object>))
  * ((<Array>))
  * ((<Binding>))
  * ((<Continuation>))
  * ((<Data>))
  * ((<Exception>)) (((<組み込みクラス／モジュール／例外クラス/例外クラス>))参照)
  * ((<Dir>))
  * ((<File::Stat>))
  * ((<Hash>))
  * ((<IO>))
    * ((<File>))
  * ((<MatchData>))
  * ((<Method>))
    * (((<UnboundMethod>)))  (((<ruby 1.7 feature>)) ((*version 1.6以前の位置*)))
  * ((<Module>))
    * ((<Class>))
  * ((<Numeric>))
    * ((<Integer>))
      * ((<Bignum>))
      * ((<Fixnum>))
    * ((<Float>))
  * ((<Proc>))
  * ((<Process::Status>))  (((<ruby 1.7 feature>)))
  * ((<Range>))
  * ((<Regexp>))
  * ((<String>))
  * ((<Struct>))
  * ((<Symbol>))
  * ((<Thread>))
  * ((<ThreadGroup>))
  * ((<Time>))
  * ((<UnboundMethod>))         (((<ruby 1.7 feature>)))
  * ((<TrueClass>))
  * ((<FalseClass>))
  * ((<NilClass>))

== 組み込みモジュール

* ((<Comparable>))
* ((<Enumerable>))
* ((<Errno>))
* ((<File::Constants>))
* ((<FileTest>))
* ((<GC>))
* ((<Kernel>))
* ((<Marshal>))
* ((<Math>))
* ((<ObjectSpace>))
* ((<Precision>))
* ((<Process>))
* ((<Process::GID>))
* ((<Process::Sys>))
* ((<Process::UID>))
* ((<Signal>))

== 例外クラス

* ((<Object>))
  * ((<Exception>))
    * (((<Interrupt>))) (((<ruby 1.7 feature>)) ((*version 1.6以前の位置*)))
    * ((<NoMemoryError>))
    * ((<ScriptError>))
      * ((<LoadError>))
      * (((<NameError>)))  (((<ruby 1.7 feature>)) ((*version 1.6以前の位置*)))
      * ((<NotImplementedError>))
      * ((<SyntaxError>))
    * ((<SignalException>))
      * ((<Interrupt>)) (((<ruby 1.7 feature>)))
    * ((<StandardError>))
      * ((<ArgumentError>))
      * ((<IndexError>))
        * ((<KeyError>))        (((<ruby 1.9 feature>)))
      * ((<IOError>))
        * ((<EOFError>))
      * ((<LocalJumpError>))
      * ((<NameError>))  (((<ruby 1.7 feature>)))
        * ((<NoMethodError>)) (((<ruby 1.7 feature>)))
      * ((<RangeError>))
        * ((<FloatDomainError>))
      * ((<RegexpError>))
      * ((<RuntimeError>))
      * ((<SecurityError>))
      * ((<SystemCallError>))
        * ((<Errno::EXXX>))
      * ((<SystemStackError>))
      * ((<ThreadError>))
      * ((<TypeError>))
      * ((<ZeroDivisionError>))
    * ((<SystemExit>))
    * ((<fatal>))

* ((<添付ライブラリ>))

== 単品

残したい

  * ((<packテンプレート文字列>))
  * ((<sprintfフォーマット>))
  * ((<Marshalフォーマット>))
  * ((<疑似BNFによるRubyの文法>))

微妙

  * ((<参考文献・サイト>))
  * ((<Ruby用語集>))
  * ((<索引|method>))

== 変更履歴

これも移動すべきか

* ((<Ruby変更履歴>))
  * ((<ruby 1.8.5 feature>))
  * ((<ruby 1.9 feature>))

== 移動する

* ((<マニュアルダウンロード>))         → リファレンスマニュアルよりも上
* ((<リファレンスマニュアル検索ツール ReFe|ReFe>)) → ダウンロードの近く
* ((<Rubyに関する書籍>))              → www.ruby-lang.org
* ((<Ruby が動作するプラットフォーム>)) → www.ruby-lang.org

== 編集者向けの情報 (削除)

* ((<マニュアル更新履歴MLアーカイブ|URL:http://www.atdot.net/mla/mandiff@ruby/>))
