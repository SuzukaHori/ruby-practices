# frozen_string_literal: true

require 'etc'

class FileInfo
  attr_reader :name, :details, :blocks

  KEYS = %i[
    type_and_permission
    hard_link_count
    user_name
    group_name
    size
    timestamp
    name
  ].freeze

  def initialize(name)
    @name = name
  end

  def set_details
    status = File.stat(name)
    @details =
      { type_and_permission: generate_type_and_permission(status),
        hard_link_count: status.nlink.to_s,
        user_name: Etc.getpwuid(status.uid).name,
        group_name: Etc.getgrgid(status.gid).name,
        size: status.size.to_s,
        timestamp: status.mtime.strftime('%_m %e %H:%M'),
        name: }
    @blocks = File.stat(name).blocks
  end

  def value_length(sym)
    details[sym].length
  end

  def align(sym, max_length)
    spacing =
      if %i[user_name hard_link_count size].include?(sym)
        max_length + 1
      else
        max_length
      end

    if %i[user_name group_name name].include?(sym)
      "#{details[sym].ljust(spacing)} "
    else
      "#{details[sym].rjust(spacing)} "
    end
  end

  private

  def generate_type_and_permission(status)
    permissions =
      status.mode
            .to_s(8)
            .slice(-3, 3)
            .chars
            .map { |n| PERMISSION_LIST[n] }
            .join
    TYPE_LIST[format('%06o', status.mode)[0, 2]] + permissions
  end

  TYPE_LIST = {
    '01' => 'p',
    '02' => 'c',
    '04' => 'd',
    '06' => 'b',
    '10' => '-',
    '12' => 'l',
    '14' => 's'
  }.freeze

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

  private_constant :TYPE_LIST, :PERMISSION_LIST
end
