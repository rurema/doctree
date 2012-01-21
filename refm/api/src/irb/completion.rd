#@# Author: Keiju ISHITSUKA

require readline

irb の completion 機能を提供するライブラリです。

=== 使い方

   $ irb -r irb/completion

とするか, ~/.irbrc 中に

   require "irb/completion"

を入れてください.
irb実行中に require "irb/completion" してもよいです.

irb 実行中に [Tab] を押すとコンプレーションします.

トップレベルで [Tab] を押すとすべての構文要素, クラス,
メソッドの候補がでます. 候補が唯一ならば完全に補完します.

  irb(main):001:0> in    
  in                    inspect               instance_eval
  include               install_alias_method  instance_of?
  initialize            install_aliases       instance_variables
  irb(main):001:0> inspect
  "main"
  irb(main):002:0> foo = Object.new
  #<Object:0x4027146c>

"変数名." の後に [Tab] を押すと, そのオブジェクトのメソッド一覧がでます.

  irb(main):003:0> foo.
  foo.==                  foo.frozen?             foo.protected_methods
  foo.===                 foo.hash                foo.public_methods
  foo.=~                  foo.id                  foo.respond_to?
  foo.__id__              foo.inspect             foo.send
  foo.__send__            foo.instance_eval       foo.singleton_methods
  foo.class               foo.instance_of?        foo.taint
  foo.clone               foo.instance_variables  foo.tainted?
  foo.display             foo.is_a?               foo.to_a
  foo.dup                 foo.kind_of?            foo.to_s
  foo.eql?                foo.method              foo.type
  foo.equal?              foo.methods             foo.untaint
  foo.extend              foo.nil?                
  foo.freeze              foo.private_methods     

= module IRB::Completor

irb の completion 機能を提供するモジュールです。
ユーザがこのモジュールを直接使用することはありません。

