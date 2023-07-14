#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main
  options = parse_options
  file_details = (ARGV.empty? ? create_details_from_stdin : create_details_from_arguments)
  print_file_details(file_details, options)
end

def parse_options
  opt = OptionParser.new
  options = {}
  opt.on('-l')
  opt.on('-w')
  opt.on('-c')
  opt.parse!(ARGV, into: options)
  options
end

def create_details_from_stdin
  file_names_string = $stdin.read
  files_detail = create_detail(file_names_string)
  [files_detail]
end

def create_details_from_arguments
  file_names = ARGV
  file_details =
    file_names.map do |file_name|
      file_data = File.read(file_name)
      create_detail(file_data, file_name)
    end
  if file_details.size >= 2
    total = calculate_total(file_details)
    file_details.push(total)
  end
  file_details
end

def create_detail(file_data, name = nil)
  {
    lines_count: file_data.lines.count,
    words_count: file_data.scan(/.([\t\n\r ]+)/).size,
    bytes_size: file_data.bytesize,
    name:
  }
end

def calculate_total(file_details)
  {
    lines_count: file_details.sum { |file_detail| file_detail[:lines_count] },
    words_count: file_details.sum { |file_detail| file_detail[:words_count] },
    bytes_size: file_details.sum { |file_detail| file_detail[:bytes_size] },
    name: 'total'
  }
end

def print_file_details(file_details, options)
  file_details.each do |detail|
    print detail[:lines_count].to_s.rjust(8) if options.empty? || options[:l]
    print detail[:words_count].to_s.rjust(8) if options.empty? || options[:w]
    print detail[:bytes_size].to_s.rjust(8) if options.empty? || options[:c]
    print ' '
    print detail[:name].to_s.ljust(8)
    puts
  end
end

main
