require_relative 'C:\Users\bogdan.tarasov\Documents\programering1\Lektion1\lib\uppgifter.rb'

a = File.read("input.txt")
a = a.split("\n")
b = []
rightList = []
leftList = []

a.each do |element|
  c = element.split("   ")
  c[0] = c[0].to_i
  c[1] = c[1].to_i

  b += c
end
b.each_with_index do |element, index|
  if index == 0 || index % 2 == 0
    leftList << element
  else 
    rightList << element
  end
end

rightList = rightList.sort
leftList = leftList.sort
sum = 0

# leftList.each_with_index do |element, index|
#   distance = biggest_of_two(element, rightList[index]) - smallest_of_two(element, rightList[index])
#   sum += distance
# end
leftList.each do |element|
  sum += element * contains(rightList, element)
end

p sum