require_relative './shot'

class Frame
  attr_reader :first_shot, :second_shot, :third_shot, :status

  def initialize(first_mark, second_mark = nil, third_mark = nil)
    @first_shot = Shot.new(first_mark)
    @second_shot = Shot.new(second_mark)
    @third_shot = Shot.new(third_mark)
    set_status(first_mark, second_mark, third_mark) # TODO: これいらない
  end

  def score
    first_shot.score + second_shot.score + third_shot&.score
  end

  private

  def set_status(first_mark, second_mark, third_mark)
    @status = if first_mark == 'X'
                'strike'
              elsif first_mark.to_i + second_mark.to_i == 10
                'spare'
              end
  end
end
