---
library: reline
since: "3.3"
---
# class Reline::Face < Object

補完ダイアログなどの表示スタイル(色・文字装飾)をカスタマイズするためのクラスです。reline 0.4.0(Ruby 3.3 に同梱)で導入されました。

[m:Reline::Face.config] で「face」(表示スタイルの設定の組)を定義します。既定では次の
2 つの face が定義されています。

- `:default` -- 通常のテキストのスタイル
- `:completion_dialog` -- 補完ダイアログのスタイル

それぞれの face では、次の 3 つの部分のスタイルを定義します。定義しなかった部分は
`style: :reset` になります。

- `:default` -- 基本のスタイル(補完ダイアログでは候補一覧の地の部分)
- `:enhanced` -- 強調部分のスタイル(補完ダイアログでは選択中の候補)
- `:scrollbar` -- スクロールバーのスタイル

```ruby title="例: 補完ダイアログの配色を変更する"
require 'reline'

Reline::Face.config(:completion_dialog) do |conf|
  conf.define :default, foreground: :white, background: :blue
  conf.define :enhanced, foreground: :white, background: :magenta
  conf.define :scrollbar, foreground: :white, background: :blue
end
```

## Singleton Methods

### def Reline::Face.config(name) { |conf| ... } -> object

名前 `name` の face を定義します。

ブロックには設定用のオブジェクトが渡されます。`define(part, **attributes)`
を呼んで、face を構成する部分ごとのスタイルを定義します。

- `part` -- `:default`・`:enhanced`・`:scrollbar` のいずれかを指定します。
- `attributes` -- スタイルをキーワード引数で指定します。
  - `foreground:`/`background:` -- 文字色/背景色。色名のシンボル(`:black`・`:red`・`:green`・`:yellow`・`:blue`・`:magenta`・`:cyan`・`:white` と、それぞれの `:bright_*`、`:gray`)、または
    `"#RRGGBB"` 形式の文字列で指定します。
  - `style:` -- 文字装飾。`:reset`・`:bold`・`:faint`・`:italicized`・`:underlined`・`:blinking`・`:negative`
    などのシンボル、またはその配列で指定します。

`"#RRGGBB"` 形式の色指定は、トゥルーカラーとして扱われる端末(環境変数
`COLORTERM` が `truecolor` または `24bit` の環境、もしくは
[m:Reline::Face.force_truecolor] を呼んだ場合)では 24 ビットカラーで、それ以外の端末では近似の
256 色に変換して出力されます。

- **param** `name` -- face の名前をシンボルで指定します。

- **raise** `ArgumentError` -- `define` に不正な色やスタイルを指定した場合に発生します。

```ruby title="例: 補完ダイアログの配色を変更する"
require 'reline'

Reline::Face.config(:completion_dialog) do |conf|
  conf.define :default, foreground: :white, background: :blue
  conf.define :enhanced, foreground: :white, background: :magenta
  conf.define :scrollbar, foreground: :white, background: :blue
end

Reline::Face.configs[:completion_dialog][:default]
# => {foreground: :white, background: :blue, escape_sequence: "\e[0m\e[37;44m"}
```

### def Reline::Face.configs -> Hash

定義されているすべての face の設定内容をハッシュで返します。

```ruby title="例"
require 'reline'

Reline::Face.configs.keys
# => [:default, :completion_dialog]
Reline::Face.configs[:default]
# => {default: {style: :reset, escape_sequence: "\e[0m"},
#     enhanced: {style: :reset, escape_sequence: "\e[0m"},
#     scrollbar: {style: :reset, escape_sequence: "\e[0m"}}
```

### def Reline::Face.force_truecolor -> ()

端末がトゥルーカラー対応かどうかの判定を、環境変数 `COLORTERM`
の値によらず強制的に真にします。

```ruby title="例: 24 ビットカラーで補完ダイアログの色を指定する"
require 'reline'

Reline::Face.force_truecolor
Reline::Face.config(:completion_dialog) do |conf|
  conf.define :default, foreground: "#dddddd", background: "#333333"
end
```

- **SEE** [m:Reline::Face.truecolor?]

### def Reline::Face.truecolor? -> bool

端末をトゥルーカラー対応として扱うかどうかを返します。環境変数 `COLORTERM`
が `truecolor` または `24bit` の場合、もしくは [m:Reline::Face.force_truecolor]
を呼んだ後に真を返します。

- **SEE** [m:Reline::Face.force_truecolor]
