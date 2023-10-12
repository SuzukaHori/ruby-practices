require_relative './fileinfo'

class List # フォーマッターとかプリンターとかがいい？
  attr_reader :files, :column_spacing, :number_of_rows

  NUMBER_OF_COLUMNS = 3

  def initialize
    @files = generate_files(Dir.glob('*'))
  end

  def display(formatted_files)
    formatted_files.each do |block|
      block.each { |file| print file&.name }
      print "\n"
    end
  end

  def display_file_details(formatted_details)
    files.each do |file|
      file.build_detail
    end
  end

  def format_file_names
    column_spacing = files.map { |file| file.name.size }.max + 1
    number_of_rows = (files.size / NUMBER_OF_COLUMNS.to_f).ceil

    spaced_files = files.each_with_object([]) do |file, array|
      array << FileInfo.new(file.name.ljust(column_spacing))
    end
    spaced_files.each_slice(number_of_rows).to_a.each { |group| group << nil while group.size < number_of_rows }.transpose
  end

  private

  def generate_files(file_names)
    files = file_names.each_with_object([]) do |name, array|
      array << FileInfo.new(name)
    end
  end
end
