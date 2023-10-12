require 'etc'

class Detail
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

  def initialize(file_name)
    file_status = File.stat(file_name)
    file_mode = file_status.mode

    @type_and_permission = TYPE_LIST[format('%06o', file_mode)[0, 2]] + generate_permission_string(file_mode)
    @hard_link_count = file_status.nlink.to_s
    @user_name = Etc.getpwuid(file_status.uid).name
    @group_name = Etc.getgrgid(file_status.gid).name
    @timestamp = file_status.mtime.strftime('%_m %e %H:%M')
    @size = file_status.size.to_s
    @file_name = file_name
  end

  def align; end
  # max_length = self.instance_variables.map{ |sym| self.instance_variable_get(sym) }

  #   file_infos.map do |file_info|
  #     current_value = file_info[key]
  #     spacing =
  #       if %i[user_name hard_link_count size].include?(key)
  #         max_length + 1
  #       else
  #         max_length
  #       end
  #     file_info[key] =
  #       if %i[user_name group_name file_name].include?(key)
  #         current_value.ljust(spacing)
  #       else
  #         current_value.rjust(spacing)
  #       end
  #   end
  # end
  # file_infos

  private

  def generate_permission_string(file_mode)
    permissions =
      file_mode
      .to_s(8)
      .slice(-3, 3)
      .chars
      .map { |permission_number| PERMISSION_LIST[permission_number] }
    permissions.join
  end
end
