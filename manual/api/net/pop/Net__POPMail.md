---
library: net/pop
---
# class Net::POPMail < Object

POP サーバー上のメール一通を表現するクラス。

メールの取得や消去といった操作をカプセル化します。
[c:Net::POP3] クラスが生成するもので、ユーザが直接は生成しません。

## Instance Methods

### def pop -> String
### def all -> String
### def mail -> String
### def pop {|str| .... } -> nil
### def all {|str| .... } -> nil
### def mail {|str| .... } -> nil
### def pop(io) -> object
### def all(io) -> object
### def mail(io) -> object

メールを受信します。

引数もブロックも与えられなかった場合にはメール
の内容を文字列で返します。

ブロックが渡されたときは、メールの内容を
少しずつ読み込み、読みこんだ文字列を
引数としてブロックを呼びだします。

ブロックなしで、オブジェクトを
引数として渡すとそのオブジェクトに
メールの内容を << メソッドで順次書き込みます。
通常 [c:IO] オブジェクトを渡します。
この場合引数として渡したオブジェクトを返します。

pop, all, mail はすべて同じ効果ですが、
all と mail は obsolete です。


```ruby title="使用例"
require 'net/pop'

Net::POP3.start('pop.example.com', 110,
                'YourAccount', 'YourPassword') {|pop|
  pop.mails.each do |m|
    puts m.pop
  end
}
```


```ruby title="ブロックを利用する例"
require 'net/pop'

Net::POP3.start('pop.example.com', 110) {|pop|
  pop.each_mail do |m|
    m.pop do |str|
      print str
    end
  end
}
```

- **param** `io` -- メールの内容を書きこむオブジェクト
- **raise** `TimeoutError` -- 通信がタイムアウトした場合に発生します
- **raise** `Net::POPError` -- サーバが認証失敗以外のエラーを報告した場合に発生します
- **raise** `Net::POPBadResponse` -- サーバからの応答がプロトコル上不正であった場合に発生します

### def header(dest='') -> String
メールヘッダを受信し、文字列として返します。

destを渡すとそのオブジェクトにデータを書き込みますが、これは
obsolete なので使わないでください。

- **param** `dest` -- ヘッダを書き込む先(obsoleteなので使わないでください)
- **raise** `TimeoutError` -- 通信がタイムアウトした場合に発生します
- **raise** `Net::POPError` -- サーバが認証失敗以外のエラーを報告した場合に発生します
- **raise** `Net::POPBadResponse` -- サーバからの応答がプロトコル上不正であった場合に発生します

### def top(lines, dest='') -> String
メールヘッダと本文 lines 行を受信し、文字列として返します。

destを渡すとそのオブジェクトにデータを書き込みますが、これは
obsolete なので使わないでください。

- **param** `lines` -- 本文を読みだす行数
- **param** `dest` -- データを書き込む先(obsoleteなので使わないでください)
- **raise** `TimeoutError` -- 通信がタイムアウトした場合に発生します
- **raise** `Net::POPError` -- サーバが認証失敗以外のエラーを報告した場合に発生します
- **raise** `Net::POPBadResponse` -- サーバからの応答がプロトコル上不正であった場合に発生します


### def delete -> ()
### def delete! -> ()
メールに削除マークを付けます。

削除マークを付けたメールは読み出せなくなります。
セッション終了時に実際に削除されます。
[m:Net::POP3#reset] を呼ぶと削除マークは取り消されます。

delete! は obsolete です。

- **raise** `TimeoutError` -- 通信がタイムアウトした場合に発生します
- **raise** `Net::POPError` -- サーバが認証失敗以外のエラーを報告した場合に発生します
- **raise** `Net::POPBadResponse` -- サーバからの応答がプロトコル上不正であった場合に発生します
- **SEE** [m:Net::POPMail#deleted?]
### def deleted? -> bool
メールに削除マークが付けられている場合に真を返します。

- **SEE** [m:Net::POPMail#delete]

### def size -> Integer
### def length -> Integer
メールのサイズ (単位はバイト) をかえします。

### def number -> Integer
メールに対して振られた、そのメールボックスで一意な番号を返します。

サーバに接続しなおすとこの番号は変化する場合があります。
メールごとに一意な識別子が必要なときは
[m:Net::POPMail#uidl] を使ってください。

### def uidl -> String
### def unique_id -> String
メールに対して振られた、サーバ上で一意な識別子 (UIDL) をかえします。

[m:Net::POPMail#number] と違い、
この UIDL は接続しなおしても変化しません。

#@# internal use
#@# --- uid=
