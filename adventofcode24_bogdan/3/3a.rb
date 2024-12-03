input = File.read("input.txt")

i = 0
str = ""

sum = 0

class String
  def numeric?
    Float(self) != nil rescue false
  end
end

while i != input.length
  arr = []
  str2 = ""
  str += input[i]
  if str == "mul("
    i += 1
    while input[i] != ")" 
      p str
      if input[i].numeric? == true || input[i] == ","   
        str2 += input[i]
      else 
        break 
      end
      i+=1
      if input[i] == ")"
        arr = str2.split(",")
        sum += arr[0].to_i * arr[1].to_i
      else 
        next
      end
    end
    

  elsif str.length > 3 
    str = ""
  end
  i += 1
end

p sum





