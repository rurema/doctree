#@since 1.8.6
digest/md5
digest/rmd160
digest/sha1
digest/sha2
#@end

メッセージダイジェストライブラリ。
基本的な使い方はどのアルゴリズムでも同じです。
[[c:Digest::Base]]を参照。

すべてのメッセージダイジェストの実装クラスは基底クラスである
Digest::Base と同じインタフェースを持つ。

= module Digest

#@since 1.8.6
== Module Functions

--- hexencode(string)
#@todo

Generates a hex-encoded version of a given string. 
#@end

#@if(version >= "1.8.6")
= class Digest::Class < Object

= module Digest::Instance

= class Digest::Base < Digest::Class
include Digest::Instance

#@else
= class Digest::Base < Object

#@end

すべての Digest::XXX クラスの基底クラス。

例えば、MD5 値を得るには以下のようにする。
#@if(version >= "1.8.6")
  require 'digest/md5'

  p Digest::MD5.hexdigest('abc')               #=> '900150983cd24fb0d6963f7d28e17f72'
  p Digest::MD5.file('ruby-1.8.5.tar.gz').to_s #=> '3fbb02294a8ca33d4684055adba5ed6f'
#@else
        require 'digest/md5'
        p Digest::MD5.hexdigest(File.open('ruby-1.8.5.tar.gz','rb').read)

        # => "3fbb02294a8ca33d4684055adba5ed6f"

あるいは(大きな文字列を生成しない方法)

        require 'digest/md5'

        class Digest::Base
          def self.open(path)
            obj = new

            File.open(path, 'rb') {|f|
              buf = ""
              while f.read(256, buf)
                obj << buf
              end
            }
            obj
          end
        end

        p Digest::MD5.open("ruby-1.8.5.tar.gz").hexdigest

        # => "3fbb02294a8ca33d4684055adba5ed6f"
#@end

すべての Digest::XXX クラスは以下の共通インタフェースを持つ。

== Class Methods

#@if(version < "1.8.6")
--- new([str])

新しいダイジェストオブジェクトを生成する。文字列引数が与えられると
それを追加する([[m:Digest::Base#update]] 参照)。
#@else
--- new
新しいダイジェストオブジェクトを生成する。
#@end

--- digest(str)

与えられた文字列に対するハッシュ値を文字列で返す。
new(str).digest と等価。

--- hexdigest(str)

与えられた文字列に対するハッシュ値を、ASCIIコードを使って
16進数の列を示す文字列にエンコードして返す。
new(str).hexdigest と等価。

#@since 1.8.6
--- file(file)
#@todo
creates a digest object and reads a given file, name.

  p Digest::SHA256.file("X11R6.8.2-src.tar.bz2").hexdigest
  # => "f02e3c85572dc9ad7cb77c2a638e3be24cc1b5bea9fdbb0b0299c9668475c534"
#@end

== Instance Methods

--- dup
--- clone

ダイジェストオブジェクトの複製を作る。

--- digest

newの引数で与えた文字列や、
updateや<<によって追加した文字列に対するハッシュ値を文字列で返す。
MD5では16バイト長、SHA1およびRMD160では20バイト長、SHA256では32バイト長、
SHA384では48バイト長、SHA512では64バイト長となる。

使用例

        require 'digest/md5'
        digest = Digest::MD5.new("ruby")
        p digest.digest # => "X\345=\023$\356\366&_\333\227\260\216\331\252\337"

[[m:Digest::Base#hexdigest]]、[[c:Digest::Base.new]]、
[[m:Digest::Base#update]]、[[m:Digest::Base#<<]]を参照。

#@since 1.8.6
--- digest!
#@todo

Returns the resulting hash value and resets the digest to the initial state. 
#@end

--- hexdigest
--- to_s

newの引数で与えた文字列や、
updateや<<によって追加した文字列に対するハッシュ値を、
ASCIIコードを使って16進数の列を示す文字列にエンコードして返す。
MD5では32バイト長、SHA1およびRMD160では40バイト長、SHA256では64バイト長、
SHA384では96バイト長、SHA512では128バイト長となる。
Rubyで書くと以下と同じ。

        def hexdigest
          digest.unpack("H*")[0]
        end

使用例(MD5の場合)

        require 'digest/md5'
        digest = Digest::MD5.new("ruby")
        p digest.hexdigest # => "58e53d1324eef6265fdb97b08ed9aadf"

[[m:Digest::Base#digest]]、[[c:Digest::Base.new]]、
[[m:Digest::Base#update]]、[[m:Digest::Base#<<]]を参照。

#@since 1.8.6
--- hexdigest!
#@todo
Returns the resulting hash value and resets the digest to the
initial state.
#@end

--- update(str)
--- <<(str)

文字列を追加する。self を返す。
複数回updateを呼ぶことは文字列を連結してupdateを呼ぶことと等しい。
すなわち m.update(a); m.update(b) は
m.update(a + b) と、 m << a << b は m << a + b とそれぞれ等価
である。

@param str 追加する文字列

        require 'digest/md5'
        digest = Digest::MD5.new
        digest.update("r")
        digest.update("u")
        digest.update("b")
        digest.update("y")
        p digest.hexdigest # => "58e53d1324eef6265fdb97b08ed9aadf"

--- ==(md)

与えられたダイジェストオブジェクトと比較する。

--- ==(str)

与えられた文字列を digest 値、もしくは hexdigest 値と比較する。
いずれの値と見るかは与えられた文字列の長さによって自動判別
される。

#@since 1.8.6
--- file 
#@todo
updates the digest with the contents of a given file _name_ and
returns self.

--- block_length
#@todo

Returns the block length of the digest.

This method is overridden by each implementation subclass. 

--- digest_length 
--- length 
--- size
#@todo

Returns the length of the hash value of the digest.

This method should be overridden by each implementation subclass.
If not, digest_obj.digest().length() is returned. 
#@end

--- reset
#@todo
Resets the digest to the initial state and returns self.

This method is overridden by each implementation subclass.

#@since 1.8.6
= reopen Kernel
== Private Instance Methods
--- Digest(name)
#@todo
#@end
