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
[c:Reline::HISTORY]([c:Array] のサブクラスのインスタンス)でアクセスできます。

挙動のカスタマイズは Reline モジュールのアトリビュートへの代入で行います。主なものは以下の通りです。

- [m:Reline.completion_proc=] -- 補完候補を計算する Proc を設定します。
#%since 3.1
- [m:Reline.autocompletion=] -- 入力中の自動補完表示を有効にします。
#%end
- [m:Reline.prompt_proc=] -- 行ごとにプロンプトを動的に差し替える Proc を設定します。
- [m:Reline.output_modifier_proc=] -- 表示前に入力内容を加工(シンタックスハイライトなど)する Proc を設定します。
- [m:Reline.auto_indent_proc=] -- 自動インデントの幅を計算する Proc を設定します。
- [m:Reline.input=] / [m:Reline.output=] -- 入出力先を差し替えます。デフォルトは標準入力/標準出力です。

キーバインドや変数は、GNU Readline と同様に inputrc ファイルで設定できます。inputrc は環境変数 `INPUTRC`、`~/.inputrc`、XDG
設定ディレクトリの `readline/inputrc` から探索されます。inputrc 内では
`$if Ruby`(または `$if Reline`)の条件ブロックも利用できます。

#%since 3.3
また、[c:Reline::Face] で補完ダイアログなどの表示スタイルをカスタマイズできます(reline 0.4.0 以降)。
#%end

## Singleton Methods

### def Reline.readline(prompt = "", add_hist = false) -> String | nil
{: since="2.7"}

`prompt` を出力し、ユーザからのキー入力を待ちます。
エンターキーの押下などでユーザが文字列を入力し終えると、入力した文字列を返します。返り値の末尾に改行は含まれません。
このとき、`add_hist` が真であれば、入力した文字列を入力履歴 [c:Reline::HISTORY]
に追加します。空の入力は追加されません。
何も入力していない状態で EOF(UNIX では ^D)を入力するなどで、ユーザからの入力がない場合は `nil` を返します。

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

`prompt` を出力し、ユーザからの複数行の入力を待ちます。

一行の入力が確定するたびに、それまでに入力された全体の文字列 `text`
を引数としてブロックが呼ばれます。ブロックが真を返すと入力を終了し、入力された複数行全体をひとつの文字列(各行を `"\n"`
で連結したもの)として返します。返り値の末尾に改行は含まれません。

`add_hist` が真であれば、入力した複数行全体をひとつのエントリとして入力履歴
[c:Reline::HISTORY] に追加します。空の入力は追加されません。

何も入力していない状態で EOF(UNIX では ^D)を入力するなどで、ユーザからの入力がない場合は `nil` を返します。

- **param** `prompt` -- カーソルの前に表示する文字列を指定します。デフォルトは `""` です。
- **param** `add_hist` -- 真ならば、入力した文字列を入力履歴に追加します。デフォルトは偽です。

- **raise** `ArgumentError` -- ブロックを省略した場合に発生します。

```ruby title="例: 「end」だけの行が入力されたら入力を終了する"
require 'reline'

code = Reline.readmultiline("> ", true) { |text| text.split("\n").last == "end" }
puts code
```

### def Reline.input=(input)
{: since="2.7"}

Reline が入力の読み取りに使うオブジェクトを `input` に変更します。デフォルトは標準入力です。

- **param** `input` -- `getc` メソッドを持つオブジェクト([c:IO] など)、または `nil` を指定します。

- **raise** `TypeError` -- `input` が `nil` でも `getc` メソッドを持つオブジェクトでもない場合に発生します。

### def Reline.output=(output)
{: since="2.7"}

Reline が表示に使うオブジェクトを `output` に変更します。デフォルトは標準出力です。

- **param** `output` -- `write` メソッドを持つオブジェクト([c:IO] など)、または `nil` を指定します。

- **raise** `TypeError` -- `output` が `nil` でも `write` メソッドを持つオブジェクトでもない場合に発生します。

### def Reline.completion_proc -> Proc | nil
{: since="2.7"}
### def Reline.completion_proc=(proc)
{: since="2.7"}

ユーザからの入力を補完するときの候補を取得する [c:Proc]
オブジェクトを取得/設定します。デフォルトは `nil` で、このときは補完を行いません。

`proc` は、引数に入力中の単語(カーソル位置までの、[m:Reline.completer_word_break_characters]
に含まれる文字で区切られた文字列)を受け取り、候補の文字列の配列を返すようにします。
2 個以上の引数を受け取る `proc` を指定した場合は、第 2 引数に単語より前の文字列が、第 3 引数に単語より後ろの文字列も渡されます。

補完は Tab キーの押下で実行されます。
#%since 3.1
[m:Reline.autocompletion] が真のときは、文字の入力のたびに呼ばれて候補がダイアログに表示されます。
#%end

- **param** `proc` -- 補完候補を取得する [c:Proc] オブジェクト、または `nil` を指定します。

```ruby title="例: foo、foobar、foobaz を補完する"
require 'reline'

WORDS = %w(foo foobar foobaz)

Reline.completion_proc = proc { |word|
  WORDS.grep(/\A#{Regexp.quote(word)}/)
}

while buf = Reline.readline("> ")
  print("-> ", buf, "\n")
end
```

#%since 3.1
### def Reline.autocompletion -> bool
### def Reline.autocompletion=(bool)

入力中に補完候補を自動的にダイアログ表示するかどうかを取得/設定します。デフォルトは `false` です。

`true` を指定すると、文字を入力するたびに [m:Reline.completion_proc]
が呼ばれ、候補がダイアログに表示されます([lib:irb] の入力補完表示で使われている機能です)。

- **param** `bool` -- 自動補完表示を有効にするかどうかを真偽値で指定します。

#%end
### def Reline.completion_case_fold -> bool
{: since="2.7"}
### def Reline.completion_case_fold=(bool)
{: since="2.7"}

ユーザの入力を補完する際、大文字と小文字を同一視するかどうかを取得/設定します。`bool`
が真ならば同一視します。デフォルトは `nil` です。

inputrc の `set completion-ignore-case on` でも設定できます。

- **param** `bool` -- 大文字と小文字を同一視する(`true`)/しない(`false`)を指定します。

### def Reline.completion_append_character -> String | nil
{: since="2.7"}
### def Reline.completion_append_character=(string)
{: since="2.7"}

補完が 1 つの候補に確定したときに、末尾に付加する文字を取得/設定します。デフォルトは
`nil`(何も付加しない)です。

1 文字しか指定できないため、`string` に 2 文字以上の文字列を指定した場合は最初の
1 文字だけが使われます。半角スペース `" "` などの単語を区切る文字を指定すれば、補完後に続けて入力する際に便利です。

- **param** `string` -- 付加する 1 文字を指定します。`nil` を指定すると何も付加しません。

### def Reline.completion_quote_character -> String | nil
{: since="2.7"}

ユーザ入力の補完中([m:Reline.completion_proc] の呼び出し中)に、開いたまま閉じられていないクオート文字([m:Reline.completer_quote_characters]
のいずれか)があればそれを返します。補完中以外は `nil` を返します。

### def Reline.completer_word_break_characters -> String
{: since="2.7"}
### def Reline.completer_word_break_characters=(string)
{: since="2.7"}

ユーザの入力の補完を行う際、単語の区切りを示す文字の集合を取得/設定します。

デフォルトは ``" \t\n`><=;|&{("``(半角スペースを含む)です。

- **param** `string` -- 文字列を指定します。

### def Reline.completer_quote_characters -> String
{: since="2.7"}
### def Reline.completer_quote_characters=(string)
{: since="2.7"}

ユーザの入力の補完を行う際、クオートとみなす文字の集合を取得/設定します。クオートの内側では、[m:Reline.completer_word_break_characters=]
で指定した文字も通常の文字として扱われます。

デフォルトは `"'`(ダブルクオートとシングルクオート)です。

- **param** `string` -- 文字列を指定します。

### def Reline.basic_word_break_characters -> String
{: since="2.7"}
### def Reline.basic_word_break_characters=(string)
{: since="2.7"}

単語の区切りを示す文字の集合を取得/設定します。

デフォルトは ``" \t\n`><=;|&{("``(半角スペースを含む)です。

設定値は保持されますが、現在の reline の補完処理では使用されません。補完の単語の区切りには
[m:Reline.completer_word_break_characters] が使われます。

- **param** `string` -- 文字列を指定します。

### def Reline.basic_quote_characters -> String
{: since="2.7"}
### def Reline.basic_quote_characters=(string)
{: since="2.7"}

クオートとみなす文字の集合を取得/設定します。

デフォルトは `"'`(ダブルクオートとシングルクオート)です。

設定値は保持されますが、現在の reline の補完処理では使用されません。クオートの判定には
[m:Reline.completer_quote_characters] が使われます。

- **param** `string` -- 文字列を指定します。

### def Reline.filename_quote_characters -> String
{: since="2.7"}
### def Reline.filename_quote_characters=(string)
{: since="2.7"}

ファイル名の補完の際にクオートするための文字の集合を取得/設定します。デフォルトは `""` です。

設定値は保持されますが、現在の reline の補完処理では使用されません。

- **param** `string` -- 文字列を指定します。

### def Reline.special_prefixes -> String
{: since="2.7"}
### def Reline.special_prefixes=(string)
{: since="2.7"}

補完対象の単語の一部として扱う接頭辞の文字の集合を取得/設定します。デフォルトは `""` です。

設定値は保持されますが、現在の reline の補完処理では使用されません。

- **param** `string` -- 文字列を指定します。

### def Reline.prompt_proc -> Proc | nil
{: since="2.7"}
### def Reline.prompt_proc=(proc)
{: since="2.7"}

[m:Reline.readmultiline] での複数行編集時に、行ごとのプロンプトを動的に生成する
[c:Proc] オブジェクトを取得/設定します。デフォルトは `nil` です。

`proc` は、入力中の各行の文字列を要素とする配列を受け取り、行ごとのプロンプト文字列の配列を返すようにします。[m:Reline.readline]
による一行入力では使われません。

- **param** `proc` -- プロンプトの配列を返す [c:Proc] オブジェクト、または `nil` を指定します。

### def Reline.output_modifier_proc -> Proc | nil
{: since="2.7"}
### def Reline.output_modifier_proc=(proc)
{: since="2.7"}

入力内容を表示する直前に、表示用に加工する [c:Proc]
オブジェクトを取得/設定します。シンタックスハイライトなどに利用できます。デフォルトは `nil` です。

`proc` は、第 1 引数に入力内容全体の文字列(末尾に改行を含む)を、キーワード引数
`complete` に入力が確定したかどうかの真偽値を受け取り、表示に使う文字列を返すようにします。返した文字列は表示にだけ使われ、[m:Reline.readline]
などの返り値は変わりません。

- **param** `proc` -- 表示用の文字列を返す [c:Proc] オブジェクト、または `nil` を指定します。

### def Reline.auto_indent_proc -> Proc | nil
{: since="2.7"}
### def Reline.auto_indent_proc=(proc)
{: since="2.7"}

複数行編集時に、行頭の自動インデントの幅を計算する [c:Proc]
オブジェクトを取得/設定します。デフォルトは `nil` です。

`proc` は次の 4 つの引数を受け取り、インデントに使う半角スペースの個数を整数で返すようにします。`nil`
を返すとインデントを変更しません。対象の行の行頭の空白は、返した個数の半角スペースに置き換えられます。

- `lines`: 入力中の各行の文字列の配列
- `line_index`: インデントを計算する対象の行の `lines` 内の位置
- `byte_pointer`: 行内のカーソルのバイト単位の位置
- `is_newline`: 改行の入力直後かどうか

- **param** `proc` -- インデント幅を返す [c:Proc] オブジェクト、または `nil` を指定します。

### def Reline.pre_input_hook -> Proc | nil
{: since="2.7"}
### def Reline.pre_input_hook=(proc)
{: since="2.7"}

[m:Reline.readline] や [m:Reline.readmultiline]
が入力の受け付けを始める直前に呼ばれる [c:Proc]
オブジェクトを取得/設定します。`proc` は引数なしで呼ばれます。デフォルトは `nil` です。

- **param** `proc` -- [c:Proc] オブジェクト、または `nil` を指定します。

### def Reline.dig_perfect_match_proc -> Proc | nil
{: since="2.7"}
### def Reline.dig_perfect_match_proc=(proc)
{: since="2.7"}

補完候補が 1 つに確定している状態で、さらに補完しようとしたときに呼ばれる
[c:Proc] オブジェクトを取得/設定します。`proc`
は確定した候補の文字列を引数として呼ばれます。デフォルトは `nil` です。

- **param** `proc` -- [c:Proc] オブジェクト、または `nil` を指定します。

### def Reline.vi_editing_mode -> nil
{: since="2.7"}

編集モードを vi モードにします。

inputrc の `set editing-mode vi` でも設定できます。

- **SEE** [m:Reline.emacs_editing_mode]、[m:Reline.vi_editing_mode?]

### def Reline.emacs_editing_mode -> nil
{: since="2.7"}

編集モードを Emacs モードにします。デフォルトは Emacs モードです。

- **SEE** [m:Reline.vi_editing_mode]、[m:Reline.emacs_editing_mode?]

### def Reline.vi_editing_mode? -> bool
{: since="2.7"}

編集モードが vi モードかどうかを返します。

- **SEE** [m:Reline.vi_editing_mode]

### def Reline.emacs_editing_mode? -> bool
{: since="2.7"}

編集モードが Emacs モードかどうかを返します。

- **SEE** [m:Reline.emacs_editing_mode]

### def Reline.get_screen_size -> [Integer, Integer]
{: since="2.7"}

端末のサイズを [行数, 桁数] の配列で返します。
