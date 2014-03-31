「Ruby リファレンスマニュアル刷新計画」のリリース手順の説明です。

## リリースするものとそのファイル名

| リリース物 | ファイル名(案) |
|------------|----------------|
| パッケージ版 | ruby-refm-x.y.z-dynamic.tar.gz, zip, tar.bz2 |
| chm版        | ruby-refm-x.y.z-chm.zip |
| web版 | http://doc.loveruby.net/refm/api/ |
| 静的html版 (将来的に) | rubyrefm-x.y.z-html.tar.gz |
| info版 (将来的に) | rubyrefm-x.y.z-info.tar.gz |

## リリース手順
仮のリリース手順を書いておきます。今回のリリースが終わったら、それを振り返りつつ追記してください。

1. リリース物を作る(後述)
1. リリースのアナウンス文を書く
1. アナウンス文のレビュー (ML にて)((-省略可-))
1. Git レポジトリにリリースタグを打つ
1. リリースパッケージを作ってサイトに置く
1. ruby-list にリリースのアナウンス
1. ruby-lang.org にリリースのアナウンス

## リリース物の作り方

### パッケージ版
まず bitclust と doctree を git clone しておきます。clone 済みの場合は git pull --rebase で最新にします。

```
$ git clone https://github.com/rurema/bitclust.git
$ git clone https://github.com/rurema/doctree.git
```

Windows環境の場合はexerbと7-zip32.dllとtar32.dllを入れておきます。
Windows以外の環境の場合は7za,zip,tar,gzip,bzip2を入れておきます。

```
$ ruby bitclust/packer.rb --output-dir="ruby-refm-2.0.0-dynamic-snapshot"
```

を実行すると ruby-refm-2.0.0-dynamic-snapshot.tar.bz2, ruby-refm-2.0.0-dynamic-snapshot.tar.gz, ruby-refm-2.0.0-dynamic-snapshot.zip が作成されます。

Windows以外の環境の場合はあらかじめexerbで作成したserver.exeとserver.exyを用意しておき、--output-dirに指定するディレクトリに入れておくとアーカイブに含めることができます。

リリースしたファイルの置き場所は http://www.ruby-lang.org/ja/man/archive/ と ftp.ruby-lang.org/pub/ruby/doc/ です。

最後に、git tag でタグを打っておきます。

### chm版
まずbc-tochm.rbでdbからchm用の素材を作ります(ここまではOS非依存)。

```
$ ruby bc-tochm.rb -d ./db -o ./chm
```

次に、MicrosoftのHTML Help Workshopでchmファイルにまとめます(Windowsかwineが必要)。((-2013-08-29現在ではHTML Help Workshopは手に入らない-))

```
$ hhc.exe ./chm/refm.hhp
```

これで ./chm/refm.chm が作成できます。
