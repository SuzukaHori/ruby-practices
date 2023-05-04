#!/usr/bin/env ruby
numbers = []
number = 1

while number <= 20
  if number % 15 == 0
    numbers << "FizzBuzz"
  elsif number % 3 == 0
    numbers << "Fizz"
  elsif number % 5 == 0
    numbers << "Buzz"
  else 
    numbers << number
  end
  number += 1
end

puts numbers
