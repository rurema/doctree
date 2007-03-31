特殊変数 $! などに英語名の別名 ($ERROR_INFO など)をつけます。

例:

  p $/  #=> "\n"
  p $RS #=> nil

  require 'English'
  p $RS #=> "\n"



= reopen Kernel

== Special Variables

--- $ERROR_INFO

[[m:$!]] の別名

  require "English"
  class SomethingError < StandardError; end

  begin
    raise SomethingError 
  rescue
    p $ERROR_INFO.backtrace #=> ["sample.rb:5"]
    p $ERROR_INFO.to_s #=> "SomethingError"
  end

--- $ERROR_POSITION

[[m:$@]] の別名

  require "English"
  class SomethingError < StandardError; end

  begin
    raise SomethingError
  rescue
    p $ERROR_POSITION #=> ["sample.rb:5"]
  end

--- $LOADED_FEATURES

[[m:$"]] の別名

  require "English"
  require "find"

  p $LOADED_FEATURES #=> ["English.rb", "find.rb"]

--- $FS
--- $FIELD_SEPARATOR

[[m:$;]] の別名

  require "English"

  str = "hoge,fuga,ugo,bar,foo"
  p str.split #=> ["hoge,fuga,ugo,bar,foo"]
  $FIELD_SEPARATOR = ","
  p str.split #=> ["hoge", "fuga", "ugo", "bar", "foo"]

--- $OFS
--- $OUTPUT_FIELD_SEPARATOR

[[m:$,]] の別名

  require "English"

  array = %w|hoge fuga ugo bar foo|
  p array.join #=> "hogefugaugobarfoo"
  $OUTPUT_FIELD_SEPARATOR = ","
  p array.join #=> "hoge,fuga,ugo,bar,foo"

--- $RS
--- $INPUT_RECORD_SEPARATOR

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


--- $ORS
--- $OUTPUT_RECORD_SEPARATOR

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

--- $INPUT_LINE_NUMBER
--- $NR

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

--- $LAST_READ_LINE

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
  
--- $DEFAULT_OUTPUT

[[m:$>]] の別名
 
  require "English"

  dout = $DEFAULT_OUTPUT.dup
  $DEFAULT_OUTPUT.reopen("out.txt", "w")
  print "foo"
  $DEFAULT_OUTPUT.close
  $DEFAULT_OUTPUT = dout
  p "bar" # => bar
  p File.read("out.txt") #=> foo

--- $DEFAULT_INPUT

[[m:$<]] の別名
  
  require "English"
  while line = $DEFAULT_INPUT.gets
    p line
  end
  # end of sample.rb

  ruby sample.rb < /etc/passwd 
  # => "hoge:x:500:501::/home/hoge:/bin/bash\n"
       ...

--- $PID
--- $PROCESS_ID
#@todo

[[m:$$]] の別名

--- $CHILD_STATUS
#@todo

[[m:$?]] の別名

--- $LAST_MATCH_INFO
#@todo

[[m:$~]] の別名

--- $IGNORECASE
#@todo

[[m:$=]] の別名

--- $PROGRAM_NAME
#@todo

[[m:$0]] の別名

--- $ARGV

[[m:$*]] の別名

  require "English"
  p $ARGV
  # end of sample.rb
  
  ruby sample.rb 31 /home/hoge/fuga.txt
  #=> ["31", "/home/hoge/fuga.txt"]

--- $MATCH
#@todo

[[m:$&]] の別名

--- $PREMATCH
#@todo

[[m:$`]] の別名

--- $POSTMATCH
#@todo

[[m:$']] の別名

--- $LAST_PAREN_MATCH
#@todo

[[m:$+]] の別名
