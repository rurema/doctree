# 英語版リファレンス（docs.ruby-lang.org/en/）との関係

<https://docs.ruby-lang.org/> には英語版（en）と日本語版（ja）のリファレンスが
ありますが、この2つは翻訳関係にはない、独立した別プロジェクトです。

- **英語版** <https://docs.ruby-lang.org/en/> は、Ruby 本体
  （<https://github.com/ruby/ruby>）のソースコードに埋め込まれた
  rdoc コメントから生成されています。内容の修正は Ruby 本体への
  コントリビュートとして行います。
- **日本語版** <https://docs.ruby-lang.org/ja/> は、るりまプロジェクトが
  このリポジトリ（rurema/doctree）で執筆・維持している原稿から
  BitClust で生成されています。英語版の翻訳プロジェクトではなく、
  もともと独自に日本語で書き起こされたものです。ただし現在は、
  更新の際に英語版を参考にしたり、部分的に英語版を翻訳して
  取り込んだりした記述も混ざっています。

## 収録方針の違いの例

生成元が異なるため、同じメソッドでも掲載場所や説明が異なることがあります。

例えば `Object#class` は、英語版では rdoc がソースコード上の定義に従って
Kernel のページに掲載しています（Object のページには載っていません。
英語版の Object のページには「Object のインスタンスメソッドは
Kernel モジュールで定義されている」という説明があります）。
一方、日本語版は利用者視点で [Object#class](https://docs.ruby-lang.org/ja/latest/method/Object/i/class.html)
として Object のページに掲載しています。

このように片方に見つからない項目でも、もう片方には別の場所に
あることがあります。

## 誤りを見つけたら

- 英語版の誤り: Ruby 本体のソースコード中の rdoc コメントが原稿なので、
  <https://bugs.ruby-lang.org/> または <https://github.com/ruby/ruby> へ
- 日本語版の誤り: このリポジトリ
  （<https://github.com/rurema/doctree/issues>）へ

## 統合・多言語化について

英語版と日本語版の統合や、リファレンスの多言語化は、たびたび話題に
なる長期的な構想ですが、現時点で具体的な計画はありません。
議論やアイデアは
[rurema/doctree#2887](https://github.com/rurema/doctree/issues/2887)
などの issue で受け付けています。
