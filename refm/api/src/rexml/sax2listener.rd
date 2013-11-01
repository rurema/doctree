
[[c:REXML::Parsers::SAX2Parser]] 
で使われるコールバックオブジェクトのためのモジュール、
[[c:REXML::SAX2Listener]] を定義しています。

= module REXML::SAX2Listener

[[c:REXML::Parsers::SAX2Parser]] 
で使われるコールバックオブジェクトのためのモジュールです。

このモジュールを include して、各メソッドを適切にオーバーライドした
クラスのインスタンスを
[[m:REXML::Parsers::SAX2Parser#listen]] で渡します。

[[m:REXML::Parsers::SAX2Parser#listen]] ではこのモジュールを使わずに
ブロックを使う方法もあります。

このモジュールで定義されているメソッド自体は何もしません。
コールバックのデフォルト動作(何もしない)を定義しているだけです。

== Instance Methods

--- start_document -> ()
ドキュメントの先頭で呼び出されるコールバックメソッドです。

--- end_document -> ()
ドキュメントの末尾で呼び出されるコールバックメソッドです。

--- start_prefix_mapping(prefix, uri) -> ()
名前空間の接頭辞(prefix)が導入されたときに呼び出される
コールバックメソッドです。

以下のようなXMLを処理
  <a xmlns:foo="http://foo.example.org/">
    <foo:b />
  </a>
すると
  start_prefix_mapping("foo", "http://foo.example.org/")
  start_element(nil, "a", "a", {"xmlns:foo" => "http://foo.example.org/"})
    :
  end_element(nil, "a", "a")
  end_prefix_mapping("foo")
の順で呼びだされます。つまり名前空間を導入した要素の start_element の前に
start_prefix_mapping が呼びだされます。

@param prefix 接頭辞の文字列が渡されます
@param uri 接頭辞に対応する URI 文字列が渡されます

--- end_prefix_mapping(prefix) -> ()
名前空間の接頭辞(prefix)の適用範囲が終了したときに
呼び出されるコールバックメソッドです。

@param prefix 接頭辞の文字列が渡されます

--- start_element(uri, localname, qname, attributes) -> ()
要素が開始されたときに呼び出されるコールバックメソッドです。

@param uri 名前空間のURI文字列が渡されます。対応する名前空間が存在しない場合は
       nil が渡されます
@param localname 接頭辞を取り除いた要素名文字列が渡されます
@param qname 修飾名(qualified-name)文字列、つまり接頭辞を含む文字列が渡されます
@param attribute 属性が { 属性名 => 属性値文字列 } という [[c:Hash]] で
       で渡されます。

--- end_element(uri, localname, qname) -> ()
要素が終了した(閉じられた)ときに呼び出されるコールバックメソッドです。

@param uri 名前空間のURI文字列が渡されます。対応する名前空間が存在しない場合は
       nil が渡されます
@param localname 接頭辞を取り除いた要素名文字列が渡されます
@param qname 修飾名(qualified-name)文字列、つまり接頭辞を含む文字列が渡されます


--- characters(text) -> ()
XML の文字データに出会ったときに呼び出されるコールバックメソッドです。

@param text 文字データ(文字列)が渡されます

--- processing_instruction(target, data) -> ()
XML 処理命令(PI)に対し呼び出されるコールバックメソッドです。

@param target ターゲット名が文字列で渡されます
@param data 処理命令の内容が文字列で渡されます

--- doctype(name, pub_sys, long_name, uri) -> ()
文書型宣言(DTD)に出会った時に呼び出されるコールバックメソッドです。

@param name 宣言されているルート要素名が文字列で渡されます。
@param pub_sys "PUBLIC" もしくは "SYSTEM" が渡されます。nilが渡される場合もあります。
@param long_name "SYSTEM" の場合はシステム識別子が、"PUBLIC"の場合は公開識別子が
       文字列で渡されます
@param uri "SYSTEM" の場合は nil が、"PUBLIC" の場合はシステム識別子が渡されます

--- attlistdecl(element, pairs, contents) -> ()
DTDの属性リスト宣言に対し呼び出されるコールバックメソッドです。

@param element 要素名が文字列で渡されます
@param pairs 属性名とそのデフォルト値の対応が 
     { 属性名文字列 => デフォルト値文字列(無ければnil) } という
     ハッシュテーブルで渡されます
@param contents 文書内の属性リスト宣言の文字列がそのまま渡されます

--- elementdecl(content) -> ()
DTDの要素型宣言をパースしたときに呼び出されるコールバックメソッドです。

@param content 要素型宣言が文字列として渡されます。

--- entitydecl(content) -> ()
DTDの実体宣言に出会ったときに呼び出されるコールバックメソッドです。

@param content 実体宣言が配列で渡されます

--- notationdecl(name, public_or_system, public_id, system_id) -> ()
DTDの記法宣言に出会ったときに呼び出されるコールバックメソッドです。

@param name 記法名が文字列で渡されます
@param public_or_system "PUBLIC" もしくは "SYSTEM" が渡されます
@param public_id 公開識別子が文字列で渡されます。指定されていない場合はnilが渡されます
@param system_id システム識別子が文字列で渡されます。指定されていない場合はnilが渡されます


--- cdata(content) -> ()
CDATA セクションに出会ったときに呼び出されるコールバックメソッドです。

@param content CDATAセクションの内容の文字列が渡されます

--- xmldecl(version, encoding, standalone) -> ()
XML宣言に出会ったときに呼び出されるコールバックメソッドです。

@param version 宣言されているバージョンが文字列で渡されます。
@param encoding 宣言されているエンコーディングが文字列で渡されます。
@param standalone スタンドアロン文書であるかどうかが "yes" "no" で渡されます

--- comment(comment) -> ()
XML文書内のコメントに出会ったときに呼び出されるコールバックメソッドです。

@param comment コメントの内容が文字列で渡されます


#@since 1.8.3
--- progress(position) -> ()
パーサが入力を読み進めたときに呼び出されるコールバックメソッドです。

これの呼び出しの次のコールバックは基本的にこれで報告される位置から
読み出したデータによるものです。

@param position パーサの入力位置のバイト数

#@end

