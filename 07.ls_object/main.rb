#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require_relative './list_command'

def main
  options = parse_options(ARGV)
  file_names = build_file_names_by_options(options)
  return if file_names.empty?

  path = ARGV.empty? ? Dir.pwd : File.expand_path(ARGV[0])

  list_command = ListCommand.new(file_names, path)
  if options[:l]
    formatted_file_details = list_command.format_file_details
    formatted_file_details.each { |row| puts row }
  else
    formatted_file_names = list_command.format_file_names
    formatted_file_names.each { |file_name| puts file_name }
  end
end

def parse_options(argv)
  opt = OptionParser.new
  options = {}
  opt.on('-l')
  opt.on('-a')
  opt.on('-r')
  opt.parse!(argv, into: options)
  options
end

def build_file_names_by_options(options)
  flag = options[:a] ? File::FNM_DOTMATCH : 0
  file_names = Dir.glob('*', flag, base: ARGV.join)
  options [:r] ? file_names.reverse : file_names
end

main if __FILE__ == $PROGRAM_NAME
