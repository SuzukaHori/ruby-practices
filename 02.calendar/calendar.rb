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

puts "#{month}月 #{year}".center(19)
puts "日 月 火 水 木 金 土"

month_start_date = Date.new(year, month, 1)
month_start_date.cwday.times { print "   " } if month_start_date.cwday != 7

(month_start_date..Date.new(year, month, -1)).each do |date|
  formatted_day = date.day.to_s.rjust(2, " ")
  if date == Date.today
    print "\e[7m#{formatted_day}\e[m "
  else
    print "#{formatted_day} "
  end
  print "\n" if date.saturday?
end

puts "\n"
