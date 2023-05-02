#!/usr/bin/env ruby

require 'date'
require 'optparse'

opt = OptionParser.new
params = {}
opt.on('-y [VAL]') { |v| params[:y] = v.to_i } # オプション「-y」「-m」で指定された数をparamsに取得する
opt.on('-m [VAL]') { |v| params[:m] = v.to_i }
opt.parse!(ARGV)

if params[:y] == nil #オプションで指定された場合の値、もしくは今日の値を代入する
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

dates = Enumerator.new do |y| 
  (Date.new(year, month, 1)..Date.new(year, month, -1)).each { |i| y << i } #1日から月末日までの日付が入ったEmumeratorクラスを作る
end

dates.each do |date| 
  date.cwday.times { print '   ' } if date.day == 1 && date.cwday!= 7 # 1日かつ日曜日以外だった場合、曜日の数だけ空白を入れる  
  if date.day == day
    print "\e[30m\e[47m \e[0m" if date.day < 10  # 今日があった場合、色を反転させる
    print "\e[30m\e[47m#{date.day}\e[0m "
  else
    print ' ' if date.day < 10 
    print "#{date.day} "
  end
  print "\n" if date.saturday?  
end

puts "\n"
