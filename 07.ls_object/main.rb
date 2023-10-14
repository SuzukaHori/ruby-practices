#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require_relative './list_command'

list_command = ListCommand.new(ARGV)

if list_command.options[:l]
  list_command.display_file_details
else
  list_command.display_file_name
end
