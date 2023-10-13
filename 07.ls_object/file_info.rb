require_relative './file_detail'

class FileInfo
  attr_reader :name, :detail

  def initialize(name)
    @name = name
  end

  def detail_new
    @detail = FileDetail.new(name)
  end
end
