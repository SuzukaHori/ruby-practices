#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
class FileInfo
  attr_reader :name

  def initialize(name)
    @name = name
  end
end

class List
  attr_reader :files, :column_spacing, :number_of_rows

  NUMBER_OF_COLUMNS = 3

  def initialize
    file_names = Dir.glob('*')
    @files = create_formatted_files(file_names)
  end

  def display
    files.each do |array|
      array.each { |file| print file&.name }
      print "\n"
    end
  end

  private

  def create_formatted_files(file_names)
    column_spacing = file_names.map(&:size).max + 1
    files = file_names.each_with_object([]) do |name, array|
      array << FileInfo.new(name.ljust(column_spacing))
    end
    format(files)
  end

  def format(files)
    number_of_rows = (files.size / NUMBER_OF_COLUMNS.to_f).ceil
    files.each_slice(number_of_rows).to_a.each { |block| block << nil while block.size < number_of_rows }.transpose
  end
end

class ReverseList < List
  def format(files)
    super(files.reverse)
  end
end

class AllList < List
  def initialize
    file_names = Dir.glob('*', File::FNM_DOTMATCH)
    @files = create_formatted_files(file_names)
  end
end

def parse_options(argv)
  opt = OptionParser.new
  options = {}
  opt.on('-r')
  opt.on('-a')
  opt.parse!(argv, into: options)
  options
end

options = parse_options(ARGV)

list = if options[:r]
         ReverseList.new
       elsif options[:a]
         AllList.new
       else
         List.new
       end

list.display
