# Ruby が動作するプラットフォーム

Ruby は様々な環境で動作するよう各方面の有志によって移植されています。
以下、Ruby の動作環境について OS や開発環境で大別して説明します。
プラットフォームごとの保守担当者 (platform maintainer) の一覧は Ruby のソースツリーの `doc/maintainers.md` にあります。mswin64、mingw32 (MinGW)、AIX、FreeBSD、Solaris、RHEL/CentOS、macOS、OpenBSD、WebAssembly/WASI には担当者がいて、Cygwin にはいません。

インストールやコンパイルに関しては、「Rubyのインストール」(<https://www.ruby-lang.org/ja/documentation/installation/>)を参照。

  - [d:platform/Unix]
  - [d:platform/Win32]
    - [d:platform/Win32-native]
      - [d:platform/mswin32]
      - [d:platform/MinGW], [d:platform/mingw32]
    - [d:platform/Cygwin]
  - [d:platform/MacOSX]
  - [d:platform/GNU], [d:platform/GNUHurd]

#%since 3.2
## WebAssembly/WASI

Ruby 3.2 で WebAssembly/WASI がサポート対象のプラットフォームに加わりました。詳細は Ruby のソースツリーの `wasm/README.md` と ruby.wasm (<https://github.com/ruby/ruby.wasm>) を参照してください。[feature:18462]

#%end

## サポートを削除したプラットフォーム

次の表は、Ruby の NEWS に記載されているサポート削除のうち、プラットフォームに関するものをまとめたものです。サポートの再開や、よく似たプラットフォームを扱うときの参考として載せています。
NEWS に記載されていない削除は含まれません。「サポートを削除した版」は、その版でサポートコードが削除されたことを表します。

| プラットフォーム | サポートを削除した版 | 備考 |
|---|---|---|
| djgpp | Ruby 1.9.1 | |
| bcc32 (Borland C++) | Ruby 1.9.1 | Ruby 2.3 の NEWS にも Borland-C の記載がある |
| human68k | Ruby 1.9.1 | |
| Mac OS 9 まで | Ruby 1.9.1 | |
| VMS | Ruby 1.9.1 | |
| Windows CE | Ruby 1.9.1 | |
| OS/2 | Ruby 2.3 | |
| BeOS | Ruby 2.3 | |
| Borland-C | Ruby 2.3 | bcc32 は Ruby 1.9.1 で削除 |
| FreeBSD 4 より前 | Ruby 2.4 | |
| NaCl (Native Client) | Ruby 2.5 | |
| IA64 | Ruby 2.7 | [feature:15894] |
#%since 4.0
| MSVC 14.0 より前 (Visual Studio 2015 より前) | Ruby 4.0 | |
#%end
#%since 4.1
| AmigaOS | Ruby 4.1 | |
| AtheOS | Ruby 4.1 | |
| BSD/OS (BSDi) | Ruby 4.1 | |
| ESIX | Ruby 4.1 | |
| EWS-UX (NEC EWS4800) | Ruby 4.1 | |
| a.out バイナリの FreeBSD/NetBSD/OpenBSD | Ruby 4.1 | |
| GNU/kFreeBSD | Ruby 4.1 | GNU Hurd は対象外 |
| GNU/kOpenSolaris | Ruby 4.1 | GNU Hurd は対象外 |
| HI-UX/MPP | Ruby 4.1 | |
| HP 9000 Series 300 の HP-UX | Ruby 4.1 | |
| Interix (Windows Services for UNIX) | Ruby 4.1 | |
| IRIX | Ruby 4.1 | |
| MirOS BSD | Ruby 4.1 | |
| NeXTSTEP/OpenStep/Rhapsody | Ruby 4.1 | |
| OSF/1 (Tru64 UNIX) | Ruby 4.1 | |
| QNX Neutrino | Ruby 4.1 | |
| SunOS 4 | Ruby 4.1 | Solaris (SunOS 5) は影響なし |
| System V Release 4 | Ruby 4.1 | |
| UNICOS/mp (Cray X1) | Ruby 4.1 | |
| UX/PDS | Ruby 4.1 | |
| Cygwin 1.3 まで | Ruby 4.1 | |
| Solaris 9 まで | Ruby 4.1 | |
| Linux 2.6.23 まで (RHEL 5) | Ruby 4.1 | |
| Visual Studio 2017 version 15.8 より前 | Ruby 4.1 | MSVC でビルドする場合の要件 |
| Windows 10 version 1809 より前と Windows Server 2016 | Ruby 4.1 | MSVC でビルドした Ruby の要件 |
| Mac OS X 10.5 までと PowerPC Mac | Ruby 4.1 | |
#%end

#%since 4.1
Ruby 4.1 で削除した理由として NEWS には、ベンダーのサポートが終了していること、テストできる環境が無いこと、保守担当者がいないことが挙げられています。
#%end
