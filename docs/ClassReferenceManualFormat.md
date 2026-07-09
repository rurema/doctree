# クラスリファレンスのファイル構造

クラスリファレンスは GFM ベースの Markdown で記述します（`manual/api/**/*.md`）。
ただし、厳密にパースできるように構造に規約があります。
記法の正式仕様は
[MARKUP_SPEC.md](https://github.com/rurema/bitclust/blob/master/doc/markdown-samples/MARKUP_SPEC.md)
です。本文の書き方は [ReferenceManualFormatDigest](ReferenceManualFormatDigest.md)、
メソッドの書き方は [HowToWriteMethodEntry](HowToWriteMethodEntry.md) を参照してください。

## ファイル構成の基本: 1ファイル = 1エンティティ

**1ファイルに1つのクラス/モジュール**を書くのが基本です。
ビルドは `manual/api` 配下を glob し、各ファイルの front matter と H1 から
マニュアル全体の構成を組み立てます（旧世界の `LIBRARIES` マニフェストと
クラス束ね用の `#@include` は廃止されました）。

ファイルは内容によって次の3種に分類されます。拡張子はすべて `.md` です。

| 種別 | 判定条件 |
|------|---------|
| エンティティ | エンティティ H1（`# class` など）を持つ |
| ライブラリ概要 | front matter に `type: library` を持つ |
| 共有断片 | 上記いずれも持たない（`#@include` で本文へ展開される） |

* 1ファイルが「ライブラリ概要」と「エンティティ」を兼ねてもよい
  （`pathname` のような単一クラスの小規模ライブラリ）。
* mixin や別名などの**関係（include/extend/alias）を持つエンティティは必ず単独ファイル**にします
  （関係の記述場所を front matter に一元化するため）。
* 関係を持たないエンティティは1ファイルに複数束ねても構いません
  （`Errno::EXXX` 群や「本体クラス + そのエラークラス」の対など）。

## front matter（メタデータ）

ファイル冒頭に `---` で囲んだ YAML ブロックを置き、タイトルに現れない
構造・関係データを記述します。

### エンティティのメタデータ

```markdown
---
library: _builtin
include:
  - Enumerable
since: "3.2"
---
# class Set < Object

集合を表すクラスです。
```

| キー | 説明 |
|------|------|
| `library` | 所属ライブラリ（必須・スカラ） |
| `include` | mixin する module（リスト） |
| `extend` | extend する module（リスト） |
| `alias` | このクラス自体の別名（リスト）。例: Net::SMTP に対する Net::SMTPSession |
| `since` / `until` | クラス自体がバージョンで追加・削除される場合の版ゲート（任意） |

* 種別・名前・継承は H1 が担うので、front matter には書きません。
* `include`/`extend`/`alias` の記述場所は front matter **のみ**です。
  本文に書いてはいけません。

### ライブラリ概要のメタデータ

```markdown
---
type: library
category: Network
require:
  - cgi/core
  - cgi/cookie
sublibrary:
  - cgi/session
---
CGI プログラムの支援ライブラリです。
```

| キー | 説明 |
|------|------|
| `type` | `library`（ライブラリ概要ファイルであることの明示） |
| `category` | ライブラリのカテゴリ |
| `require` | 依存ライブラリ（書き方は [HowToWriteRequire](HowToWriteRequire.md) 参照） |
| `sublibrary` | サブライブラリ |
| `name` | ライブラリ名の明示（大文字小文字衝突の回避で改名されたファイルのみ） |

ライブラリ名はファイルパスから決まります（`json.md` → ライブラリ `json`、
`json/add/core.md` → サブライブラリ）。同一ディレクトリ内で大文字小文字だけが
異なるファイル名は禁止です（macOS/Windows でチェックアウトできなくなるため。
その場合は `fiddle/fiddle.lib.md` のように `.lib` を挟み、`name:` で名前を明示します）。

### front matter 内のバージョン分岐

リスト値が版によって増減する場合は、front matter の中に `#@since` などを書けます。

```yaml
---
library: _builtin
include:
  - Enumerable
#@since 3.1
  - Comparable
#@end
---
```

`#@` 行は YAML コメントとして扱われるため、GitHub のプレビューでも YAML は壊れません。

## H1: エンティティ宣言

```markdown
# class Array < Object
# module Comparable
# object ENV
# reopen Kernel
# redefine String
```

| 種別 | 用途 |
|------|------|
| `class` | クラス。継承は `< SuperClass` で書く |
| `module` | モジュール |
| `object` | ENV や ARGF のような特異メソッドを持つオブジェクト。クラス名は `< Object` 省略可 |
| `reopen` | 既存クラスへのメソッド追加（time ライブラリなど、もともと無いメソッドの動的定義） |
| `redefine` | 既存メソッドの再定義（定義済みメソッドを消して定義しなおすもの） |

* クラス名・モジュール名には必ず絶対パスを使ってください（`Net::SMTP` を `SMTP` と書かない）。
* `reopen`/`redefine` のファイルに説明の文章は書けません。追加・再定義の説明は
  ライブラリ概要のドキュメントに書いてください。
* `object` に `include` は書けません。またメソッドの種類が
  Public Singleton Method に固定されるため、H2 のメソッドカテゴリは書きません。

H1 の後にはクラス・モジュール自身のドキュメント（省略可能）を書き、
続いてメソッドカテゴリ（H2）を書きます。

## H2: メソッドカテゴリ

```markdown
## Singleton Methods
```

H2 見出しには以下の種類があります。

| 見出し | 内容 |
|--------|------|
| `Singleton Methods` または `Class Methods` | public な特異メソッド |
| `Private Singleton Methods` | private な特異メソッド |
| `Protected Singleton Methods` | protected な特異メソッド |
| `Instance Methods` | public なインスタンスメソッド |
| `Private Instance Methods` | private なインスタンスメソッド |
| `Protected Instance Methods` | protected なインスタンスメソッド |
| `Module Functions` | モジュール関数（public singleton method + private instance method） |
| `Constants` | 定数 |
| `Special Variables` | 特殊変数（Kernel 限定） |

各カテゴリの下にメソッドエントリ（H3）を書きます。
書き方は [HowToWriteMethodEntry](HowToWriteMethodEntry.md) を参照してください。

## 本文の見出しとアンカー

クラスのドキュメントやライブラリ概要の中で見出しを使いたいときは
H3（`###`）以降を使います（メソッドシグネチャと区別するため、
キーワード `def`/`const`/`gvar` で始まる見出しは書けません）。
アンカーを付けたいときは `{#id}` を見出し末尾に付けます。

```markdown
### 多言語化と文字列のエンコーディング {#m17n}
```

## 既存リファレンスから削除された機能

* RD の `(('...'))` や `((|...|))` はサポートしません。
* 脚注とコメントも廃止されています。コメントを書きたい場合は
  プリプロセッサコメント `#@# ...` を使ってください。

## プリプロセッサ

各ファイルは事前に専用プリプロセッサで処理されます。命令はすべて行単位で
「#@」で始まります。一覧と使い方は
[ReferenceManualFormatDigest](ReferenceManualFormatDigest.md) の
「特殊な記法」を参照してください。

## 関連

* [FrequentlyAskedQuestions](FrequentlyAskedQuestions.md)
