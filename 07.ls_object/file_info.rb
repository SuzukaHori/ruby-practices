# frozen_string_literal: true

require 'etc'
require 'forwardable'

class FileInfo
  attr_reader :path

  extend Forwardable

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

  def initialize(path)
    @path = path
  end

  def status
    @status ||= File.stat(path)
  end

  def name
    File.basename(path)
  end

  def hard_link_count
    status.nlink
  end

  def user_name
    Etc.getpwuid(status.uid).name
  end

  def group_name
    Etc.getgrgid(status.gid).name
  end

  delegate size: :status

  def timestamp
    status.mtime
  end

  def type_and_permission
    type = TYPE_LIST[format('%06o', status.mode)[0, 2]]
    permission = status.mode
                       .to_s(8)
                       .slice(-3, 3)
                       .chars
                       .map { |n| PERMISSION_LIST[n] }
                       .join

    type + permission
  end
end
