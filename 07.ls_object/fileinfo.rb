require_relative './detail'

class FileInfo
  attr_reader :name, :detail

  def initialize(name)
    @name = name
  end

  def build_detail
    @detail = Detail.new(name)
  end
end
