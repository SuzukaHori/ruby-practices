#!/usr/bin/env ruby

require "date"
require "optparse"

opt = OptionParser.new
params = {}
opt.on("-y [VAL]") { |v| params[:y] = v.to_i }
opt.on("-m [VAL]") { |v| params[:m] = v.to_i }
opt.parse!(ARGV)

year =
  if params[:y] == nil
    Date.today.year
  else
    params[:y]
  end
month =
  if params[:m] == nil
    Date.today.month
  else
    params[:m]
  end
day = Date.today.day if year == Date.today.year && month == Date.today.month

puts "#{month}月 #{year}".center(19)
puts "日 月 火 水 木 金 土"

if Date.new(year, month, 1).cwday != 7
  Date.new(year, month, 1).cwday.times { print "   " }
end

(Date.new(year, month, 1)..Date.new(year, month, -1)).each do |date|
  if date.day == day
    print "\e[7m", "#{date.day}".rjust(2, " ")
    print "\e[m "
  else
    print "#{date.day}".rjust(2, " ")
    print " "
  end
  print "\n" if date.saturday?
end

puts "\n"
