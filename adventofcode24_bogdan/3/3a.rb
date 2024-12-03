input = File.read("input.txt")

i = 0
str = ""
doing = true
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
  if str == "mul(" && doing == true
    i += 1
    while input[i] != ")" 
      if input[i].numeric? == true || input[i] == ","   
        str2 += input[i]
      else 
        break 
      end
      i+=1
      if input[i] == ")"
        arr = str2.split(",")
        p arr
        sum += arr[0].to_i * arr[1].to_i
      else 
        next
      end
    end
  elsif str.length > 3  
    if str == "do()"
      doing = true
    elsif str + input[i+1]+input[i+2]+input[i+3] == "don't()"
      doing = false
    end
    i -= 3
    str = ""
  end
  i += 1
end

p sum





