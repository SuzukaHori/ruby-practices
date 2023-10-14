#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require_relative './list_command'

def main
  options = parse_options(ARGV)
  file_names = build_file_names_by_options(options)
  path = File.expand_path(ARGV[0]) unless ARGV.empty?

  list_command = ListCommand.new(file_names, path)
  return if list_command.files.empty?

  formatted_infos =
    if options[:l]
      list_command.format_file_details
    else
      list_command.format_file_names
    end
  formatted_infos.each { |file| puts file.join(' ') }
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
  file_names =
    if options[:a]
      Dir.glob('*', File::FNM_DOTMATCH, base: ARGV.join)
    else
      Dir.glob('*', base: ARGV.join)
    end
  file_names = file_names.reverse if options[:r]
  file_names
end

main if __FILE__ == $PROGRAM_NAME
