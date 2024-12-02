input = File.read("input.txt")
input = input.split("\n")


input.each_with_index do |element, index|
  input[index] = element.split(" ")
end

def checkIncrease(arr1)
  arr = arr1.dup
  used = false
  arr.each_with_index do |element, index|
    if (arr[index+1].to_i - arr[index].to_i < 4 ) && (arr[index+1].to_i - arr[index].to_i > 0) || arr[index+1] == nil 
      next
    else
      if used == true 
        return false
        break 
      end
      if index == arr.length-2 && used != true
        if arr[index].to_i - arr[index-1].to_i < 4 && arr[index].to_i - arr[index-1].to_i > 0
          return true
        end
      end

      if index == 0 && used != true
        if arr[index+2].to_i - arr[index+1].to_i < 4 && arr[index+2].to_i - arr[index+1].to_i > 0 && arr[index+2] != nil
          arr.delete_at(index)
          used = true
          next
        end
      end
      if (arr[index+2].to_i - arr[index].to_i < 4 ) && (arr[index+2].to_i - arr[index].to_i > 0) && arr[index+2] != nil && used != true
        used = true
        arr.delete_at(index+1)
      else
        return false
      end
    end
  end
  return true
end

def checkDecrease(arr1)
  arr = arr1.dup
  used = false
  arr.each_with_index do |element, index|
    if (arr[index+1].to_i - arr[index].to_i > -4) && (arr[index+1].to_i - arr[index].to_i < 0) || arr[index+1] == nil
      next
    else 
      if used == true 
        return false
        break 
      end
      if index == arr.length-2 && used != true
        if arr[index].to_i - arr[index-1].to_i > -4 && arr[index].to_i - arr[index-1].to_i < 0
          return true
        end
      end

      if index == 0 && used != true
        if arr[index+2].to_i - arr[index+1].to_i > -4 && arr[index+2].to_i - arr[index+1].to_i < 0 && arr[index+2] != nil
          arr.delete_at(index)
          used = true
          next
        end
      end
      if (arr[index+2].to_i - arr[index].to_i > -4 ) && (arr[index+2].to_i - arr[index].to_i < 0) && arr[index+2] != nil && used != true
        used = true
        arr.delete_at(index+1)
      else
        return false
      end
    end
  end
  return true
end

sum = 0

input.each do |element|
  if checkIncrease(element) || checkDecrease(element)
    sum += 1
  end
end

p sum
