*.dllや*.soなど、ダイナミックリンクライブラリを扱うためのライブラリです。

=== 注意

このライブラリは 2.2.0 で削除されました。2.2.0 以降では [[lib:fiddle]]
を利用してください。

#@until 1.9.1

#@include(dl/dl1/dl.rd)
#@include(dl/dl1/DL)
#@include(dl/dl1/Handle)
#@include(dl/dl1/PtrData)
#@include(dl/dl1/Symbol)

#@else

#@include(dl/dl2/dl.rd)
#@include(dl/dl2/DL)
#@include(dl/dl2/Handle)
#@include(dl/dl2/CPtr)
#@include(dl/dl2/CFunc)

#@end

