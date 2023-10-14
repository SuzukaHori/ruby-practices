#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require_relative './list_command'

list_command = ListCommand.new(ARGV)

if list_command.options[:l]
  formatted_details = list_command.build_file_details
  puts "total #{list_command.total}"
  formatted_details.each do |detail|
    detail.each { |content| print content }
    puts
  end
else
  formatted_files = list_command.format_file_names
  formatted_files.each do |block|
    block.each { |file| print file }
    puts
  end
end
