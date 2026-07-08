# module Base64::Deprecated

後方互換性を維持する目的で、 [c:Base64] モジュールに定義された各種の
モジュール関数を [c:Kernel] モジュールに include するために存在するモ
ジュールです。通常、ユーザが利用することはありません。また、将来的に廃
止される可能性があります。

## Module Functions

### module_function def decode64(str) -> String

[m:Base64?.decode64] と同じです。

### module_function def encode64(str) -> String

[m:Base64?.encode64] と同じです。

### module_function def decode_b(str) -> String

[m:Base64?.decode_b] と同じです。

### module_function def b64encode(bin, len = 60) -> ()

[m:Base64?.b64encode] と同じです。

