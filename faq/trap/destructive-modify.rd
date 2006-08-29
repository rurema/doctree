= 破壊的メソッド

* 変更しなかったときにnilを返す。
    'a'.sub!(/a/,'b') #=> "b"
    'b'.sub!(/a/,'b') #=> nil

* 破壊的メソッドの定義

    class String
      def sample!
        self.replace('sample')
    #    self = 'sample' # これは誤り
      end
    end
