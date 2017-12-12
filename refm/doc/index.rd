= オブジェクト指向スクリプト言語 Ruby リファレンスマニュアル

 * Ruby オフィシャルサイト [[url:https://www.ruby-lang.org/ja/]]
#@if("2.5.0" <= version and version < "2.6.0")
 * version 2.5 対応リファレンス
#@end
#@if("2.4.0" <= version and version < "2.5.0")
 * version 2.4 対応リファレンス
#@end
#@if("2.3.0" <= version and version < "2.4.0")
 * version 2.3 対応リファレンス
#@end
#@if("2.2.0" <= version and version < "2.3.0")
 * version 2.2 対応リファレンス
#@end
#@if("2.1.0" <= version and version < "2.2.0")
 * version 2.1 対応リファレンス
#@end
 * 原著：まつもとゆきひろ
 * 最新版URL: [[url:https://www.ruby-lang.org/ja/documentation/]]

=== 使用上の注意

#@if("2.5.0" <= version and version < "2.6.0")
Ruby 2.5 の組込みクラスのリファレンスはほぼ揃っています。
Ruby 2.5 の標準添付ライブラリのリファレンスは一部未完成です。
#@end
#@if("2.4.0" <= version and version < "2.5.0")
Ruby 2.4 の組込みクラスのリファレンスはほぼ揃っています。
Ruby 2.4 の標準添付ライブラリのリファレンスは一部未完成です。
#@end
#@if("2.3.0" <= version and version < "2.4.0")
Ruby 2.3 の組込みクラスのリファレンスはほぼ揃っています。
Ruby 2.3 の標準添付ライブラリのリファレンスは一部未完成です。
#@end
#@if("2.2.0" <= version and version < "2.3.0")
Ruby 2.2 の組込みクラスのリファレンスはほぼ揃っています。
Ruby 2.2 の標準添付ライブラリのリファレンスは一部未完成です。
#@end
#@if("2.1.0" <= version and version < "2.2.0")
Ruby 2.1 の組込みクラスのリファレンスはほぼ揃っています。
Ruby 2.1 の標準添付ライブラリのリファレンスは一部未完成です。
#@end

それ以外のドキュメントについては、まだまだ書き直しが必要です。

=== 目次

 * [[d:spec/intro]]
 * [[d:spec/commands]]
 * [[d:spec/rubycmd]]
 * [[d:spec/envvars]]

==== Ruby 言語仕様

Ruby でのオブジェクト:
  * [[d:spec/object]]
  * [[d:spec/class]]

プロセスの実行:
  * [[d:spec/eval]]
  * [[d:spec/terminate]]
  * [[d:spec/thread]]
  * [[d:spec/safelevel]]

Ruby の文法:
  * [[d:spec/lexical]]
  * [[d:spec/program]]
  * [[d:spec/variables]]
  * [[d:spec/literal]]
  * [[d:spec/operator]]
  * [[d:spec/control]]
  * [[d:spec/call]]
  * [[d:spec/def]]

その他:
  * [[d:spec/m17n]]
  * [[d:spec/regexp]]
  * [[d:spec/lambda_proc]]

==== 組み込みライブラリ
  * [[lib:_builtin]]

==== 標準添付ライブラリ
  * [[lib:/]]

==== C API
  * [[f:/]]

==== その他
  * [[d:news/index]]
#@#* 付録
#@##@# 使い方
#@#  * [[unknown:Ruby FAQ]]
#@#  * [[c:Rubyの落とし穴]]
  * [[d:pack_template]]
  * [[d:print_format]]
#@#  * [[unknown:Ruby が動作するプラットフォーム]]
  * [[d:glossary]]
  * [[d:symref]]
#@##@# 専門的
  * [[d:spec/bnf]]
  * [[d:marshal_format]]
#@##@# マニュアル
#@#  * [[c:Rubyに関する書籍]]
#@#  * [[d:ReFe]]
#@#  * [[unknown:マニュアルダウンロード]]
#@#  * [[unknown:マニュアル更新履歴MLアーカイブ|URL:http://www.atdot.net/mla/mandiff@ruby/]]
#@#* [[unknown:参考文献・サイト]]
#@#* [[unknown:索引|method]]
#@#* [[unknown:機能別索引]]
  * [[d:license]]
  * [[d:help]]
