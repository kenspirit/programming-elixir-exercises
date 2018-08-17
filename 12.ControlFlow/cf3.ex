ok! = fn
  {:ok, d} -> d
  d -> raise RuntimeError, message: inspect d
end

file = ok!.(File.open("./non-existed.txt"))
