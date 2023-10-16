# frozen_string_literal: true

require_relative './file_info'

class ListCommand
  attr_reader :files, :path

  NUMBER_OF_COLUMNS = 3

  def initialize(file_names, path)
    @path = path
    @files = build_files(file_names)
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
    files.each { |file| file.get_details(path) }

    file_details = files.map do |file|
      FileInfo::KEYS.map do |key|
        max_length = files.map { |f| f.value_length(key) }.max
        file.align_details(key, max_length)
      end
    end
    file_details.unshift(["total #{files.sum(&:blocks)}"])
  end

  private

  def build_files(file_names)
    file_names.each_with_object([]) do |name, array|
      array << FileInfo.new(name)
    end
  end
end
