= VMS

VAX や Alpha のOS。今は OpenVMS と呼ぶらしい。ruby のソースでは、ただ 
1 箇所 ruby.c に

    #ifdef VMS
        uid |= gid << 16;
        euid |= egid << 16;
    #endif

という記述が存在する。(と書いた途端に version 1.7 でパッチが取り込まれ
た。まともに対応されつつあるようです)

1.8.1からバイナリが公開されています。
[[url:http://www.geocities.jp/vmsruby/]] を参照。

[[url:http://www.openvms.compaq.com/]] を参照。

以下も参照

[[url:http://www.levitte.org/~ava/index.htmlx]]

[[url:http://www.montagar.com/hobbyist/]]
