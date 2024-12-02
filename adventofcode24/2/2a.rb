input = File.read("input.txt")

input = input.split("\n")

input.each_with_index do |element, index|
  input[index] = element.split(" ")
end

def checkIncrease(arr)
  arr.each_with_index do |element, index|

    if (arr[index+1].to_i - arr[index].to_i < 4 ) && (arr[index+1].to_i - arr[index].to_i > 0) || arr[index+1] == nil
      next
    else
      return false
    end
  end
  return true
end

def checkDecrease(arr)
  arr.each_with_index do |element, index|
    if (arr[index+1].to_i - arr[index].to_i > -4) && (arr[index+1].to_i - arr[index].to_i < 0) || arr[index+1] == nil
      next
    else 
      return false
    end
  end
  return true
end

sum = 0

input.each do |element|
  if checkIncrease(element) || checkDecrease(element)
    p element
    sum += 1
  end
end
