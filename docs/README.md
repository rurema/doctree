# docs/ — プロジェクト文書

このディレクトリは、[GitHub wiki](https://github.com/rurema/doctree/wiki) の全ページを
2026年7月に subtree マージで取り込んだものです。wiki の全履歴（2013年以降の165コミット）を
保持しています。以後の更新は通常のファイルと同じく Pull Request で行います。

取り込み時点の各ページは wiki の内容そのままです。多くのページは 2017年の一括インポート以降
更新されておらず、特に記法まわりは 2026年7月の Markdown 移行を反映していません。
以下の棚卸し一覧に沿って順次整理する予定です。

## 棚卸し一覧（2026-07 時点の提案）

処理区分:

- **維持** — ほぼそのまま使える（リンク修正程度）
- **部分更新** — 記法例やリンクなど一部の更新が必要
- **書き直し** — Markdown 移行後の現状に合わせて全面的に書き直す
- **統合** — 他の文書（CONTRIBUTING.md 等）にまとめて本体は削除
- **移動** — rurema/bitclust リポジトリの doc/ へ
- **アーカイブ** — 歴史的記録として `docs/archive/` へ（内容は更新しない）
- **削除** — 空ページや役目を終えたページ

### 執筆ガイド（Markdown 移行の反映が必要）

| ページ | 提案 | 理由・備考 |
|--------|------|-----------|
| [ReferenceManualFormatDigest](ReferenceManualFormatDigest.md) | 書き直し | 記法まとめの中心ページだが全編 RRD 記法。[MARKUP_SPEC.md](https://github.com/rurema/bitclust/blob/master/doc/markdown-samples/MARKUP_SPEC.md) ベースの Markdown 版に |
| [ClassReferenceManualFormat](ClassReferenceManualFormat.md) | 書き直し | RRD の詳細仕様（499行）。仕様の正は MARKUP_SPEC.md に移ったので、執筆者向けの平易なガイドとして再構成 |
| [HowToWriteMethodEntry](HowToWriteMethodEntry.md) | 書き直し | メソッドエントリの書き方。`---` シグネチャ・`@param` 等すべて旧記法 |
| [Tutorial](Tutorial.md) | 書き直し | 執筆チュートリアル。`refm/api/src` 前提のディレクトリ説明・RD 前提。`manual/` 前提に |
| [DirectoryTree](DirectoryTree.md) | 書き直し | `refm/` 構成の説明。`manual/{api,doc,capi}` 構成に（短いので容易） |
| [FrequentlyAskedQuestions](FrequentlyAskedQuestions.md) | 部分更新 | 「`.#` ってなに?」など旧記法前提の Q&A を Markdown 記法（`?` 等）に更新。記法非依存の Q&A は有効 |
| [SampleCodeGuideline](SampleCodeGuideline.md) | 部分更新 | サンプルコードの方針自体は記法非依存で有効。`#@samplecode` の例を ```` ```ruby ```` に |
| [HowToWriteRequire](HowToWriteRequire.md) | 部分更新 | require の書き方ルールは有効。`.rd` のファイル名例と、front matter `require:` への言及を追加 |
| [WritingRule](WritingRule.md) | 維持 | 文体・日本語の規約で記法非依存。そのまま有効 |
| [CapiReferenceManual](CapiReferenceManual.md) | 部分更新 | C API リファレンスの紹介。記法参照先と代替 URL（doc.okkez.net）の更新のみ |

### 参加・貢献ガイド

| ページ | 提案 | 理由・備考 |
|--------|------|-----------|
| [HowToJoin](HowToJoin.md) | 書き直し | 「ML 参加＝プロジェクト参加」だが ML は消滅済み。GitHub（Issue/PR）ベースの参加案内に |
| [HowToContribute](HowToContribute.md) | 統合 | 内容は CONTRIBUTING.md と重複。差分（サンプル検証などの貢献形態）を CONTRIBUTING.md に移して削除 |
| [HowToReport](HowToReport.md) | 統合 | Issue 登録手順8行。CONTRIBUTING.md に一文で足りる |
| [GitRepository](GitRepository.md) | 部分更新 | リポジトリ一覧は有効。コミットメール等の記述は現状確認の上整理 |
| [Communication-and-knowledge-sharing](Communication-and-knowledge-sharing.md) | 部分更新 | 連絡手段の案内。esa の招待 URL が記載されているので、リポジトリ移行を機に扱いを要確認（URL の無効化・差し替え）。Gitter の現状も確認 |
| [MailingList](archive/MailingList.md) | アーカイブ ✅ | ML は QuickML の仕様で消滅済みと明記されている。歴史的記録 |
| [ProjectResources](ProjectResources.md) | 統合 | ML 前提の古い内容。生きている情報（サイト URL・リポジトリ）は README/CONTRIBUTING.md にあるため実質不要 |

### ツール文書（bitclust リポジトリへ）

| ページ | 提案 | 理由・備考 |
|--------|------|-----------|
| BitClust | 移動 ✅ | [bitclust/doc/](https://github.com/rurema/bitclust/tree/master/doc) へ移動。コマンド例の鮮度確認は移動先で |
| BitClustDatabase | 移動 ✅ | 同上。内容が現行実装と合っているか要確認 |

### リリース・運用

| ページ | 提案 | 理由・備考 |
|--------|------|-----------|
| [HowToRelease](HowToRelease.md) | 部分更新 | gem リリース手順（2020年）。Markdown 対応 gem のリリースが残タスクなので、実施時に手順を検証して更新 |
| [ReleasePackageHowTo](archive/ReleasePackageHowTo.md) | アーカイブ ✅ | パッケージ版（refe2 同梱）の使い方（2017年）。現在の配布実態と乖離 |
| [ReleasedProducts](ReleasedProducts.md) | 部分更新 | 配布物一覧。doc.okkez.net 等の古いリンクを整理し、docs.ruby-lang.org 中心に |
| ReleaseProcess | 削除 ✅ | 空ページ（TODO のまま） |

### 歴史文書（アーカイブ）

いずれも初期フェーズ（〜2010年代前半）の計画・体制の記録。内容は現体制と乖離しているが、
プロジェクト史として価値があるため [`docs/archive/`](archive/) に移して凍結した（✅ 実施済み）。

| ページ | 備考 |
|--------|------|
| [Phase1WorkingScheme](archive/Phase1WorkingScheme.md) | 第一段階の進め方 |
| [Phase2WorkingScheme](archive/Phase2WorkingScheme.md) | 第二段階の進め方（381行） |
| [Phase3WorkingScheme](archive/Phase3WorkingScheme.md) | 第三段階の進め方 |
| [Phase3ReviewProcess1](archive/Phase3ReviewProcess1.md) | 第三段階のレビュー手順 |
| [ProjectTimeLine](archive/ProjectTimeLine.md) | 〜2018年の年表。むしろ追記して維持する選択肢も |
| [WorkingProcess](archive/WorkingProcess.md) | 作業マニュアルへのリンク集（リンク先の大半がアーカイブ対象） |
| [MaintenancePhase](archive/MaintenancePhase.md) | メンテナンスフェイズ構想。Subversion・ファイル別メンテナ制前提で現体制と別物 |
| [DischargingProcess](archive/DischargingProcess.md) | 担当交代の手順。ASSIGN ファイル前提の旧体制 |

### メタ・その他

| ページ | 提案 | 理由・備考 |
|--------|------|-----------|
| [Home](Home.md) | 統合 | wiki のトップページ。この README が後継となるため、リンク先整理後に削除 |
| ProjectGoal | 削除 ✅ | 空ページ。目標は CONTRIBUTING.md に記載済み |
| Committers | 削除 ✅ | 空ページ |
| [License](License.md) | 部分更新 | リンク2行。`refm/doc/license.rd` → `manual/doc/license.md` に更新 |
| SitePolicy | 削除 ✅ | wiki の編集権限ポリシー。リポジトリ移行後は PR ベースになるため不要 |
| [ThirdPartyTools](ThirdPartyTools.md) | 維持 | 外部ツール事例集。リンク切れ確認は任意（rurema-search の行はサービス終了を反映） |
| HowToInstallRubys | 削除 ✅ | 複数 Ruby の環境構築（2017年、rbenv/古い Windows 前提）。現在は外部資料が充実しており、本リポジトリの検証環境も mise.toml で完結 |
| HowToInstallRubysUnixRbenv | 削除 ✅ | 同上 |
| HowToInstallRubysWindows | 削除 ✅ | 同上 |

## 今後の手順

1. ~~この一覧の内容について合意を取る~~（✅ #3037）
2. ~~削除・アーカイブ・bitclust への移動を実施~~（✅ このPRと bitclust 側 PR）
3. 残すページの wiki リンク（`[[PageName]]` 形式）を相対リンクに変換し、
   区分に応じて書き直し・更新
4. wiki 側の各ページを新 URL への案内スタブに置き換え（GitHub wiki はリダイレクト不可のため）
5. 周知期間の後、wiki を無効化
