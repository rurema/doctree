---
type: library
since: "2.7"
category: CUI
---
GNU Readline 互換の行編集機能を純 Ruby で実装したライブラリです。

Ruby 2.7 から標準添付されており、[lib:irb] をはじめとする対話的なコマンドラインツールの入力部分の実体として使われています。外部の C ライブラリに依存しないため、GNU Readline が利用できない環境でも動作します。

- プロジェクトページ: <https://github.com/ruby/reline>

```ruby title="例: プロンプト「> 」を表示して、ユーザからの入力を取得する"
require 'reline'

while buf = Reline.readline("> ", true)
  print("-> ", buf, "\n")
end
```

# module Reline

GNU Readline 互換の行編集機能を提供するモジュールです。

[m:Reline.readline] でユーザからの一行入力を、[m:Reline.readmultiline]
で複数行の入力を取得できます。入力時には行内編集が可能で、vi モードと
Emacs モードが用意されています。デフォルトは Emacs モードです。

入力した内容は入力履歴(ヒストリ)として記録できます。履歴には定数
`Reline::HISTORY`([c:Array] のサブクラスのインスタンス)でアクセスできます。

挙動のカスタマイズは Reline モジュールのアトリビュートへの代入で行います。主なものは以下の通りです。これらの詳細は本リファレンスではまだ扱っていません。完全な API については公式ドキュメントを参照してください。

- `Reline.completion_proc=`: 補完候補を計算する Proc を設定します。
- `Reline.autocompletion=`: 入力中の自動補完表示を有効にします。
- `Reline.prompt_proc=`: 行ごとにプロンプトを動的に差し替える Proc を設定します。
- `Reline.output_modifier_proc=`: 表示前に入力内容を加工(シンタックスハイライトなど)する Proc を設定します。
- `Reline.auto_indent_proc=`: 自動インデントの幅を計算する Proc を設定します。
- `Reline.input=` / `Reline.output=`: 入出力先を差し替えます。デフォルトは標準入力/標準出力です。

また、Ruby 3.3 以降に同梱されるバージョン(reline 0.4.0 以降)では、
`Reline::Face` で補完ダイアログなどの表示色をカスタマイズできます。

## Singleton Methods

### def Reline.readline(prompt = "", add_hist = false) -> String | nil
{: since="2.7"}

prompt を出力し、ユーザからのキー入力を待ちます。
エンターキーの押下などでユーザが文字列を入力し終えると、入力した文字列を返します。返り値の末尾に改行は含まれません。
このとき、add_hist が真であれば、入力した文字列を入力履歴 `Reline::HISTORY`
に追加します。空の入力は追加されません。
何も入力していない状態で EOF(UNIX では ^D)を入力するなどで、ユーザからの入力がない場合は nil を返します。

- **param** `prompt` -- カーソルの前に表示する文字列を指定します。デフォルトは `""` です。
- **param** `add_hist` -- 真ならば、入力した文字列を入力履歴に追加します。デフォルトは偽です。

```ruby title="例"
require 'reline'

while buf = Reline.readline("> ", true)
  print("-> ", buf, "\n")
end
```

### def Reline.readmultiline(prompt = "", add_hist = false) { |text| ... } -> String | nil
{: since="2.7"}

prompt を出力し、ユーザからの複数行の入力を待ちます。

一行の入力が確定するたびに、それまでに入力された全体の文字列を引数としてブロックが呼ばれます。ブロックが真を返すと入力を終了し、入力された複数行全体をひとつの文字列(各行を `"\n"` で連結したもの)として返します。返り値の末尾に改行は含まれません。

add_hist が真であれば、入力した複数行全体をひとつのエントリとして入力履歴
`Reline::HISTORY` に追加します。空の入力は追加されません。

何も入力していない状態で EOF(UNIX では ^D)を入力するなどで、ユーザからの入力がない場合は nil を返します。

- **param** `prompt` -- カーソルの前に表示する文字列を指定します。デフォルトは `""` です。
- **param** `add_hist` -- 真ならば、入力した文字列を入力履歴に追加します。デフォルトは偽です。

- **raise** `ArgumentError` -- ブロックを省略した場合に発生します。

```ruby title="例: 「end」だけの行が入力されたら入力を終了する"
require 'reline'

code = Reline.readmultiline("> ", true) { |text| text.split("\n").last == "end" }
puts code
```
