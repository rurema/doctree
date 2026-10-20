# Cygwin

Windows 上で [d:platform/Unix] をエミュレートする環境です。GNU ユーティリティが揃っており、Windows 上で Unix に近い環境を使えます。
Cygwin 環境でコンパイルされた実行ファイルには `cygwin1.dll` がリンクされ、この DLL が Unix のシステムコール等をエミュレートします。

詳細は <https://www.cygwin.com/> を参照してください。

Cygwin 版 Ruby は `cygwin1.dll` を必要とする反面、Unix 版との互換性が高いので、Unix 用のスクリプトが変更なしに動く可能性が高いという利点があります。
一方で、Cygwin 環境自体の制約を受けます。

Ruby のソースツリーには Cygwin 向けの設定(`configure.ac` の `cygwin*`)があり、MSYS2 の `msys` 環境も同様に扱われます。
Cygwin には保守担当者 (platform maintainer) がいません。

#%since 4.1
Ruby 4.1 で、Cygwin 1.3 まで向けのサポートコードを削除しました。
#%end

削除されたプラットフォームの一覧は [d:platform/index] を参照してください。
