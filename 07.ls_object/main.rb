#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require_relative './list_command'

list_command = ListCommand.new(ARGV)

unless list_command.files.empty?
  formatted_infos =
    if list_command.options[:l]
      list_command.format_file_details
    else
      list_command.format_file_names
    end
  formatted_infos.each { |file| puts file.join(' ') }
end
