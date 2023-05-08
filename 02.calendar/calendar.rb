#!/usr/bin/env ruby

require 'date'
require 'optparse'

opt = OptionParser.new
params = {}
opt.on("-y [VAL]") { |v| params[:y] = v.to_i }
opt.on("-m [VAL]") { |v| params[:m] = v.to_i }
opt.parse!(ARGV)

if params[:y] == nil
  year = Date.today.year
else
  year = params[:y]
end
if params[:m] == nil
  month = Date.today.month
else
  month = params[:m]
end
day = Date.today.day if year == Date.today.year && month == Date.today.month

puts "#{month}月 #{year}".center(19)
puts '日 月 火 水 木 金 土'

(Date.new(year, month, 1)..Date.new(year, month, -1)).each do |date|
  date.cwday.times { print "   " } if date.day == 1 && date.cwday != 7
  if date.day == day
    print "\e[30m\e[47m \e[0m" if date.day < 10
    print "\e[30m\e[47m#{date.day}\e[0m "
  else
    print "#{date.day}".rjust(2, " ")
    print " "
  end
  print "\n" if date.saturday?
end

puts "\n"
