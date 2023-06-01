#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

opt = OptionParser.new
options = {}
opt.on('-a')
opt.parse!(ARGV, into: options)

files =
  if options[:a]
    Dir.glob('*', File::FNM_DOTMATCH, base: ARGV.join)
  else
    Dir.glob('*', base: ARGV.join)
  end

NUMBER_OF_COLUMNS = 3

def calculate_number_of_rows(files)
  (files.size / NUMBER_OF_COLUMNS.to_f).ceil
end

def format_files(files, number_of_rows)
  column_spacing = files.map(&:size).max + 1
  files
    .map { |file| file.ljust(column_spacing) }
    .each_slice(number_of_rows).to_a
    .each { |file| file << nil while file.size < number_of_rows }
    .transpose
end

number_of_rows = calculate_number_of_rows(files)
unless files.empty?
  formatted_files = format_files(files, number_of_rows)
  formatted_files.each { |file| print(*file, "\n") }
end
