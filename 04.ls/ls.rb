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

def build_file_info(file_name, file_status)
  file_mode = file_status.mode
  { type_and_permission:
      get_file_type(file_mode) + generate_permission_string(file_mode),
    hard_link_count: file_status.nlink.to_s,
    user_name: get_user_name(file_status),
    group_name: Etc.getgrgid(file_status.gid).name,
    size: file_status.size.to_s,
    timestamp: file_status.mtime.strftime('%_m %e %H:%M'),
    file_name: }
end

def get_user_name(file_status)
  Etc.getpwuid(file_status.uid).name
rescue ArgumentError
  file_status.uid.to_s
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

def get_file_type(mode)
  TYPE_LIST[format('%06o', mode)[0, 2]]
end

def align_file_infos(file_infos)
  blanks = {}
  INFO_KEYS.each do |key|
    lengths = file_infos.map { |file_info| file_info[key].length }
    blanks[key] = if %i[hard_link_count group_name size].include?(key)
                             lengths.max + 1
                           else
                             lengths.max # 「最も長い要素+余白」の長さを取得する。
                           end
    file_infos.map do |file_info|
      file_info[key] = if %i[user_name group_name file_name].include?(key) # すべての要素をcolumn_spacingに合わせて整形する
                         file_info[key].ljust(blanks[key])
                       else
                         file_info[key].rjust(blanks[key])
                       end
    end
  end
  file_infos
end

def process_l_option(file_names)
  file_infos = []
  file_blocks = []

  file_names.each do |file_name|
    file_status = File.stat(file_name)
    current_file_info = build_file_info(file_name, file_status)
    file_infos << current_file_info
    store_blocks(file_blocks, file_status)
  end
  [file_blocks.sum, align_file_infos(file_infos)]
end

def store_blocks(file_blocks, file_status)
  file_blocks << file_status.blocks
end

opt = OptionParser.new
options = {}
opt.on('-l')
opt.parse!(ARGV, into: options)

files = Dir.glob('*', base: ARGV.join)

if options[:l]
  total_file_blocks, formatted_file_infos = process_l_option(files)
  puts "total #{total_file_blocks}"
  formatted_file_infos.each do |file_info|
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
