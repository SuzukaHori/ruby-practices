# frozen_string_literal: true

require_relative './file_info'

class ListCommand
  attr_reader :files, :options

  NUMBER_OF_COLUMNS = 3

  def initialize(argv = nil)
    @options = parse_options(argv)
    @files = build_files(argv)
  end

  def format_file_names
    column_spacing = files.map { |file| file.name.size }.max
    number_of_rows = (files.size / NUMBER_OF_COLUMNS.to_f).ceil

    spaced_files = files.each_with_object([]) do |file, array|
      array << file.name.ljust(column_spacing)
    end
    spaced_files.each_slice(number_of_rows).to_a.each { |group| group << nil while group.size < number_of_rows }.transpose
  end

  def format_file_details
    files.each(&:set_details)

    file_details = files.map do |file|
      FileInfo::KEYS.map do |key|
        max_length = files.map { |f| f.value_length(key) }.max
        file.align_details(key, max_length)
      end
    end
    file_details.unshift(["total #{files.sum(&:blocks)}"])
  end

  private

  def parse_options(argv)
    opt = OptionParser.new
    options = {}
    opt.on('-l')
    opt.on('-a')
    opt.on('-r')
    opt.parse!(argv, into: options)
    options
  end

  def build_files(argv)
    file_names =
      if options[:a]
        Dir.glob('*', File::FNM_DOTMATCH, base: argv.join)
      else
        Dir.glob('*', base: argv.join)
      end
    file_names = file_names.reverse if options[:r]

    file_names.each_with_object([]) do |name, array|
      array << FileInfo.new(name)
    end
  end
end
