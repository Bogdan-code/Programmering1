inputs = File.open("penis.txt", "a")
input = gets.chomp
p "Du skrev#{input}"
inputs.puts(input)
inputs.close

inputs_arr = File.readlines("penis.txt")

p inputs_arr