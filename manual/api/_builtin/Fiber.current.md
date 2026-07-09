#@since 1.9.0
### def current -> Fiber

このメソッドが評価されたコンテキストにおける [c:Fiber] のインスタンスを返します。

```ruby title="例:"
fr = Fiber.new do
 Fiber.current
end

fb = fr.resume
p fb.equal?(fr) # => true

p Fiber.current # => #<Fiber:0x91345e4>
p Fiber.current # => #<Fiber:0x91345e4>
```

#@end
