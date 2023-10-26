# frozen_string_literal: true

require_relative './file_info'

class ListCommand
  attr_reader :files

  NUMBER_OF_COLUMNS = 3

  DETAIL_KEYS = %i[
    type_and_permission
    hard_link_count
    user_name
    group_name
    size
    timestamp
    name
  ].freeze

  private_constant :NUMBER_OF_COLUMNS, :DETAIL_KEYS

  def initialize(file_names, path)
    @files = file_names.map do |name|
      file_path = path + '/' + name
      FileInfo.new(file_path)
    end
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
    details = files.map { |file| build_detail(file) }
    max_length_list = build_max_length_list(details)
    formatted_details = details.map do |detail|
      DETAIL_KEYS.map { |key| align_detail(key:, value: detail[key], max_length: max_length_list[key]) }
    end
    [["total #{files.sum { |file| file.status.blocks }}"], *formatted_details]
  end

  private

  def build_detail(file)
    detail = DETAIL_KEYS.map do |key|
      key == :timestamp ? [key, file.timestamp.strftime('%_m %e %H:%M')] : [key, file.send(key).to_s]
    end
    detail.to_h
  end

  def build_max_length_list(details)
    DETAIL_KEYS.map { |key| [key, details.map { |detail| detail[key].length }.max] }.to_h
  end

  def align_detail(key:, value:, max_length:)
    spacing = %i[user_name hard_link_count size].include?(key) ? max_length + 1 : max_length
    %i[user_name group_name name].include?(key) ? value.ljust(spacing) : value.rjust(spacing)
  end
end
