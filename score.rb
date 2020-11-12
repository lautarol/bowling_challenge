class Score
  attr_reader :frames

  def initialize
    @frames = []
  end

  def add(frame)
    add_bonuses(frame) unless @frames.empty?
    @frames << frame
  end

  def points
    @frames.inject(0) { |sum, frame| sum + frame.points }
  end

  private

  def add_bonuses(frame)
    add_spare_bonus(frame) if last_frame.spare?
    add_strike_bonus(frame) if last_frame.strike?
    add_double_bonus(frame) if previous_double?
  end

  def add_spare_bonus(frame)
    last_frame.bonus += frame.first_roll
  end

  def add_strike_bonus(frame)
    last_frame.bonus += frame.first_roll
    last_frame.bonus += frame.second_roll if frame.second_roll
  end

  def add_double_bonus(frame)
    second_to_last_frame.bonus += frame.first_roll
  end

  def last_frame
    @frames.last
  end

  def second_to_last_frame
    @frames[-2]
  end

  def previous_double?
    second_to_last_frame && last_frame.strike? && second_to_last_frame.strike?
  end
end
