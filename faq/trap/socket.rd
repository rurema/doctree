= Socket

* IPSocketで接続相手の情報はaddrではなくpeeraddr。
  アクセス制限でpeeraddrのつもりでaddrをチェックしていたら全く意味がない。
  localhostだけでテストしていたら気がつかないので注意。(例:((<ruby-list:27291>)) )
