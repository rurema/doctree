# Win32ネイティブ版

Win32 ネイティブ版 Ruby を [d:platform/Cygwin] 版と比較すると以下の利点があります。

  - Cygwin DLL が必要ない

欠点は以下の通りです。

  - Unix 版との互換性が低い

この点については [d:platform/mswin32-compat] も参照してください。

ネイティブビルドは、使うコンパイラと C ランタイムによって次の 3 種類に分かれます。

  - [d:platform/mswin32] 版: Visual C++ でビルドしたもの
  - [d:platform/MinGW] 版(mingw-msvcrt): MinGW で `msvcrt.dll` 系の C ランタイムを使うもの
  - [d:platform/MinGW] 版(mingw-ucrt): MinGW で Windows Universal CRT を使うもの

これらの版の間に大きな違いはなく、Ruby レベルで違いがわかることはまずありません。
ただし Ruby 1.6 まではそれぞれで DLL 名が違うため、拡張ライブラリは流用できませんでした。この点は Ruby 1.8 以降では改善されています。

Borland C++ (bcc32) のサポートは Ruby 1.9.1 で終了しました。

#%since 4.0
Ruby 4.0 から、MSVC でビルドするには MSVC 14.0 (Visual Studio 2015) 以降が必要です。
#%end

#%since 4.1
Ruby 4.1 では次の変更があります。

  - Windows 10 1703 以降では、260 文字を超えるパスを扱うために `LongPathsEnabled` レジストリ値を設定する必要がなくなりました。[bug:18947]
  - 64 ビットの mswin 版で、[c:String]、[c:Array]、[c:MatchData] の長さが 2 GiB 以上になれるようになりました。それまでは長さが 32 ビットの `long` でした。[feature:22400]
  - MSVC でビルドする場合は Visual Studio 2017 version 15.8 以降が必要です。
  - MSVC でビルドした Ruby は Windows 10 version 1809 (build 17763) または Windows Server 2019 以降が必要です。それより前の Windows 10 と Windows Server 2016 は対象外です。
#%end

削除されたプラットフォームの一覧は [d:platform/index] を参照してください。
