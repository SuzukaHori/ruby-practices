# frozen_string_literal: true

require_relative './file_info'

class ListCommand
  attr_reader :files, :options

  NUMBER_OF_COLUMNS = 3

  def initialize(argv = nil)
    @options = parse_options(argv)
    @files = generate_files(argv) # 名前揺れ
  end

  def display_file_name
    column_spacing = files.map { |file| file.name.size }.max + 1
    number_of_rows = (files.size / NUMBER_OF_COLUMNS.to_f).ceil

    spaced_files = files.each_with_object([]) do |file, array|
      array << file.name.ljust(column_spacing)
    end
    formatted_files = spaced_files.each_slice(number_of_rows).to_a.each { |group| group << nil while group.size < number_of_rows }.transpose

    formatted_files.each do |block|
      block.each { |file| print file }
      print "\n"
    end
  end

  def display_details
    files.each do |file|
      FileInfo::ITEMS.each do |key|
        max_length = files.map { |file| file.value_length(key) }.max
        spacing =
          if %i[@user_name @hard_link_count @size].include?(key)
            max_length + 1
          else
            max_length
          end
        print "#{file.align(key, spacing)} "
      end
      puts
    end
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

  def generate_files(argv)
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
