#!/usr/bin/env ruby
array = []
number = 1

while number <= 20
  if number%15 == 0
    array << "FizzBuzz"
  elsif number%3 == 0
    array << "Fizz"
  elsif number%5 == 0
    array << "Buzz"
  else 
    array << number
  end
  number += 1
end

puts array