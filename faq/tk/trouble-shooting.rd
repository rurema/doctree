= 9. トラブルシューティング

== 9.1 

  #!/usr/bin/env ruby
  
  require 'tk'
  
  for i in [0, 1, 2]
    p defined?(i)
    TkButton.new {
      text "Button #{i}"
      command { puts "click Button #{i}!!" }
      pack
    }
  end
  
  Tk.mainloop

以下のように記述すれば、意図通りに動くでしょう。
  #!/usr/bin/env ruby
  
  require 'tk'
  
  #i = 1
  
  [0, 1, 2].each do |i|
    p defined?(i)
    TkButton.new {
      text "Button #{i}"
      command { puts "click Button #{i}!!" }
      pack
    }
  end
  
  Tk.mainloop

#ただし、この記述でもコメントアウトされている変数 ((|i|)) のを

== 9.2 

以下のように記述したところ、エラーが起きてうまく動きません。
  #!/usr/bin/env ruby
  
  require "tk"
  
  class App
    def initialize
      TkButton.new {
        text "Push Me!"
        #command { p self }
        command { push }
        pack
      }
      Tk.mainloop
    end
  
    def push
      puts "push!"
    end
  end
  
  App.new


うまくいく例
  #!/usr/bin/env ruby
  
  require "tk"
  
  class App
    def initialize
      b = TkButton.new
      b.text "Push Me!"
      #b.command { p self }
      b.command { push }
      b.pack
      Tk.mainloop
    end
  
    def push
      puts "push!"
    end
  end
  
  App.new
