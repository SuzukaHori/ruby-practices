#!/usr/bin/env ruby
array_of_numbers = []
number = 1

while number <= 20
  if number % 15 == 0
    array_of_numbers << "FizzBuzz"
  elsif number % 3 == 0
    array_of_numbers << "Fizz"
  elsif number % 5 == 0
    array_of_numbers << "Buzz"
  else 
    array_of_numbers << number
  end
  number += 1
end

puts array_of_numbers
