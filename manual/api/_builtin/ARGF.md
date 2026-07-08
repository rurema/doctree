---
library: _builtin
---
# object ARGF < ARGF.class

スクリプトに指定した引数
([m:Object::ARGV] を参照) をファイル名とみなして、
それらのファイルを連結した 1 つの仮想ファイルを表すオブジェクトです。
ARGV が空なら標準入力を対象とします。
ARGV を変更すればこのオブジェクトの動作に影響します。

```ruby
while line = ARGF.gets
  # do something
end
```

は、

```ruby
while argv = ARGV.shift
  File.open(argv) {|file|
    while line = file.gets
      # do something
    end
  }
end
```

のように動作します。

ARGF を処理するごとに ARGV の要素は一つずつ取り除かれます。
最後まで ARGF を読み込んだ後、再度 ARGF から内容を読むと
(ARGV が空なので)標準入力からの読み込みとなります。

```ruby
ARGV.replace %w(/tmp/foo /tmp/bar)
ARGF.each {|line|
    # 処理中の ARGV の内容を表示
    p [ARGF.filename, ARGV]
    ARGF.skip
}
    # => ["/tmp/foo", ["/tmp/bar"]]
    #    ["/tmp/bar", []]
# 最後まで読んだ後 (ARGV が空) の動作
p ARGF.gets      # => nil
p ARGF.filename  # => "-"
```

[m:Kernel?.gets] など一部の組み込み関数は
ARGF.gets などこのオブジェクトをレシーバとしたメソッドの省略形です。

また、ARGF は [c:ARGF.class] クラスのインスタンスです。
各メソッドの詳細は [c:ARGF.class] を参照してください。

別名として [m:$<] でも ARGF と同じオブジェクトにアクセスできます。

### インプレースエディットモード {#inplace}

インプレースエディット (in-place edit) モードは Ruby のコマンドライン引数に指定されたファイルの内容を置き換えます。

コマンドラインオプションで -i を指定すると Ruby はこのモードで動作します。
また [m:ARGF.class#inplace_mode=] を使用して起動後にモードに入ることも出来ます。

このモードで動作中は [m:$stdout] が処理対象への書き出しストリームで置き換えられます。
実行例は [ref:d:spec/rubycmd#cmd_option] や [m:ARGF.class#inplace_mode=] を参照してください。

