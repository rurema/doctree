パーサジェネレータ Racc のランタイムライブラリです。

= class Racc::Parser

== Class Methods

--- racc_runtime_type

== Private Instance Methods

--- next_token

--- do_parse

--- yyparse(recv, mid)

--- yyerror

--- yyerrok

--- yyaccept

--- on_error(t, val, vstack)

--- token_to_str(t)


= class Racc::ParseError < StandardError
#@# alias ParseError
