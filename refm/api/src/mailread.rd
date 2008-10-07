Unix mbox 形式のメールファイルを解析するライブラリです。

= class Mail < Object 

Unix mbox 形式のメールファイルを解析するライブラリです。

=== mailread の使い方

  require 'mailread'
  
  m = Mail.new('/var/mail/foo')
  puts 'From: ' + m['From'],
       'Subject: ' + m['Subject'],
       '--',
       m.body[0,5]

== Class Methods

--- new(file)

メールを解析します。
file にはファイル名か [[c:IO]] オブジェクトを渡します。
このメソッドを実行した時点でヘッダと本文が切り分けられ、
ヘッダのハッシュ(ヘッダフィールド単位)と本文の配列(行単位)が作られます。

@param file ファイル名か [[c:IO]] オブジェクトを指定します。

1ファイル複数メールの形式(Unix mbox 形式)に対応しています
(この場合 open 済みの IO を渡す必要があることに注意)。
例えば以下のようにして各メールの Subject を表示できます。

例:

  require 'mailread'
  require 'nkf'
  
  mailbox = File.open('/var/mail/foo')
  until (m = Mail.new(mailbox)).header.empty?
    puts NKF.nkf('-me', m['subject'])
  end

== Instance Methods

--- header -> Hash

ヘッダを [[c:Hash]] で返します。

キーは 'From'、'Subject' などのフィールド名で、すべてのキーは
[[m:String#capitalize]] されています。

値の末尾の改行は削除されます。
複数行に分かれている場合、間に改行をはさみます(継続行を表す空白は削除されます)。
MIME encoded-word のデコードなどを行いたい場合は [[lib:nkf]] などを使用してください。

--- body -> [ String ]

本文の各行を要素とする [[c:Array]] を返します。

--- [](field) -> String | nil

ヘッダの field の値を返します。
m.header[field.capitalize] と同じですので値取得の際は、
フィールド名のアルファベットの大小を気にする必要はありません。

@param field 取得したいメールのヘッダフィールド名
