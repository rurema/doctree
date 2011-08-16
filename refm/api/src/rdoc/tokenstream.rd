A TokenStream is a list of tokens, gathered during the parse of some
entity (say a method). Entities populate these streams by being
registered with the lexer. Any class can collect tokens by including
TokenStream. From the outside, you use such an object by calling the
start_collecting_tokens method, followed by calls to add_token and
pop_token

= module TokenStream

ライブラリの内部で使用します。
