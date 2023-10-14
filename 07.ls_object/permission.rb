# frozen_string_literal: true

class Permission
  attr_reader :type_and_permission

  def initialize(status)
    @type_and_permission = build_type(status) + build_permission(status)
  end

  private

  def build_type(status)
    TYPE_LIST[format('%06o', status.mode)[0, 2]]
  end

  def build_permission(status)
    status.mode
          .to_s(8)
          .slice(-3, 3)
          .chars
          .map { |n| PERMISSION_LIST[n] }
          .join
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
