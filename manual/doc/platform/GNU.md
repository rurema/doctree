# GNU

FSF (Free Software Foundation) が開発している OS です。GNU ユーティリティを使う Linux ディストリビューションを GNU/Linux と呼ぶこともあります。

GNU は "GNU is Not Unix" の略であり、ここでは [d:platform/Unix] とは別に扱います。このページでは主に GNU Hurd (カーネルの名前)で動く Ruby について触れます。

GNU Hurd 向けのパッチとして [ruby-dev:6712]、[ruby-dev:14603] の投稿があります。
現在の Ruby のソースツリーには GNU Hurd 専用の設定は無く、保守担当者 (platform maintainer) もいません。動作状況は不明です。

#%since 4.1
Ruby 4.1 で GNU/kFreeBSD と GNU/kOpenSolaris 向けのサポートコードを削除しました。GNU Hurd は対象ではありません。
#%end

<https://www.gnu.org/> 参照
