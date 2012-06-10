###nonref

= Mac

Mac 版の ruby の開発は止まってるらしい。[[d:platform/MacOSX]] ではそのまま 
ruby をコンパイルできるらしい。
Mac のディレクトリセパレータは、":" らしい。OSXでは、"/"で指定しても通るようだ。テキストファイルの行末コー
ドは CR らしい（通常CRのみです）。デバイスファイルは存在しないらしい・・・

HFS/HFS+ではパス区切りはコロンを使います([[url:http://www.senko-corp.co.jp/alsoft/Askal2001/AskalBody_04.27.01.htm]])。改行コードは通常はCRのみです。Mac OS XではUNIXの世界も入り込んでいるので、古いライブラリで改行コードをCRに決め打ちしているものは正常に動かないこともあります。Mac OS Xの大抵のテキストエディタはCRでもCR+LFでもLFのみでも正しく改行されるようです。デバイスファイルは旧Mac OSには存在しません。RubyのコンパイルはMac OS XではDeveloper Toolをインストールしておけば通るはずです（コンパイラフラグにCFLAGS = -g -O2 -pipe -fno-common -no-cpp-precompと、-no-cpp-precompが必要になるかも知れません）。
