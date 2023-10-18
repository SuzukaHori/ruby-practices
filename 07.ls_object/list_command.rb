# frozen_string_literal: true

require_relative './file_info'

class ListCommand
  attr_reader :files, :path

  NUMBER_OF_COLUMNS = 3

  def initialize(file_names, path)
    @path = path
    @files = file_names.map { |name| FileInfo.new(name) }
  end

  def format_file_names
    column_spacing = files.map { |file| file.name.size }.max
    number_of_rows = (files.size / NUMBER_OF_COLUMNS.to_f).ceil
    spaced_files = files.map { |file| file.name.ljust(column_spacing) }
    spaced_files.each_slice(number_of_rows).to_a
                .each { |group| group << nil while group.size < number_of_rows }
                .transpose
  end

  def format_file_details
    files.each { |file| file.get_detail(path) }
    max_lengths = calculate_max_lengths
    file_details = files.map do |file|
      FileInfo::KEYS.map { |key| file.align_detail(key, max_lengths[key]) }
    end
    file_details.unshift(["total #{files.sum(&:blocks)}"])
  end

  private

  def calculate_max_lengths
    FileInfo::KEYS.map { |key| [key, files.map { |f| f.value_length(key) }.max] }.to_h
  end
end
