fun = fn -> IO.puts(Enum.join(File.ls!, ",")) end

Node.spawn(:"node_one@CHENKE2-W10", fun)

# Result printed is the file/directory in the remote node
