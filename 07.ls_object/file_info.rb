# frozen_string_literal: true

require 'etc'
require_relative './permission'

class FileInfo
  attr_reader :name, :status

  def initialize(path, name)
    @name = name
    @status = File.stat(File.join(path, name))
  end

  def hard_link_count
    status.nlink.to_s
  end

  def user_name
    Etc.getpwuid(status.uid).name
  end

  def group_name
    Etc.getgrgid(status.gid).name
  end

  def size
    status.size.to_s
  end

  def timestamp
    status.mtime.strftime('%_m %e %H:%M')
  end
end
