###nonref

= DOSISH 対応

ruby version 1.7 では、DOSISH対応(DOS/Windows のパス名の扱いに対する変
更)が含まれています。(現在の)変更点を以下に示します。

なお、これらの変更は [[d:platform/mswin32]] 版、[[d:platform/mingw32]]
版の Ruby にのみあてはまります。

とりあえずの目標として、

 * \ も / と同様パスセパレータとして扱う
 * マルチバイトパス名への対応("表" など 2 byte 目が 0x5c(`\') である文字を正しく扱う)
 * UNC 対応(これ自体は1.6にも入っている)
 * ドライブレター対応

への対応が挙げられていますが、ドライブレター対応などの微妙な部分については現在もruby-listなどで議論が継続されています。
現時点では、Fileの各メソッドに対する\対応, マルチバイトパス名対応, UNC 対応が実装されています。[[ruby-dev:13817]], [[ruby-dev:14097]]

以下、各メソッドの挙動について...

: File.dirname

  パスセパレータとして従来の/に加えて\も認識するようになっています。
  これに合わせて、マルチバイトで記述されたパス名への対応も行われています。

    p File.dirname("C:\\foo\\bar")

    => ruby 1.6.4 (2001-06-04) [i586-mswin32]
       "."

    => ruby 1.7.1 (2001-08-16) [i586-mswin32]
       "C:\\foo"

    p File.dirname("C:/foo")
    p File.dirname("C:\\foo")
    p File.dirname("C:foo")

    => ruby 1.6.4 (2001-06-04) [i586-mswin32]
       "C:"
       "."
       "."

    => ruby 1.7.1 (2001-08-16) [i586-mswin32]
       "C:"
       "C:"
       "."

    => ruby 1.8.0 (2003-01-06) [i386-mswin32]
       "C:/"
       "C:\\"
       "C:."

: File.basename

  パスセパレータとして従来の/に加えて\も認識するようになっています。
  これに合わせて、マルチバイトで記述されたパス名への対応も行われています。

    p File.basename("C:\\foo\\bar")

    => ruby 1.6.4 (2001-06-04) [i586-mswin32]
       "C:\\foo\\bar"

    => ruby 1.7.1 (2001-08-16) [i586-mswin32]
       "bar"

: File.split

  File.dirname と File.basename が変更されているので、File.split もそれに準じた
  結果を返します。

: File.expand_path

  ドライブレター対応に関して、下記のような案が提示されています。

    Dir.chdir("D:/")
    p File.expand_path("C:foo", "C:/bar")
    p File.expand_path("D:foo", "C:/bar")

    => ruby 1.6.4 (2001-06-04) [i586-mswin32]
       "C:/bar/C:foo"
       "C:/bar/D:foo"

    => ruby 1.8.0 (2003-01-06) [i386-mswin32]
       "C:/bar/foo"
       "D:/foo"

    => 新井案 [[ruby-list:30970]]
       "C:/bar/foo"
       (なんらかの例外)

: File.join

  ドライブレター対応に関して、下記のような案が提示されています。

    p File.join("c:", "foo")
    p File.join("c:/", "foo")
    p File.join("c:.", "foo")
    p File.join("c:", "/foo")

    => ruby 1.6.4 (2001-06-04) [i586-mswin32]
       "c:/foo"
       "c://foo"
       "c:./foo"
       "c://foo"

    => ruby 1.8.0 (2003-01-06) [i386-mswin32]
       "c:/foo"
       "c:/foo"
       "c:./foo"
       "c://foo"

    => 新井案 [[ruby-list:31185]]
       "c:./foo"
       "c:/foo"
       "c:./foo"
       "c:./foo"

: File.fnmatch
: Dir.glob
: Dir[]
