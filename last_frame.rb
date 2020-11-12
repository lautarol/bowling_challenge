class LastFrame<Frame
  def complete?
    rolls == 3 || rolls == 2 && pins < 10
  end

  def pin_count_error?
    rolls == 2 && pins > 10 || fill_ball && second_roll != 10 && second_roll + fill_ball > 10
  end

  private

  def fill_ball
    result[2]
  end
end
