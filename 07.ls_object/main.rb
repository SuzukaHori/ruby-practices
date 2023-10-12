#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require_relative './list'

def parse_options(argv)
  opt = OptionParser.new
  options = {}
  opt.on('-l')
  opt.parse!(argv, into: options)
  options
end

options = parse_options(ARGV)

if options[:l]
  list = List.new
  list.files.each do |file|
    file.build_detail
    p file.detail
  end
else
  list = List.new
  formatted_files = list.format_file_names
  list.display(formatted_files)
end
