# Win32

Win32 API を使う Windows を総称して Win32 システムと呼びます。もともとは 32 ビットの Windows 95/98/Me/NT/2000/XP などを指す呼び名でしたが、このマニュアルでは 64 ビット (x64・arm64) の Windows も含めて慣用的に Win32 と呼びます。

Windows 用の Ruby は大きく分けると

  - [d:platform/Cygwin] 版
  - [d:platform/Win32-native] Ruby

の二種類があります。

このマニュアルの本文で断りなく Win32 版と言うときは
Win32 ネイティブ版を指すものとします。
Cygwin はそもそも Unix 互換レイヤを目指して開発されているので、基本的に Unix の流儀のほうが通用します。
Cygwin 版は Win32 ネイティブ版よりも Unix 版に近い挙動を示します。
