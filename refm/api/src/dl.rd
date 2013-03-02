*.dllや*.soなど、ダイナミックリンクライブラリを扱うためのライブラリです。

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

