print = fn t -> IO.puts "\n" <> t end

:io.format("~.*.0f~n", [2, 2143.4])

print.(System.get_env("path"))

print.(Path.extname("dave/test.exs"))

print.(System.cwd())

# Convert a string containing JSON into Elixir data structures.
# Best I can find
print.(inspect(Code.eval_string("a = [1, 2, 3, 4] ")))

# Windows sucks.  The way to call internal command
print.(inspect(System.cmd("cmd.exe", ["/c", "echo", "hello"])))

