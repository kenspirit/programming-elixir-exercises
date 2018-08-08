prefix = fn p ->
  fn n -> "#{p} #{n}" end
end

mrs = prefix.("Mrs")

IO.puts mrs.("Smith")
