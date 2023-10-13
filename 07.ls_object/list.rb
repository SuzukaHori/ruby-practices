require_relative './file_info'

class ListCommand
  attr_reader :files, :column_spacing, :number_of_rows

  NUMBER_OF_COLUMNS = 3

  def initialize
    @files = generate_files(Dir.glob('*'))
  end

  def display_file_name(formatted_files)
    formatted_files.each do |block|
      block.each { |file| print file&.name }
      print "\n"
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

  def display_details
    files.each do |file|
      FileDetail::ITEMS.each do |key|
        max_length = files.map { |file| file.detail.value_length(key) }.max
        spacing =
        if %i[@user_name @hard_link_count @size].include?(key)
          max_length + 1
        else
          max_length
        end
        print "#{file.detail.align(key, spacing)} "
      end
      puts
    end
  end

  private

  def generate_files(file_names)
    files = file_names.each_with_object([]) do |name, array|
      array << FileInfo.new(name)
    end
  end
end

list = ListCommand.new
list.files.each(&:detail_new)
list.display_details
