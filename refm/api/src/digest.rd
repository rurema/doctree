メッセージダイジェストライブラリ。
基本的な使い方はどのアルゴリズムでも同じです。
[[c:Digest::Base]]を参照。

すべてのメッセージダイジェストの実装クラスは基底クラスである
Digest::Base と同じインタフェースを持つ。



= class Digest::Base < Object

すべての Digest::XXX クラスの基底クラス。

例えば、MD5 値を得るには以下のようにする。

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

すべての Digest::XXX クラスは以下の共通インタフェースを持つ。

== Class Methods

--- new([str])

新しいダイジェストオブジェクトを生成する。文字列引数が与えられると
それを追加する([[m:Digest::Base#update]] 参照)。

--- digest(str)

与えられた文字列に対するハッシュ値を文字列で返す。
new(str).digest と等価。

--- hexdigest(str)

与えられた文字列に対するハッシュ値を、ASCIIコードを使って
16進数の列を示す文字列にエンコードして返す。
new(str).hexdigest と等価。

== Instance Methods

--- dup
--- clone

ダイジェストオブジェクトの複製を作る。

--- digest

今までに追加した文字列に対するハッシュ値を文字列で返す。MD5では
16バイト長、SHA1およびRMD160では20バイト長、SHA256では32バイト長、
SHA384では48バイト長、SHA512では64バイト長となる。

--- hexdigest
--- to_s

今までに追加した文字列に対するハッシュ値を、ASCIIコードを使って
16進数の列を示す文字列にエンコードして返す。MD5では32バイト長、
SHA1およびRMD160では40バイト長、SHA256では64バイト長、SHA384では
96バイト長、SHA512では128バイト長となる。Rubyで書くと以下と同じ。

        def hexdigest
          digest.unpack("H*")[0]
        end

--- update(str)
--- <<(str)

文字列を追加する。複数回updateを呼ぶことは文字列を連結して
updateを呼ぶことと等しい。すなわち m.update(a); m.update(b) は
m.update(a + b) と、 m << a << b は m << a + b とそれぞれ等価
である。

self を返す。

--- ==(md)

与えられたダイジェストオブジェクトと比較する。

--- ==(str)

与えられた文字列を digest 値、もしくは hexdigest 値と比較する。
いずれの値と見るかは与えられた文字列の長さによって自動判別
される。
