# Unix

Unix そのものか、その互換 OS を指します。Linux、各種 BSD、Solaris、AIX などが含まれます。
[d:platform/Cygwin] を含めることもあります。

Ruby はもともと Unix 上で開発されてきており、機能的にもファイルシステム、プロセスの扱いなどで Unix 指向な部分があります。Unix 版 Ruby がすべての基本と言えます。

AIX、FreeBSD、Solaris、RHEL/CentOS、OpenBSD には保守担当者 (platform maintainer) がいます。`configure.ac` には、これらのほかに Linux、DragonFly BSD、NetBSD、Haiku などの設定があります。

#%since 4.1
Ruby 4.1 で、Solaris 9 までと Linux 2.6.23 まで (RHEL 5) 向けのサポートコードを削除しました。SunOS 4 も削除されましたが、Solaris (SunOS 5) は影響を受けません。
#%end

削除されたプラットフォームの一覧は [d:platform/index] を参照してください。
