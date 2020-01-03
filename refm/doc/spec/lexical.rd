= 字句構造

  * [[ref:identifier]]
  * [[ref:comment]]
  * [[ref:embed]]
  * [[ref:reserved]]

Rubyの現在の実装はASCIIキャラクタセットを用いています。アル
ファベットの大文字と小文字は区別されます。識別子と一部のリテ
ラルの途中を除いては任意の場所に空白文字やコメントを置くこと
ができます。空白文字とはスペース、タブ、垂直タブ、バックスペー
ス、キャリッジリターン、ラインフィード、改ページです。改行は行が明らかに次の
行に継続する時だけ、空白文字として、それ以外では文の区切りと
して解釈されます。

改行と認識されるのは、キャリッジリターン+ラインフィードかラインフィードです。

===[a:identifier] 識別子

例:

          foobar
          ruby_is_simple

Rubyの識別子は英文字またはアンダースコア('_')か
ら始まり、英文字、アンダースコア('_')または数字
からなります。識別子の長さに制限はありません。

===[a:comment] コメント

例:

          # this is a comment line

スクリプト言語の習慣にならい、文字列中や文字リテラル `?#' 以外の
#から行末までをコメントと見なします。

===[a:embed] 埋め込みドキュメント

例:

          =begin
          the everything between a line beginning with `=begin' and
          that with `=end' will be skipped by the interpreter.
          =end

Rubyのソースコードにドキュメントを埋め込む事ができます。文が
始まる部分の行頭の=beginから、=endで始まる行までが
埋め込みドキュメントです。Ruby インタプリタとしては内容に縛りは
かけませんが、通常は RD 形式でドキュメントを埋め込むことを
期待しています。

===[a:reserved] 予約語

予約語は以下のものです。

          BEGIN    class    ensure   nil      self     when
          END      def      false    not      super    while
          alias    defined? for      or       then     yield
          and      do       if       redo     true     __LINE__
          begin    else     in       rescue   undef    __FILE__
#@since 1.9.1
          break    elsif    module   retry    unless   __ENCODING__
#@else
          break    elsif    module   retry    unless
#@end
          case     end      next     return   until

予約語はクラス名、変数名などに用いることはできません。ただし
接頭辞$, @、@@が先頭についたものは予約語
とは見なされません。また、def のあとやメソッド呼び出しの
ピリオドのあとなどメソッド名であるとはっきり分かる場所では
メソッド名として用いることができます。
