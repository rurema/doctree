# MinGW

フリーソフトウェアだけで Windows 用のネイティブ実行ファイルを作るためのコンパイル環境です。MinGW は Minimalist GNU for Windows の略です。現在は MinGW-w64 (<https://www.mingw-w64.org/>) のツールチェーンが使われています。

MinGW で作られた ruby は mingw32 版と呼ばれており、
[d:platform/mswin32] 版とほとんど同じように動作します。
MinGW を使う場合の C ランタイムには、`msvcrt.dll` 系 (mingw-msvcrt) と Windows Universal CRT (mingw-ucrt) の 2 種類があります。mingw-ucrt の `RUBY_PLATFORM` は `x64-mingw-ucrt` のようになります。
標準的なビルド環境は RubyInstaller-Devkit (<https://rubyinstaller.org/>) が提供する MSYS2 環境で、依存ライブラリは `pacman` で入れます。手順は Ruby のソースツリーの `doc/distribution/windows.md` を参照してください。

mingw32 版には保守担当者 (platform maintainer) がいます。

→[d:platform/Win32-native]
