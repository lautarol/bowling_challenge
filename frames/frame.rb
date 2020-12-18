class Frame
  attr_accessor :result, :bonus
  attr_reader :index

  def initialize(index)
    @index = index
    @result = []
    @bonus = 0
  end

  def add(pins)
    validate_not_complete
    validate_pin_amount(pins)
    result << pins.to_i
    validate_frame_total
  end

  def rolls
    result.count
  end

  def first_roll
    result[0]
  end

  def second_roll
    result[1]
  end

  def pins
    result.reduce(:+) || 0
  end

  def points
    pins + bonus
  end

  def strike?
    first_roll == 10
  end

  def spare?
    !strike? && first_roll + second_roll == 10
  end

  def complete?
    strike? || rolls == 2
  end

  def pin_count_error?
    pins > 10
  end

  private
  
  def validate_not_complete
    raise 'You canot roll when the frame is complete' if complete?
  end

  def validate_pin_amount(pins)
    raise 'Pins must be a value from 0 to 10 or an F if it is a faul' unless pins.to_s.match(/\A\d\z|10/)
  end

  def validate_frame_total
    raise 'Pin count exceeds pins on the frame' if complete? && pin_count_error?
  end
end
