fizz_buzz = fn
  0, 0, _ -> "FizzBuzz."
  0, _, _ -> "Fizz."
  _, 0, _ -> "Buzz."
  _, _, a -> a
end

fb_call = fn
  a, b, c -> IO.puts "Result of fizz_buzz.(#{a}, #{b}, #{c}): #{fizz_buzz.(a, b, c)}"
end

fb_call.(0, 0, 2)
fb_call.(0, 1, 2)
fb_call.(1, 0, 2)
fb_call.(1, 3, "Others")
