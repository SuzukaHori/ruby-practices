#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'

NUMBER_OF_COLUMNS = 3
INFO_KEYS = %i[
  type_and_permission
  hard_link_count
  user_name
  group_name
  timestamp
  size
  file_name
].freeze

PERMISSION_LIST = {
  '0' => '---',
  '1' => '--x',
  '2' => '-w-',
  '3' => '-wx',
  '4' => 'r--',
  '5' => 'r-x',
  '6' => 'rw-',
  '7' => 'rwx'
}.freeze

TYPE_LIST = {
  '01' => 'p',
  '02' => 'c',
  '04' => 'd',
  '06' => 'b',
  '10' => '-',
  '12' => 'l',
  '14' => 's'
}.freeze

def calculate_number_of_rows(files)
  (files.size / NUMBER_OF_COLUMNS.to_f).ceil
end

def format_files(files, number_of_rows)
  column_spacing = files.map(&:size).max + 1
  files
    .map { |file| file.ljust(column_spacing) }
    .each_slice(number_of_rows).to_a
    .each { |file| file << nil while file.size < number_of_rows }
    .transpose
end

def get_file_infos(file_names)
  file_infos = file_names.map { |file_name| build_file_info(file_name) }
  align_file_infos(file_infos)
end

def build_file_info(file_name)
  file_status = File.stat(file_name)
  file_mode = file_status.mode
  { type_and_permission:
      TYPE_LIST[format('%06o', file_mode)[0, 2]] + generate_permission_string(file_mode),
    hard_link_count: file_status.nlink.to_s,
    user_name: Etc.getpwuid(file_status.uid).name,
    group_name: Etc.getgrgid(file_status.gid).name,
    size: file_status.size.to_s,
    timestamp: file_status.mtime.strftime('%_m %e %H:%M'),
    file_name: }
end

def generate_permission_string(file_mode)
  permissions =
    file_mode
    .to_s(8)
    .slice(-3, 3)
    .chars
    .map { |permission_number| PERMISSION_LIST[permission_number] }
  permissions.join
end

def align_file_infos(file_infos)
  INFO_KEYS.each do |key|
    max_length = file_infos.map { |file_info| file_info[key].length }.max
    file_infos.map do |file_info|
      current_value = file_info[key]
      spacing =
        if %i[user_name hard_link_count size].include?(key)
          max_length + 1
        else
          max_length
        end
      file_info[key] =
        if %i[user_name group_name file_name].include?(key)
          current_value.ljust(spacing)
        else
          current_value.rjust(spacing)
        end
    end
  end
  file_infos
end

opt = OptionParser.new
options = {}
opt.on('-l')
opt.parse!(ARGV, into: options)

files = Dir.glob('*', base: ARGV.join)

if options[:l]
  total_file_blocks = files.sum { |file| File.stat(file).blocks }
  file_infos = get_file_infos(files)
  puts "total #{total_file_blocks}"
  file_infos.each do |file_info|
    file_info.each_value do |value|
      print "#{value} "
    end
    puts
  end
else
  number_of_rows = calculate_number_of_rows(files)
  unless files.empty?
    formatted_files = format_files(files, number_of_rows)
    formatted_files.each { |file| print(*file, "\n") }
  end
end
