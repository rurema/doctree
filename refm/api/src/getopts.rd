getopts

                                          Author: <jammy@shljapan.co.jp>

Note: Ruby 1.8.2 以降では、getopts は推奨されません。
引数の解析には、[[lib:OptionParser]] の利用を推奨します。

オプションを解析し、$OPT_xxx に値を設定します。

典型的な使い方は以下のようになります。

  require 'getopts'
  
  unless getopts('vh', 'version', 'help')
    abort "usage: #$0 [-vh] [--version] [--help] file"
  end
  
  if $OPT_v or $OPT_version
    puts VERSION_STRING
    exit
  end
  
  # ARGV からオプションは取り除かれる。
  
  while line = ARGF.gets
    # ...
  end


== Private Instance Methods

--- getopts(single_opts, *long_opts)

  * 第一引数
    `-f' や `-x(=-fx)' の様な一文字のオプションの指定をします。オプショ
    ンが `-f' と `-x' の2つの場合は `"fx"' の様に指定します。ここでオプシ
    ョンがないときは必ず `nil' を指定して下さい。
#@if (version >= "1.6.8")
#@# ((<ruby 1.6 feature>)):
#@# (おそらく 1.6.8 から)第二引数と同じようにオプションの値が指定できるこ
#@# とを意味する : を指定できるようになりました。初期値は指定できません
#@end
  * 第二引数
    ロングネームのオプションや、引数を伴うオプションの指定をします。
    `--version' や `--geometry 300x400'、`-d host:0.0' 等がこれに該当し
    ます。引数を伴う指定は ":" を必ず付ける様にします。この例の場合、
    "version"、"geometry:"、"d:" の様になります。 また、オプションを
    指定しなかった場合のデフォルトの値を持たせたい場合は、":" の直後に
    そのデフォルト値を指定します。例えば、"geometry:80x25" の様になり
    ます。
#@if (version >= "1.6.8")
#@# ((<ruby 1.6 feature>)):
#@# (おそらく 1.6.8 から)ロングネームなオプションの値は --foo=bar のように
#@# = を間に挟んで値を指定できるようになりました。
#@end

オプション解析:

解析結果は全て "$OPT_指定した引数名" という形で処理されます。

  * シングルオプションや引数を伴わないオプションが使用された場合は、
    `true' がセットされます。

  `-f'→`$OPT_f = true' `--version'→`$OPT_version = true'

  * その他はそのオプションの引数がセットされます。

  `-d pengo:0.0'→`$OPT_d = pengo:0.0' `--geometry 80x25'→
  `$OPT_geometry = 80x25'

  * `-' もしくは `--' を指定した場合、それ以降の解析を行ないません。

戻り値:

実際にセットされたオプションの数を返します。また、間違ったオプショ
ンを指定した場合は、`nil' を返します。
