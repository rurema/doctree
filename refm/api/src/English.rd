特殊変数 $! などに英語名の別名 ($ERROR_INFO など)をつけます。

例:

  p $/  #=> "\n"
  p $RS #=> nil

  require 'English'
  p $RS #=> "\n"



= reopen Kernel

== Special Variables

--- $ERROR_INFO -> Exception  | nil

[[m:$!]] の別名

  require "English"
  class SomethingError < StandardError; end

  begin
    raise SomethingError 
  rescue
    p $ERROR_INFO.backtrace #=> ["sample.rb:5"]
    p $ERROR_INFO.to_s #=> "SomethingError"
  end

--- $ERROR_POSITION -> [String] | nil

[[m:$@]] の別名

  require "English"
  class SomethingError < StandardError; end

  begin
    raise SomethingError
  rescue
    p $ERROR_POSITION #=> ["sample.rb:5"]
  end

--- $FS              -> String | nil
--- $FIELD_SEPARATOR -> String | nil

[[m:$;]] の別名

  require "English"

  str = "hoge,fuga,ugo,bar,foo"
  p str.split #=> ["hoge,fuga,ugo,bar,foo"]
  $FIELD_SEPARATOR = ","
  p str.split #=> ["hoge", "fuga", "ugo", "bar", "foo"]

--- $OFS                    -> String | nil
--- $OUTPUT_FIELD_SEPARATOR -> String | nil

[[m:$,]] の別名

  require "English"

  array = %w|hoge fuga ugo bar foo|
  p array.join #=> "hogefugaugobarfoo"
  $OUTPUT_FIELD_SEPARATOR = ","
  p array.join #=> "hoge,fuga,ugo,bar,foo"

--- $RS                     -> String | nil
--- $INPUT_RECORD_SEPARATOR -> String | nil

[[m:$/]] の別名

  require "English"

  $INPUT_RECORD_SEPARATOR = '|'
  array = []
  while line = DATA.gets
    array << line
  end
  p array #=> ["ugo|", "ego|", "fogo\n"]

  __END__
  ugo|ego|fogo


--- $ORS                     -> String | nil
--- $OUTPUT_RECORD_SEPARATOR -> String | nil

[[m:$\]] の別名

  require "English"

  print "hoge\nhuga\n"
  $OUTPUT_RECORD_SEPARATOR = "\n"
  print "fuge"
  print "ugo"
  # end of sample.rb

  ruby sample.rb 
  hoge
  huga
  fuge
  ugo

--- $INPUT_LINE_NUMBER -> Integer
--- $NR                -> Integer

[[m:$.]] の別名

  1 e
  2 f
  3 g
  4 h
  5 i
  # end of a.txt

  require "English"

  File.foreach(ARGV.at(0)){|line|
    # read line
  }
  p $INPUT_LINE_NUMBER
  # end of sample.rb

  ruby sample.rb a.txt 
  #=> 5

--- $LAST_READ_LINE -> String | nil

[[m:$_]] の別名
  
  1 e
  2 f
  3 g
  4 h
  5 i
  # end of a.txt

  ruby -rEnglish -ne'p $LAST_READ_LINE' a.txt
  #=> 
  "1 e\n"
  "2 f\n"
  "3 g\n"
  "4 h\n"
  "5 i\n"
  
--- $DEFAULT_OUTPUT -> IO

[[m:$>]] の別名
 
  require "English"

  dout = $DEFAULT_OUTPUT.dup
  $DEFAULT_OUTPUT.reopen("out.txt", "w")
  print "foo"
  $DEFAULT_OUTPUT.close
  $DEFAULT_OUTPUT = dout
  p "bar" # => bar
  p File.read("out.txt") #=> foo

--- $DEFAULT_INPUT -> IO

[[m:$<]] の別名
  
  require "English"
  while line = $DEFAULT_INPUT.gets
    p line
  end
  # end of sample.rb

  ruby sample.rb < /etc/passwd 
  # => "hoge:x:500:501::/home/hoge:/bin/bash\n"
       ...

--- $PID        -> Integer
--- $PROCESS_ID -> Integer

[[m:$$]] の別名
 
  require "English"

	p sprintf("something%s", $PID) #=> "something5543" など

--- $CHILD_STATUS -> Process::Status | nil

[[m:$?]] の別名

  require "English"

  out = `wget https://www.ruby-lang.org/en/about/license.txt -O - 2>/dev/null`

  if $CHILD_STATUS.to_i == 0
    print "wget success\n"
    out.split(/\n/).each { |line|
      printf "%s\n", line
    }
  else
    print "wget failed\n"
  end


--- $LAST_MATCH_INFO -> MatchData | nil

[[m:$~]] の別名

  require "English"

  str = "<a href=https://www.ruby-lang.org/en/about/license.txt>license</a>"

  if /<a href=(.+?)>/ =~ str
    p $LAST_MATCH_INFO[0] #=> "<a href=https://www.ruby-lang.org/en/about/license.txt>"
    p $LAST_MATCH_INFO[1] #=> "https://www.ruby-lang.org/en/about/license.txt"
    p $LAST_MATCH_INFO[2] #=> nil
  end

--- $IGNORECASE -> bool

過去との互換性のために残されていますが、もはや何の意味もありません。

値は常に false です。代入しても無視されます。

[[m:$=]] の別名

  require "English"

  $IGNORECASE = true # => warning: variable $= is no longer effective; ignored
  $IGNORECASE        # => warning: variable $= is no longer effective
                     #    false

--- $ARGV -> [String]

[[m:$*]] の別名

  require "English"
  p $ARGV
  # end of sample.rb
  
  ruby sample.rb 31 /home/hoge/fuga.txt
  #=> ["31", "/home/hoge/fuga.txt"]

--- $MATCH -> String | nil

[[m:$&]] の別名

  require "English"

  str = 'hoge,foo,bar,hee,hoo'

  /(foo|bar)/ =~ str
  p $MATCH     #=> "foo"

--- $PREMATCH -> String | nil

[[m:$`]] の別名

  require "English"

  str = 'hoge,foo,bar,hee,hoo'

  /foo/ =~ str
  p $PREMATCH  #=> "hoge,"

--- $POSTMATCH -> String | nil

[[m:$']] の別名

  require "English"

  str = 'hoge,foo,bar,hee,hoo'

  /foo/ =~ str
  p $POSTMATCH #=> ",bar,hee,hoo"

--- $LAST_PAREN_MATCH -> String | nil

[[m:$+]] の別名

  require "English"

  r1 = Regexp.compile("<img src=(http:.+?)>")
  r2 = Regexp.compile("<a href=(http|ftp).+?>(.+?)</a>")

  while line = DATA.gets
    [ r1, r2 ].each {|rep|
      rep =~ line
      p $+
    }
  end
  __END__
  <tr> <td><img src=http://localhost/a.jpg></td> <td>ikkou</td> <td><a href=http://localhost/link.html>link</a></td> </tr>
  #enf of sample.rb

  $ ruby sample.rb
  "http://localhost/a.jpg"
  "link"
  


