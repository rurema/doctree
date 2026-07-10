# Rurema Markdown (#@ directives) — VS Code 拡張

るりまの `manual/**/*.md` で使う `#@` プリプロセッサ指令を Markdown 上で
ハイライトする VS Code 拡張です。文法（TextMate grammar）だけの小さな拡張で、
既存の Markdown ハイライトに注入（injection）する形なので、
Markdown 本来の表示はそのまま維持されます。

対応する指令（bitclust の Preprocessor と同じ集合）:

| 指令 | 表示 |
|------|------|
| `#@since 3.0` / `#@until 3.4` | キーワード + バージョン値 |
| `#@if (version >= "3.1")` | キーワード + 条件式（`version`・比較/論理演算子・文字列） |
| `#@else` / `#@end` | キーワード |
| `#@include(pack-template)` | キーワード + パス |
| `#@samplecode 例` | キーワード + ラベル |
| `#@todo`（大文字小文字不問） | 作業メモとして強調 |
| `#@# コメント` | コメント |
| **上記以外の行頭 `#@...`** | **エラー表示**（ビルドでも parse error になるため。タイポ検出に役立つ） |

指令として扱われるのは**行頭（カラム0）の `#@` 行だけ**です
（インデントされた `#@` は本文テキスト。bitclust の挙動と同じ）。
プリプロセッサはコードブロック内の `#@` も処理するため、
ハイライトもコードブロック内に適用されます。
YAML front matter 内の `#@since` 等（ゲート付きリスト）にも効きます。

## インストール

marketplace には公開していません。checkout からシンボリックリンクで入れます:

```console
$ ln -s "$(pwd)/tools/vscode/rurema-markdown" ~/.vscode/extensions/rurema-markdown
```

（Windows はリンクの代わりにフォルダごと `%USERPROFILE%\.vscode\extensions\` へコピー）

その後 VS Code を再起動（または「開発者: ウィンドウの再読み込み」）してください。
`manual/` 配下の `.md` を開くと `#@` 行に色が付きます。

アンインストールはリンク（コピー）を消すだけです。

## 制限・今後の拡張候補

- ハイライトのみで、補完・診断（Language Server）はありません
- るりま独自のリンク記法（`[m:Array#each]` 等）やメソッドシグネチャ
  （`### def ...`）のハイライトは今後の拡張候補です
- 記法の仕様は bitclust の
  [MARKUP_SPEC.md](https://github.com/rurema/bitclust/blob/master/doc/markdown-samples/MARKUP_SPEC.md)
  を参照してください
