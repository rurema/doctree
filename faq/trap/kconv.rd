= trap::Kconv
* 内部でNKFを使用しています。((<trap::NKF>))も参照してください。

MIME をデコードします。

  $ ruby -rkconv -e 'p Kconv.tosjis("=?ISO-2022-JP?B?Zm9v?=")' 
  "foo"

この動作が望ましくない場合は、以下のように NKF.nkf を直接使って下さい。

  $ ruby -rkconv -e 'p NKF.nkf("-s -m0", "=?ISO-2022-JP?B?Zm9v?=")'
  "=?ISO-2022-JP?B?Zm9v?="
