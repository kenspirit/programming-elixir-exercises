fizz_buzz = fn
  0, 0, _ -> "FizzBuzz."
  0, _, _ -> "Fizz."
  _, 0, _ -> "Buzz."
  _, _, a -> a
end

fizz_buzz_rem = fn
  n -> IO.puts "Result of param #{n}: #{fizz_buzz.(rem(n, 3), rem(n, 5), n)}"
end


IO.puts "Calling fizz_buzz.(rem(n, 3), rem(n, 5), n) with param: "
IO.puts ""
fizz_buzz_rem.(10)
fizz_buzz_rem.(11)
fizz_buzz_rem.(12)
fizz_buzz_rem.(13)
fizz_buzz_rem.(14)
fizz_buzz_rem.(15)
fizz_buzz_rem.(16)
