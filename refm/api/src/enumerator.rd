#@since 1.9.0
このライブラリは後方互換性のためにのみ提供されています。

ruby-1.9.0 より [[c:Enumerable::Enumerator]] は組み込みクラスになりました。
require 'enumerator' を実行しても false を返すだけで何もしません。

#@else
#@include(_builtin/Enumerable__Enumerator)
#@end
