category Text

#@since 1.8.6
require digest/md5
require digest/rmd160
require digest/sha1
require digest/sha2
#@end

メッセージダイジェストライブラリです。

[[c:Digest::MD5]] や [[c:Digest::SHA1]] などの
全てのメッセージダイジェストの実装クラスは、
基底クラスである [[c:Digest::Base]] と同じインタフェースを持ちます。
基本的な使い方は、MD5やSHA1など、どのアルゴリズムでも同じです。
詳しくは [[c:Digest::Base]] を参照してください。

なお、「メッセージダイジェスト」とは、
データから固定長の疑似乱数を生成する演算手法のことです。

= module Digest

#@since 1.8.6
== Module Functions

--- hexencode(string) -> String

与えられた文字列に対するハッシュ値を、
ASCIIコードを使って16進数の列を示す文字列にエンコードして返します。

@param string ハッシュ値の生成対象の文字列です。

使用例(MD5の場合)

        require 'digest/md5'
        Digest::MD5.hexdigest("ruby") # => "58e53d1324eef6265fdb97b08ed9aadf"

@see [[m:Digest::Base#hexdigest]]

#@end

#@if(version >= "1.8.6")
= class Digest::Class < Object

= module Digest::Instance

= class Digest::Base < Digest::Class
include Digest::Instance

#@else
= class Digest::Base < Object

#@end

すべての Digest::XXX クラスの基底クラスです。

例えば、MD5 値を得るには以下のようにします。
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

すべての Digest::XXX クラスは以下の共通インタフェースを持ちます。

== Class Methods

#@until 1.8.6
--- new(str = nil) -> Digest::Base

新しいダイジェストオブジェクトを生成します。文字列引数が与えられると
それを追加します([[m:Digest::Base#update]] 参照)。
#@else
--- new            -> Digest::Base
新しいダイジェストオブジェクトを生成します。
#@end

--- digest(str) -> String

与えられた文字列に対するハッシュ値を文字列で返します。
new(str).digest と等価です。

--- hexdigest(str) -> String

与えられた文字列に対するハッシュ値を、ASCIIコードを使って
16進数の列を示す文字列にエンコードして返します。
new(str).hexdigest と等価です。

#@since 1.8.6
--- file(path) -> object

新しいダイジェストオブジェクトを生成し、
ファイル名 file で指定したファイルの内容を読み込み、
そのダイジェストオブジェクトを返します。

@param path 読み込み対象のファイル名です。
@return ダイジェストオブジェクトを返します。

使用例(SHA256の場合)

        digest = Digest::SHA256.file("X11R6.8.2-src.tar.bz2")
        digest.hexdigest
        # => "f02e3c85572dc9ad7cb77c2a638e3be24cc1b5bea9fdbb0b0299c9668475c534"
#@end

== Instance Methods

--- dup   -> Digest::Base
--- clone -> Digest::Base

ダイジェストオブジェクトの複製を作ります。

--- digest -> String

updateや<<によって追加した文字列に対するハッシュ値を文字列で返します。

返す文字列は、MD5では16バイト長、SHA1およびRMD160では20バイト長、
SHA256では32バイト長、SHA384では48バイト長、SHA512では64バイト長です。

例:

  # MD5の場合
  require 'digest/md5'
  digest = Digest::MD5.new
  digest.update("ruby")
  p digest.digest # => "X\345=\023$\356\366&_\333\227\260\216\331\252\337"

@see [[m:Digest::Base#hexdigest]]

#@since 1.8.6
--- digest! -> String

updateや<<によって追加した文字列に対するハッシュ値を文字列で返します。
[[m:Digest::Base#digest]]と違い、
メソッドの処理後、
オブジェクトの状態を初期状態(newした直後と同様の状態)に戻します。

返す文字列は、MD5では16バイト長、SHA1およびRMD160では20バイト長、
SHA256では32バイト長、SHA384では48バイト長、SHA512では64バイト長です。

例:

  # MD5の場合
  require 'digest/md5'
  digest = Digest::MD5.new
  digest.update("ruby")
  p digest.digest! # => "X\345=\023$\356\366&_\333\227\260\216\331\252\337"
  p digest.digest! # => "\324\035\214\331\217\000\262\004\351\200\t\230\354\370B~"

@see [[m:Digest::Base#digest]]、[[m:Digest::Base#hexdigest!]]

#@end

--- hexdigest -> String
--- to_s -> String

updateや<<によって追加した文字列に対するハッシュ値を、
ASCIIコードを使って16進数の列を示す文字列にエンコードして返します。

返す文字列は、
MD5では32バイト長、SHA1およびRMD160では40バイト長、SHA256では64バイト長、
SHA384では96バイト長、SHA512では128バイト長です。

Rubyで書くと以下と同じです。

  def hexdigest
    digest.unpack("H*")[0]
  end

例:

  # MD5の場合
  require 'digest/md5'
  digest = Digest::MD5.new
  digest.update("ruby")
  p digest.hexdigest # => "58e53d1324eef6265fdb97b08ed9aadf"

@see [[m:Digest::Base#digest]]

#@since 1.8.6
--- hexdigest! -> String

updateや<<によって追加した文字列に対するハッシュ値を、
ASCIIコードを使って16進数の列を示す文字列にエンコードして返します。
[[m:Digest::Base#hexdigest]]と違い、
メソッドの処理後、
オブジェクトの状態を初期状態(newした直後と同様の状態)に戻します。

例:

  # MD5の場合
  require 'digest/md5'
  digest = Digest::MD5.new
  digest.update("ruby")
  p digest.hexdigest! # => "58e53d1324eef6265fdb97b08ed9aadf"
  p digest.hexdigest! # => "d41d8cd98f00b204e9800998ecf8427e"

@see [[m:Digest::Base#hexdigest]]、[[m:Digest::Base#digest!]]

#@end

--- update(str) -> self
--- <<(str)     -> self

文字列を追加します。self を返します。
複数回updateを呼ぶことは文字列を連結してupdateを呼ぶことと同じです。
すなわち m.update(a); m.update(b) は
m.update(a + b) と、 m << a << b は m << a + b とそれぞれ等価
です。

@param str 追加する文字列

        require 'digest/md5'

        digest = Digest::MD5.new
        digest.update("r")
        digest.update("u")
        digest.update("b")
        digest.update("y")
        p digest.hexdigest # => "58e53d1324eef6265fdb97b08ed9aadf"

        digest = Digest::MD5.new
        digest << "r"
        digest << "u"
        digest << "b"
        digest << "y"
        p digest.hexdigest # => "58e53d1324eef6265fdb97b08ed9aadf"

--- ==(md)  -> bool

与えられたダイジェストオブジェクトと比較します。

@param md 比較対象のダイジェストオブジェクト

        require 'digest/md5'
        digest1 = Digest::MD5.new
        digest1.update("ruby")
        digest2 = Digest::MD5.new
        digest2.update("ruby")
        p digest1 == digest2 # => true
        digest2.update("RUBY")
        p digest1 == digest2 # => false

--- ==(str) -> bool

#@if(version >= "1.8.6")
与えられた文字列を hexdigest 値と見て、自身の hexdigest 値と比較します。

@param str 比較対象の hexdigest 文字列
#@else
与えられた文字列を digest 値、もしくは hexdigest 値と比較します。
いずれの値と見るかは与えられた文字列の長さによって自動判別
されます。

@param str 比較対象の(ダイジェストの)文字列です。
#@end

        require 'digest/md5'
        digest = Digest::MD5.new
        digest.update("ruby")
        p digest == "58e53d1324eef6265fdb97b08ed9aadf" # => true

#@since 1.8.6
--- file(path) -> self

ファイル名 file で指定したファイルの内容を読み込んでダイジェストを更新し、
オブジェクト自身を返します。

@param path 読み込み対象のファイル名です。
@return ダイジェストオブジェクトを返します。

例(MD5の場合)

  require 'digest/md5'
  digest = Digest::MD5.new
  digest.file("/path/to/file") # => Digest::MD5のインスタンス
  digest.hexdigest # => "/path/to/file"のMD5値

--- block_length -> Integer

ダイジェストのブロック長を取得します。
例えば、Digest::MD5であれば64、Digest::SHA512であれば128です。

本メソッドは、Digest::MD5などのダイジェストのサブクラスにより、
それぞれの実装に適したものにオーバーライドされます。

例: Digest::MD、Digest::SHA1、Digest::SHA512のブロック長を順番に調べる。

  ["MD5", "SHA1", "SHA512"].map{|a| Digest(a).new().block_length } # => [64, 128, 128]

--- digest_length -> Integer
--- length -> Integer
--- size -> Integer

ダイジェストのハッシュ値のバイト長を取得します。
例えば、Digest::MD5であれば16、Digest::SHA1であれば20です。

本メソッドは、Digest::MD5などのダイジェストのサブクラスにより、
それぞれの実装に適したものにオーバーライドされます。

例: Digest::MD、Digest::SHA1、Digest::SHA512のハッシュ値のバイト長を順番に調べる。

  ["MD5", "SHA1", "SHA512"].map{|a| Digest(a).new().digest_length } # => [16, 20, 64]

#@end

--- reset -> self

オブジェクトの状態を初期状態(newした直後と同様の状態)に戻し、
オブジェクト自身を返します。

本メソッドは、Digest::MD5などのダイジェストのサブクラスにより、
それぞれの実装に適したものにオーバーライドされます。

#@since 1.8.6
= reopen Kernel
== Private Instance Methods
--- Digest(name) -> object

"MD5"や"SHA1"などのダイジェストを示す文字列 name を指定し、
対応するダイジェストのクラスを取得します。

#@since 2.2.0
このメソッドはスレッドセーフです。マルチスレッド環境で
[[c:Digest::MD5]]などを直接呼び出すと問題があるときはこのメソッドを使
うか、起動時に使用するライブラリを [[m:Kernel.#require]] してください。
#@end

@param name "MD5"や"SHA1"などのダイジェストを示す文字列を指定します。
@return Digest::MD5やDigest::SHA1などの対応するダイジェストのクラスを返します。インスタンスではなく、クラスを返します。注意してください。

例: Digest::MD、Digest::SHA1、Digest::SHA512のクラス名を順番に出力する。

  for a in ["MD5", "SHA1", "SHA512"]
    p Digest(a) # => Digest::MD5, Digest::SHA1, Digest::SHA512
  end

#@end
