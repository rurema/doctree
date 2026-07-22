---
type: library
category: Network
---
このライブラリは、POP3 (Post Office Protocol version 3) を
用いてPOPサーバからメールを受信する機能を提供するライブラリです。

POP3 の実装は [RFC:1939] に基いています。

[RFC:2449] で定義されているPOP3拡張には対応していません。

### 使用例

#### メールの受信

以下のコードは、メールを受信してファイル 'inbox/1' 'inbox/2'... に
書きこみ、サーバ上からメールを消します。

'pop.example.com' は適当なPOP3のサーバのホスト名に、
'YourAccount' と 'YourPassword' は適当なアカウント名とパスワード
に適宜読みかえてください。

```ruby
require 'net/pop'
  
pop = Net::POP3.new('pop.example.com', 110)
pop.start('YourAccount', 'YourPassword') # POPのセッションを開始
if pop.mails.empty?
  $stderr.puts 'no mail.'
else
  pop.mails.each_with_index do |m, idx|  # 各メッセージにアクセスする
    File.open("inbox/#{idx + 1}", 'w') {|f|
      f.write m.pop
    }
    m.delete
  end
  $stderr.puts "#{pop.mails.size} mails popped."
end
pop.finish                                        # セッションを終了する
```

POP サーバはネットワークのむこうに存在するので、
なにか仕事をさせるにはその前に開始手続きを、
終わったら終了手続きを、行わなければいけません。
それを行うのが [m:Net::POP3#start] と [m:Net::POP3#finish] で、
POP3 オブジェクトはその二つのメソッドの間でだけ有効になります。

サーバ上のメールは [c:Net::POPMail] オブジェクトとして表現されており、この
オブジェクトのメソッドを呼ぶことでメールを取ってきたり消したりできます。[m:Net::POP3#mails] はこの [c:Net::POPMail] オブジェクトの配列であり、
[m:Net::POP3#each_mail] はさらに pop.mails.each のショートカットです。

#### 短くする

上の例はあえて省略や短縮用メソッドを避けたためにかなり冗長です。
まず、ブロック付きの [m:Net::POP3.start] を使うことで
POP3.new, #start, #finish を併合できます。

```ruby
require 'net/pop'
  
Net::POP3.start('pop.example.com', 110,
                'YourAccount', 'YourPassword') {|pop|
  if pop.mails.empty?
    $stderr.puts 'no mail.'
  else
    pop.mails.each_with_index do |m, idx|
      File.open("inbox/#{idx + 1}", 'w') {|f|
        f.write m.pop
      }
      m.delete
    end
    $stderr.puts "#{pop.mails.size} mails popped."
  end
}
```

[m:Net::POP3#delete_all] を使うと
さらに [m:Net::POP3#each_mail] と
[m:Net::POPMail#delete] を併合できます。

```ruby
require 'net/pop'
  
Net::POP3.start('pop.example.com', 110,
                'YourAccount', 'YourPassword') {|pop|
  if pop.mails.empty?
    $stderr.puts 'no mail.'
  else
    i = 0
    pop.delete_all do |m|
      File.open("inbox/#{i}", 'w') {|f|
        f.write m.pop
      }
      i += 1
    end
  end
}
```

クラスメソッドの [m:Net::POP3.delete_all] を使うとさらに短くなります。

```ruby
require 'net/pop'
  
i = 0
Net::POP3.delete_all('pop.example.com', 110,
                     'YourAccount', 'YourPassword') do |m|
  File.open("inbox/#{i}", 'w') {|f|
    f.write m.pop
  }
  i += 1
end
```

#### メモリ使用量を減らす

これまでの例では [m:Net::POPMail#pop] を使い、
メールをひとつの文字列としてうけとっていました。
しかし、もしメールが 100MB を越えるような巨大なメールだった場合、
この方法ではまずいかもしれません。
そのような場合は以下のように [m:Net::POPMail#pop] に
File オブジェクトを与える手が使えます。

```ruby
require 'net/pop'
  
i = 0
Net::POP3.delete_all('pop.example.com', 110,
                     'YourAccount', 'YourPassword') do |m|
  File.open('inbox/#{i}', 'w') {|f|
      m.pop f
  }
  i += 1
end
```

[m:Net::POPMail#pop]にブロックを渡すと、
メールデータを細かく分割してブロックを呼びだします。
この機能を使って同様のことができます。

```ruby
require 'net/pop'
  
i = 0
Net::POP3.delete_all('pop.example.com', 110,
                     'YourAccount', 'YourPassword') do |m|
  File.open('inbox/#{i}', 'w') {|f|
    m.pop {|chunk|
      f.write(chunk)
    }
  }
  i += 1
end
```

#### APOP を使う

Net::POP3 クラスのかわりに Net::APOP クラスを使うと、
認証時に APOP を使うようになります。
また動的にノーマル POP と APOP を選択するには、
以下のように [m:Net::POP3.APOP] メソッドを使うのが便利です。

```ruby
require 'net/pop'
  
# use APOP authentication if $isapop == true
pop = Net::POP3.APOP($isapop).new('apop.example.com', 110)
pop.start('YourAccount', 'YourPassword') {|pop|
  # 残りのコードは同じ
}
```

この方法はクラス自体を変えるので、クラスメソッドの start や foreach、
delete_all、auth_only なども APOP とともに使えます。

#### UIDL コマンドを使って特定のメールだけを取り出す

利用しているPOP3サーバが UIDL 機能を提供している場合には、
以下のようにして特定のメールだけを取り出すことができます。

```ruby
require 'net/pop'

def need_pop?(id)
  # 取り出したいメールの場合に真を返す
end
  
Net::POP3.start('pop.example.com', 110,
                'Your account', 'Your password') do |pop|
  pop.mails.select { |m| need_pop?(m.unique_id) }.each do |m|
    do_something(m.pop)
  end
end
```

[m:Net::POPMail#unique_id] はメッセージのユニークIDを文字列で返します。
これは通常そのメッセージのハッシュ値です。

#### SSL/TLS による暗号化

このライブラリは pop3s と呼ばれる、995番ポートを使いPOP3の通信全体を
SSLで包む方法での通信の認証および暗号化が可能です。
この方法は標準化されていません。

[RFC:2595] で定義されている STLS 拡張による TLS の利用はできません。

[m:Net::POP3#enable_ssl] でそのオブジェクトが SSL を利用するように
設定します。

また、[m:Net::POP3.enable_ssl] で以降生成されるすべての
[c:Net::POP3] オブジェクトで SSL を利用するように設定できます。
グローバルに状態を変更するのであまり利用しないほうがよいでしょう。

