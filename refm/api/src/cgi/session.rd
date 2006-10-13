CGI のセッション管理を行うライブラリ。

セッションとは、HTTP の一連のリクエストとレスポンスが属するべき
コンテクスト (状況) のことをいいます。
セッション管理には従来通り [[lib:cgi]] ライブラリが提供する
クッキーを使用してもいいですが、
この cgi/session を使用した方がよりわかりやすいでしょう。
セッション情報は Hash ライクなインターフェースです。

セッションはセッション ID とプログラムが記録した
セッション情報から構成されます。
デフォルトでは CGI::Session::FileStore が使用され、
記録できるのは文字列のみです。

セッション情報は CGI::Session::FileStore か
CGI::Session::PStore を使用した場合は
サーバのローカルファイルに記録され、
次回のリクエスト時に利用されます。
デフォルトでは明示的に操作を行なわなくても
プログラム終了時にセッション情報はファイルに保存されます。
セッション毎に新しいファイルが作成されます。

クライアントにはセッション情報に対応するセッション ID を
クッキーあるいは form の hidden input として渡すことになります。
クッキーはデフォルトでは expires が指定されていないために、
ブラウザを終了した時点で消滅します。

=== 使い方 (生成)

  require 'cgi/session'
  cgi = CGI.new
  session = CGI::Session.new(cgi)

[[m:CGI::Session.new]] に [[c:CGI]] オブジェクトを渡します。クライアントから渡された
セッション ID はクッキーかクエリーとして cgi に格納されているため、意識する必要はありません。

=== 使い方 (セッション情報を記録する)

  session['name'] = "value"

CGI::Session オブジェクトは Hash のようなもので、キーに対応する値を記録します。
デフォルトではプログラム終了時にセッション情報はファイルに記録されます。

=== 使い方 (セッション情報を得る)

  name = session['name']

別な CGI でこのセッション情報を取り出すときは、このようにします。

=== 使い方 (ヘッダ出力)

ヘッダ出力は [[m:CGI#out]]、[[m:CGI#header]] を使っている限り
通常通りで構いません。
cgi/session は内部的にクッキーを使用していますが、
これらのメソッドが面倒を見てくれるので、意識をする必要はありません。

=== umask 値

umask 値が 0022 ならば
セッション情報ファイルのパーミッションが 644 になるので、
任意のユーザがそのセッション情報ファイルを見ることができます。
それが嫌な場合は CGI::Session オブジェクト生成前に umask 値を設定してください。

#@if (version >= "1.8.2")
セッション情報ファイルは 0600 で作成されるようになりました。
#@end

=== CGI::HtmlExtension#form の出力

[[m:CGI::Session.new]] 後の [[m:CGI::HtmlExtension#form]] は、セッション ID を埋め込んだ隠しフィールドを自動出力するようになります。CGI::Session.new は、これによって生成されたフォームフィールド値を、セッション ID として自動認識します。

CGI::HtmlExtension#form を使い、<INPUT TYPE="submit"> でページ遷移をするようにすれば、クッキーが使えない環境でのセッション維持に利用できます。

  #!/usr/bin/ruby
  require 'cgi'
  require 'cgi/session'

  cgi = CGI.new('html3')
  File.umask(0077)
  session = CGI::Session.new(cgi)
  cgi.out('charset'=>'euc-jp') {
    html = cgi.html {
      cgi.head { cgi.title {'Form Demo'} }
      cgi.body {
        cgi.form('action'=>"#{CGI.escapeHTML(cgi.script_name)}") {
          cgi.p {
            'あなたの名前は？' +
            cgi.text_field('name') +
            cgi.hidden('cmd', 'hello') +
            cgi.submit('です。')
          }
        }
      }
    }
    CGI.pretty(html)
  }
  #=>
  <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
  <HTML>
    <BODY>
      <FORM METHOD="post" ENCTYPE="application/x-www-form-urlencoded" action="/sample.rb">
        <P>
          あなたの名前は？
          <INPUT NAME="name" SIZE="40" TYPE="text">
          <INPUT NAME="cmd" TYPE="hidden" VALUE="hello">
          <INPUT TYPE="submit" VALUE="です。">
        </P>
        <INPUT TYPE="HIDDEN" NAME="_session_id" VALUE="bc315cc069266e21">    # これ
      </FORM>
    </BODY>
  </HTML>

=== 使用例

ただ名前を入力するとあいさつをするだけのつまらない CGI スクリプト。

ソースコード

  #!/usr/bin/ruby
  require 'kconv'
  require 'cgi'
  require 'cgi/session'
  
  class SessionDemo
    def initialize
      @cgi = CGI.new
      File.umask(0077)                                # セッションファイルは誰にも読まれたくないよ
      @session = CGI::Session.new(@cgi)               # セッションはこうして生成する。
      @cmd = "#{@cgi['cmd'].first}"                   # ruby 1.8 でも動くように(warning は出ます)
      @cmd = 'start' if @cmd.empty?
      @header = { "type" => "text/html", "charset" => "euc-jp" }
      
      __send__("cmd_#{@cmd}")
    end
    
    def cmd_start
      @cgi.out(@header) {
        <<-END
        <html><head><title>CGI::Session Demo</title></head>
        <body>
         <form action="#{CGI.escapeHTML(ENV['SCRIPT_NAME'])}" method="get">
         <p>
         あなたの名前は？
         <input type="text" name="name">
         <input type="hidden" name="cmd" value="hello">
         <input type="submit" value="です。">
         </p>
         </form>
        </body></html>
        END
      }
    end
    
    def cmd_hello
      name = Kconv.toeuc(@cgi['name'].first)
      @session['name'] = name                         # セッションに記憶
      @cgi.out(@header) {                             # セッション情報は隠れクッキーで保持されるため、CGI#outで出力
        <<-END
        <html><head><title>CGI::Session Demo</title></head>
        <body>
         <p>こんにちは、#{CGI.escapeHTML(name)}さん</p>
         <p><a href="#{CGI.escapeHTML(ENV['SCRIPT_NAME'])}?cmd=bye">[次へ]</a></p>
        </body></html>
        END
      }
    end
    
    def cmd_bye
      name = @session['name']                         # セッションデータから取り出し
      @cgi.out(@header) {
        <<-END
        <html><head><title>CGI::Session Demo</title></head>
        <body>
         <p>#{CGI.escapeHTML(name)}さん、さようなら</p>
         <p><a href="#{CGI.escapeHTML(ENV['SCRIPT_NAME'])}">[戻る]</a></p>
        </body></html>
        END
      }
    end
  end
  
  SessionDemo.new

=== 参考URL

  * [[url:http://www.shugo.net/article/webdb2/#label:13]]
  * [[url:http://www.modruby.net/doc/faq.ja.jis.html#label-13]]
  * [[url:http://www.ruby-doc.org/stdlib/libdoc/cgi/rdoc/index.html]]



= class CGI::Session < Object

== Class Methods

--- new(cgi[, aHash])

セッションオブジェクトを新しく作成し返します。
オプションとして [[c:Hash]] オブジェクト aHash を与えることができます。

例:

  CGI::Session.new(cgi, {"new_session" => true})

以下の文字列が aHash のキーとして認識されます。

  * "session_path"
    クッキーのb path として使われます。
    (default: File.dirname(ENV["SCRIPT_NAME"]),
    スクリプトの URI の path 部の最後のスラッシュまで)

  * "session_key"
    クッキーと <FORM type=hidden> の name として使われます。
    (default: "_session_id")

  * "session_id"
    セッション ID として使われます。
    デフォルトのデータベースである FileStore を用いる場合,
    値は英数字だけからなる文字列で無ければなりません。
    このオプションを指定するとリクエストにセッション ID が含まれても無視します。
    (default: ランダムに生成されます)

  * "new_session"
    値が true のときは強制的に新しいセッションを始めます。
#@if (version >= "1.8.2")
    以下は ((<ruby 1.8.2 feature>)) です。

    値が false のときは、リクエストにセッション ID が含まれていない場合に
    例外 ArgumentError が発生します。

    値がないときは、リクエストにセッション ID が
    含まれている場合はそれを使用し、含まれていない場合は新しいセッションを始めます。
#@end

    (default: 値なし)

  * "database_manager"
    データベースクラスを指定します。
    (defalut: CGI::Session::FileStore)

  * CGI::Session::FileStore
    テキストファイルを使います。文字列データしか扱えません。

  * CGI::Session::MemoryStore
    メモリ上のハッシュを使います。Ruby インタプリタの生存期間中のみ有効です。
    #@# mod_ruby 用って事かな...

  * CGI::Session::PStore
    Marshal フォーマットを使い、あらゆる型のデータを保存できます。
    cgi/session/pstore によって提供される機能のため、このライブラリを読み込まなければ利用できません。

  * "tmpdir"
    CGI::Session::FileStore がセッションデータを作成するディレクトリの名前を指定します。
    (default: ENV["TMP"] || "/tmp")

#@if (version >= "1.8.0")
    ((<ruby 1.8 feature>)): default は [[m:tmpdir#Dir.tmpdir]] になりました。
#@end

  * "prefix"
    CGI::Session::FileStore がセッションデータのファイル名に与えるプレフィックス。
    (default: "")

#@if (version >= "1.8.2")
  * "suffix"
    CGI::Session::FileStore がセッションデータのファイル名に与えるサフィックス。
    (default: "") ((<ruby 1.8.2 feature>))
#@end

  * "no_hidden"
    [[unknown:執筆者募集]]

  * "no_cookies"
    [[unknown:執筆者募集]]

  * "session_expires"
    セッションの有効期間。
    [[c:Time]] オブジェクトを与えると、セッションはその日時まで破棄されずに残ります。
    (default: ブラウザの終了と同時に破棄されます)

  * "session_domain"
    [[unknown:執筆者募集]]

  * "session_secure"
    [[unknown:執筆者募集]]

  * "session_path"
    [[unknown:執筆者募集]]

== Instance Methods

--- [](key)

指定されたキーの値を返します。

値が設定されていなければ nil を返します。

--- []=(key, val)

指定されたキーの値を設定します。

--- update

データベースクラスの update メソッドを呼び出して、
セッション情報をサーバに保存します。

MemoryStore の場合は何もしません。

--- close

データベースクラスの close メソッドを呼び出して、
セッション情報をサーバに保存し、セッションストレージをクローズします。
#@# mod_ruby などで CGI::Session を利用する場合、明示的に close する必要がある。　参照 http://www.modruby.net/doc/faq.ja.jis.html#label-13

--- delete

データベースクラスの delete メソッドを呼び出して、
セッションをストレージから削除します。

FileStoreの場合はセッションファイルを削除します。
セッションファイルは明示的に削除しなければ残っています。



= class CGI::Session::FileStore < Object
#@todo



= class CGI::Session::MemoryStore < Object
#@todo



= class CGI::Session::PStore < Object
#@todo
