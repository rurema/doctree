###nonref

= Mac OS X

X は 10 の意。マックオーエステンと読むのが正しいのか、マックオーエスエッ
クスと読むのが正しいのかはわからない。決して Mac で X Window System を
使えるようにするためのものではない(おそらく)。

マックオーエステンが正しいそうです。X Window Systemは純正の環境([[url:http://www.apple.co.jp/macosx/features/x11/index.html]]がありますが、あまり詳しくない人には使い勝手はよくありません。したがってデベロッパがX向けに何かを作ってもたぶん多くの人には見向きされません。Rubyを始めとしてBSDでも動くものは比較的手軽（デフォルトインストールでTerminalが入っています）に使うことができます。

RubyのコンパイルはMac OS XではDeveloper Toolをインストールしておけば通るはずです（コンパイラフラグにCFLAGS = -g -O2 -pipe -fno-common -no-cpp-precompと、-no-cpp-precompが必要になるかも知れません）。また、Mac OS X 10.3ではrubyが標準で添付されています。
