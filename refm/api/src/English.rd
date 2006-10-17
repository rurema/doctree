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

--- $ERROR_POSITION

[[m:$@]] の別名

--- $LOADED_FEATURES

[[m:$"]] の別名

--- $FS
--- $FIELD_SEPARATOR

[[m:$;]] の別名

--- $OFS
--- $OUTPUT_FIELD_SEPARATOR

[[m:$,]] の別名

--- $RS
--- $INPUT_RECORD_SEPARATOR

[[m:$/]] の別名

--- $ORS
--- $OUTPUT_RECORD_SEPARATOR

[[m:$\]] の別名

--- $INPUT_LINE_NUMBER
--- $NR

[[m:$.]] の別名

--- $LAST_READ_LINE

[[m:$_]] の別名

--- $DEFAULT_OUTPUT

[[m:$>]] の別名

--- $DEFAULT_INPUT

[[m:$<]] の別名

--- $PID
--- $PROCESS_ID

[[m:$$]] の別名

--- $CHILD_STATUS

[[m:$?]] の別名

--- $LAST_MATCH_INFO

[[m:$~]] の別名

--- $IGNORECASE

[[m:$=]] の別名

--- $PROGRAM_NAME

[[m:$0]] の別名

--- $ARGV

[[m:$*]] の別名

--- $MATCH

[[m:$&]] の別名

--- $PREMATCH

[[m:$`]] の別名

--- $POSTMATCH

[[m:$']] の別名

--- $LAST_PAREN_MATCH

[[m:$+]] の別名
