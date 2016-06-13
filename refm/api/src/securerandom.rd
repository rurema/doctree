安全な乱数発生器のためのインターフェースを提供するライブラリです。
HTTP のセッションキーなどに適しています。

= module SecureRandom

安全な乱数発生器のためのインターフェースを提供するモジュールです。
HTTP のセッションキーなどに適しています。

以下の乱数発生器をサポートしています。

  * openssl
  * /dev/urandom

上の安全な乱数発生器が使用できない場合、各メソッドは NotImplementedError を発生します。
  
  # random hexadecimal string. 
  p SecureRandom.hex(10) #=> "52750b30ffbc7de3b362" 
  p SecureRandom.hex(10) #=> "92b15d6c8dc4beb5f559" 
  p SecureRandom.hex(11) #=> "6aca1b5c58e4863e6b81b8" 
  p SecureRandom.hex(12) #=> "94b2fff3e7fd9b9c391a2306" 
  p SecureRandom.hex(13) #=> "39b290146bea6ce975c37cfc23" 
  
  # random base64 string. 
  p SecureRandom.base64(10) #=> "EcmTPZwWRAozdA==" 
  p SecureRandom.base64(10) #=> "9b0nsevdwNuM/w==" 
  p SecureRandom.base64(10) #=> "KO1nIU+p9DKxGg==" 
  p SecureRandom.base64(11) #=> "l7XEiFja+8EKEtY=" 
  p SecureRandom.base64(12) #=> "7kJSM/MzBJI+75j8" 
  p SecureRandom.base64(13) #=> "vKLJ0tXBHqQOuIcSIg==" 
  
  # random binary string. 
  p SecureRandom.random_bytes(10) #=> "\016\t{\370g\310pbr\301" 
  p SecureRandom.random_bytes(10) #=> "\323U\030TO\234\357\020\a\337" 

== Singleton Methods

--- base64(n = nil)    -> String

ランダムな base64 文字列を生成して返します。

@param n 文字列の生成に使われるランダムネスのサイズを整数で指定します。
         生成される文字列のサイズではないことに注意して下さい。生成される文字列のサイズは
         n の約 4/3 倍になります。nil を指定した場合 n として 16 が使われます。

@raise NotImplementedError 安全な乱数発生器が使えない場合に発生します。

  p SecureRandom.base64(3)    #=> "4pYO"  (文字列のサイズは 3 でない)

@see [[rfc:3548]]

#@since 1.9.2
--- urlsafe_base64(n = nil, padding = false)  -> String

ランダムで URL-safe な base64 文字列を生成して返します。

@param n 文字列の生成に使われるランダムネスのサイズを整数で指定します。
         生成される文字列のサイズはn の約 4/3 倍になります。
         nil を指定した場合 n として 16 が使われます。

@param padding 真を指定すると '=' でパディングを行います。
               偽を指定するとパディングを行いません。デフォルトは偽です。

@raise NotImplementedError  安全な乱数発生器が使えない場合に発生します。

   p SecureRandom.urlsafe_base64 #=> "b4GOKm4pOYU_-BOXcrUGDg"
   p SecureRandom.urlsafe_base64 #=> "UZLdOkzop70Ddx-IJR0ABg"
   p SecureRandom.urlsafe_base64(nil, true) #=> "i0XQ-7gglIsHGV2_BNPrdQ=="
   p SecureRandom.urlsafe_base64(nil, true) #=> "-M8rLhr7JEpJlqFGUMmOxg=="

@see [[m:SecureRandom.base64]],  [[rfc:3548]]
#@end
--- hex(n = nil)    -> String

ランダムな hex 文字列を生成して返します。

@param n 文字列の生成に使われるランダムネスのサイズを整数で指定します。
         生成される文字列のサイズではないことに注意して下さい。生成される文字列のサイズは
         n の 2 倍になります。nil を指定した場合 n として 16 が使われます。

@raise NotImplementedError 安全な乱数発生器が使えない場合に発生します。

  p SecureRandom.hex(3)    #=> "f72233"   (文字列のサイズは 3 でない)


--- random_bytes(n = nil)    -> String

ランダムなバイト列を生成して返します。

@param n 生成される文字列のサイズを整数で指定します。
         nil を指定した場合 n として 16 が使われます。

@raise NotImplementedError 安全な乱数発生器が使えない場合に発生します。

  p SecureRandom.random_bytes(3)    #=> "\321\020\203"

--- random_number(n = 0)     -> Integer | Float

ランダムな数値を生成して返します。
n が 1 以上の整数の場合、0 以上 n 未満の整数を返します。
n が 0 の場合、0.0 以上 1.0 未満の実数を返します。

@param n ランダムな数値の上限を数値で指定します。

@raise NotImplementedError 安全な乱数発生器が使えない場合に発生します。

  p SecureRandom.random_number(1 << 64)    #=> 4078466195356651249

#@since 1.9.2
--- uuid   -> String

バージョン 4 の UUID (Universally Unique IDentifier) を生成して返します。

version 4 の UUID は全くランダムです (バージョンを除いて)。
この UUID は MAC アドレスや時刻などのような意味のある情報を含みません。

@raise NotImplementedError 安全な乱数発生器が使えない場合に発生します。

   p SecureRandom.uuid #=> "2d931510-d99f-494a-8c67-87feb05e1594"
   p SecureRandom.uuid #=> "62936e70-1815-439b-bf89-8492855a7e6b"

@see [[rfc:4122]]
#@end

