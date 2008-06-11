= オブジェクト指向スクリプト言語 Ruby リファレンスマニュアル

 * Ruby オフィシャルサイト [[url:http://www.ruby-lang.org/ja/]]
#@since 1.9.0
 * version 1.9 未対応リファレンス
#@else
 * version 1.8 対応(予定)リファレンス
#@end
 * 原著：まつもとゆきひろ
 * 最新版URL: [[url:http://www.ruby-lang.org/ja/documentation/]]

== 使用上の注意

#@since 1.9.0
Ruby 1.9 に関しては、言語仕様、組み込みライブラリ、標準添付ライブラリいずれも
まったく対応していません。信用してはいけません。
#@else
リファレンスが完全に揃っているのは Ruby 1.8 の組み込みライブラリに関してのみです。
Ruby 1.8 の標準添付ライブラリに関して、リファレンスは極めて不完全です。
#@end

== 目次

 * [[d:spec/intro]]
 * [[d:spec/commands]]
 * [[d:spec/rubycmd]]
 * [[d:spec/envvars]]

=== Ruby 言語仕様
  * [[d:spec/object]]
  * [[d:spec/class]]
  * [[d:spec/eval]]
  * [[d:spec/terminate]]
  * [[d:spec/thread]]
  * [[d:spec/safelevel]]
  * [[d:spec/regexp]]
#@since 1.9.0
  * [[d:spec/m17n]]
#@end

Ruby の文法:

  * [[d:spec/lexical]]
  * [[d:spec/program]]
  * [[d:spec/variables]]
  * [[d:spec/literal]]
  * [[d:spec/operator]]
  * [[d:spec/control]]
  * [[d:spec/call]]
  * [[d:spec/def]]

=== 組み込みライブラリ
  * [[lib:_builtin]]

=== 添付ライブラリ
  * [[lib:/]]

=== その他
#@#* [[c:Ruby変更履歴]]
#@#  * ((<ruby 1.8.5 feature>))
#@#  * ((<ruby 1.9 feature>))
#@#* 付録
#@##@# 使い方
#@#  * [[unknown:Ruby FAQ]]
#@#  * [[c:Rubyの落とし穴]]
#@#  * [[c:Rubyで使われる記号の意味]]
#@#  * [[unknown:packテンプレート文字列]]
#@#  * [[unknown:sprintfフォーマット]]
#@#  * [[unknown:Ruby が動作するプラットフォーム]]
  * [[d:grossary]]
  * [[d:symref]]
  * [[d:help]]
#@##@# 専門的
  * [[d:spec/bnf]]
#@#  * [[c:Marshalフォーマット]]
#@##@# マニュアル
#@#  * [[c:Rubyに関する書籍]]
#@#  * [[d:ReFe]]
#@#  * [[unknown:マニュアルダウンロード]]
#@#  * [[unknown:マニュアル更新履歴MLアーカイブ|URL:http://www.atdot.net/mla/mandiff@ruby/]]
#@#* [[unknown:参考文献・サイト]]
#@#* [[unknown:索引|method]]
#@#* [[unknown:機能別索引]]
  * [[d:license]]
