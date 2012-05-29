= 疑似BNFによるRubyの文法

以下に疑似BNFによるRubyの文法を示します。より詳しくは parse.y を
参照してください。sample/exyacc.rbを使うと規則だけを取り出せますので
活用しましょう。

((-このBNFはまだ完全に1.6対応していません。[[unknown:執筆者募集]]-))

  PROGRAM         : COMPSTMT

  COMPSTMT        : STMT (TERM EXPR)* [TERM]

  STMT            : CALL do [`|' [BLOCK_VAR] `|'] COMPSTMT end
                  | LHS `=' COMMAND [do [`|' [BLOCK_VAR] `|'] COMPSTMT end]
                  | alias FNAME FNAME
                  | undef (FNAME | SYMBOL)+
                  | STMT if EXPR
                  | STMT while EXPR
                  | STMT unless EXPR
                  | STMT until EXPR
                  | STMT rescue STMT
                  | `BEGIN' `{' COMPSTMT `}'
                  | `END' `{' COMPSTMT `}'
                  | EXPR

  EXPR            : MLHS `=' MRHS
                  | return CALL_ARGS
                  | EXPR and EXPR
                  | EXPR or EXPR
                  | not EXPR
                  | COMMAND
                  | `!' COMMAND
                  | ARG

  CALL            : FUNCTION
                  | COMMAND

  COMMAND         : OPERATION CALL_ARGS
                  | PRIMARY `.' FNAME CALL_ARGS
                  | PRIMARY `::' FNAME CALL_ARGS
                  | super CALL_ARGS
                  | yield CALL_ARGS

  FUNCTION        : OPERATION [`(' [CALL_ARGS] `)']
                  | PRIMARY `.' FNAME `(' [CALL_ARGS] `)'
                  | PRIMARY `::' FNAME `(' [CALL_ARGS] `)'
                  | PRIMARY `.' FNAME
                  | PRIMARY `::' FNAME
                  | super [`(' [CALL_ARGS] `)']

  ARG             : LHS `=' ARG
                  | LHS OP_ASGN ARG
                  | ARG `..' ARG
                  | ARG `...' ARG
                  | ARG `+' ARG
                  | ARG `-' ARG
                  | ARG `*' ARG
                  | ARG `/' ARG
                  | ARG `%' ARG
                  | ARG `**' ARG
                  | `+' ARG
                  | `-' ARG
                  | ARG `|' ARG
                  | ARG `^' ARG
                  | ARG `&' ARG
                  | ARG `<=>' ARG
                  | ARG `>' ARG
                  | ARG `>=' ARG
                  | ARG `<' ARG
                  | ARG `<=' ARG
                  | ARG `==' ARG
                  | ARG `===' ARG
                  | ARG `!=' ARG
                  | ARG `=~' ARG
                  | ARG `!~' ARG
                  | `!' ARG
                  | `~' ARG
                  | ARG `<<' ARG
                  | ARG `>>' ARG
                  | ARG `&&' ARG
                  | ARG `||' ARG
                  | defined? ARG
                  | PRIMARY

  PRIMARY         : `(' COMPSTMT `)'
                  | LITERAL
                  | VARIABLE
                  | PRIMARY `::' identifier
                  | `::' identifier
                  | PRIMARY `[' [ARGS] `]'
                  | `[' [ARGS [`,']] `]'
                  | `{' [(ARGS|ASSOCS) [`,']] `}'
                  | return [`(' [CALL_ARGS] `)']
                  | yield [`(' [CALL_ARGS] `)']
                  | defined? `(' ARG `)'
                  | FUNCTION
                  | FUNCTION `{' [`|' [BLOCK_VAR] `|'] COMPSTMT `}'
                  | if EXPR THEN
                    COMPSTMT
                    (elsif EXPR THEN COMPSTMT)*
                    [else COMPSTMT]
                    end
                  | unless EXPR THEN
                    COMPSTMT
                    [else COMPSTMT]
                    end
                  | while EXPR DO COMPSTMT end
                  | until EXPR DO COMPSTMT end
                  | case [EXPR]
                    (when WHEN_ARGS THEN COMPSTMT)+
                    [else COMPSTMT]
                    end
                  | for BLOCK_VAR in EXPR DO
                    COMPSTMT
                    end
                  | begin
                    COMPSTMT
                    [rescue [ARGS] [`=>' LHS] THEN COMPSTMT]+
                    [else COMPSTMT]
                    [ensure COMPSTMT]
                    end
                  | class identifier [`<' identifier]
                    COMPSTMT
                    end
                  | module identifier
                    COMPSTMT
                    end
                  | def FNAME ARGDECL
                    COMPSTMT
                    [rescue [ARGS] [`=>' LHS] THEN COMPSTMT]+
                    [else COMPSTMT]
                    [ensure COMPSTMT]
                    end
                  | def SINGLETON (`.'|`::') FNAME ARGDECL
                    COMPSTMT
                    end

  WHEN_ARGS       : ARGS [`,' `*' ARG]
                  | `*' ARG

  THEN            : TERM
                  | then
                  | TERM then

  DO              : TERM
                  | do
                  | TERM do

  BLOCK_VAR       : LHS
                  | MLHS

  MLHS            : MLHS_ITEM `,' MLHS_ITEM [(`,' MLHS_ITEM)*] [`,' `*' [LHS]]
                  | MLHS_ITEM `,' `*' [LHS]
                  | MLHS_ITEM [(`,' MLHS_ITEM)*] `,'
                  | `*' [LHS]
                  | `(' MLHS `)'

  MLHS_ITEM       : LHS
                  | '(' MLHS ')'

  LHS             : VARNAME
                  | PRIMARY `[' [ARGS] `]'
                  | PRIMARY `.' identifier

  MRHS            : ARGS [`,' `*' ARG]
                  | `*' ARG

  CALL_ARGS       : ARGS
                  | ARGS [`,' ASSOCS] [`,' `*' ARG] [`,' `&' ARG]
                  | ASSOCS [`,' `*' ARG] [`,' `&' ARG]
                  | `*' ARG [`,' `&' ARG]
                  | `&' ARG
                  | COMMAND

  ARGS            : ARG (`,' ARG)*

  ARGDECL         : `(' ARGLIST `)'
                  | ARGLIST TERM

  ARGLIST         : identifier(`,'identifier)*[`,'`*'[identifier]][`,'`&'identifier]
                  | `*'identifier[`,'`&'identifier]
                  | [`&'identifier]

  SINGLETON       : VARNAME
                  | self
                  | nil
                  | true
                  | false
                  | `(' EXPR `)'

  ASSOCS          : ASSOC (`,' ASSOC)*

  ASSOC           : ARG `=>' ARG

  VARIABLE        : VARNAME
                  | self
                  | nil
                  | true
                  | false
                  | __FILE__
                  | __LINE__

  LITERAL         : numeric
                  | SYMBOL
                  | STRING
                  | HERE_DOC
                  | WORDS
                  | REGEXP

  STRING          : LITERAL_STRING+

  TERM            : `;'
                  | `\n'

以下のものは字句解析機で解釈されます。

  OP_ASGN         : `+=' | `-=' | `*=' | `/=' | `%=' | `**='
                  | `&=' | `|=' | `^=' | `<<=' | `>>='
                  | `&&=' | `||='

  SYMBOL          : `:'FNAME
                  | `:'`@'identifier
                  | `:'`@@'identifier
                  | `:'GLOBAL

  FNAME           : OPERATION
                  | `|' | `^' | `&' | `<=>' | `==' | `===' | `=~'
                  | `>' | `>=' | `<' | `<='
                  | `+' | `-' | `*' | `/' | `%' | `**'
                  | `<<' | `>>' | `~' | ``'
                  | `+@' | `-@' | `[]' | `[]='
                  | __LINE__ | __FILE__  | BEGIN | END
                  | alias | and | begin | break | case | class | def
                  | defined | do | else | elsif | end | ensure | false
                  | for | if | in | module | next | nil | not
                  | or | redo | rescue | retry | return | self | super
                  | then | true | undef | unless | until | when
                  | while | yield

  OPERATION       : identifier
                  | identifier'!'
                  | identifier'?'

  VARNAME         : GLOBAL
                  | `@'identifier
                  | `@@'identifier
                  | identifier

  GLOBAL          : `$'identifier
                  | `$'any_char
                  | `$''-'any_char

  LITERAL_STRING  : `"' any_char* `"'
                  | `'' any_char* `''
                  | ``' any_char* ``'
                  | `%'(`Q'|`q'|`x')char any_char* char

  HERE_DOC        : `<<'(identifier|STRING)
                    any_char*
                    identifier
                  | `<<-'(identifier|STRING)
                    any_char*
                    space* identifier

  WORDS           : `%'`w'char any_char* char

  REGEXP          : `/' any_char* `/'[`i'|`m'|`x'|`o'|`e'|`s'|`u'|`n']
                  | `%'`r' char any_char* char
