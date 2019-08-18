category Obsolete

このライブラリは obsolete です。
[[lib:optparse]] を使ってください。

オプションを解析するためのライブラリです。
$OPT_xxx に値を設定します。

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

#@#Author: <jammy@shljapan.co.jp>

= reopen Kernel

== Private Instance Methods

--- getopts(single_opts, *long_opts)    -> Integer | nil

このメソッドは obsolete です。
[[lib:optparse]] ライブラリで提供されている
ARGV.getopts を使ってください。[[m:Object::ARGV]], [[m:OptionParser::Arguable#getopts]] を参照。

指定された short_opt や long_opt に応じて ARGV を解析し、
結果をそれぞれのグローバル変数にセットします。

実際にセットされたオプションの数を返します。
また、間違ったオプションを指定した場合は、nil を返します。

オプション解析:

解析結果は全て "$OPT_指定した引数名" という形で処理されます。

  * シングルオプションや引数を伴わないオプションが使用された場合は、
    `true' がセットされます。
//emlist{
      -f        → $OPT_f = true  
      --version → $OPT_version = true
//}
  * その他はそのオプションの引数がセットされます。
//emlist{
    -d pengo:0.0     → $OPT_d = pengo:0.0 
    --geometry 80x25 → $OPT_geometry = 80x25
//}
  * - もしくは -- を指定した場合、それ以降の解析を行ないません。

@param single_opts -f や -x の様な一文字のオプションの指定をします。オプショ
                   ンが -f と -x の2つの場合は "fx" の様に指定します。ここでオプシ
                   ョンがないときは必ず nil を指定して下さい。

@param long_opts  ロングネームのオプションや、引数を伴うオプションを文字列で指定をします。
                  --version や --geometry 300x400、-d host:0.0 等がこれに該当し
                  ます。引数を伴う指定は ":" を必ず付ける様にします。この例の場合、
                  "version"、"geometry:"、"d:" の様になります。 また、オプションを
                  指定しなかった場合のデフォルトの値を持たせたい場合は、":" の直後に
                  そのデフォルト値を指定します。例えば、"geometry:80x25" の様になり
                  ます。
