# frozen_string_literal: true

require 'etc'
require_relative './permission'

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

  def get_details(path)
    status = File.stat(File.join(path, name))
    @details =
      { type_and_permission: Permission.new(status).type_and_permission,
        hard_link_count: status.nlink.to_s,
        user_name: Etc.getpwuid(status.uid).name,
        group_name: Etc.getgrgid(status.gid).name,
        size: status.size.to_s,
        timestamp: status.mtime.strftime('%_m %e %H:%M'),
        name: }
    @blocks = status.blocks
  end

  def value_length(sym)
    details[sym].length
  end

  def align_details(sym, max_length)
    spacing = %i[user_name hard_link_count size].include?(sym) ? max_length + 1 : max_length
    if %i[user_name group_name name].include?(sym)
      details[sym].ljust(spacing)
    else
      details[sym].rjust(spacing)
    end
  end
end
