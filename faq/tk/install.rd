= はじめの一歩

他の ruby スクリプトと同じように書き始めます。 例えば、

  #!/usr/local/bin/ruby

とか。一番簡単な "こんにちは" を表示するスクリプトはこう書けます。


    #!/usr/local/bin/ruby

    require "tk"

    TkLabel.new {
      text 'こんにちは'
    }.pack

    TkButton.new {
      text '終了'
      command 'exit'
    }.pack

    Tk.mainloop


別の書き方をすると、 


    #!/usr/local/bin/ruby

    require "tk"

    TkLabel.new {
      text 'こんにちは'
      pack
    }

    TkButton.new {
      text '終了'
      command 'exit'
      pack
    }

    Tk.mainloop

こんな風にも書けます。

    #!/usr/local/bin/ruby

    require "tk"

    TkLabel.new (Tk.root, 'text' => 'こんにちは').pack
    TkButton.new (Tk.root, 'text' => '終了', 'command' => 'exit').pack

    Tk.mainloop

