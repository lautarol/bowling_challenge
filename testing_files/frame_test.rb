require 'minitest/autorun'
require_relative '../frame.rb'
require_relative '../last_frame.rb'

class FrameTest < Minitest::Test
  
  def setup
    @frames=[]
    (0..8).each{ |i| @frames << Frame.new(i) }
    @frames << LastFrame.new(9)
  end

  def test_frame_empty_rolls
    #skip
    frame = @frames[0]
    assert_nil frame.first_roll
  end

  def test_valid_first_roll
    #skip
    frame = @frames[0]
    frame.add(5)
    assert_equal 5, frame.first_roll
  end

  def test_not_valid_first_roll
    #skip
    frame = @frames[0]
    assert_raises RuntimeError do
      frame.add(11)
    end
  end

  def test_valid_2_rolls
    #skip
    frame = @frames[0]
    frame.add(1)
    frame.add(8)
    assert_equal 8, frame.second_roll
  end

  def test_complete_frame
    #skip
    frame = @frames[0]
    frame.add(1)
    frame.add(8)
    assert_equal true, frame.complete?
  end

  def test_strike_frame
    #skip
    frame = @frames[0]
    frame.add(10)
    assert_equal true, frame.strike?
  end

  def test_complete_frame_if_strike
    #skip
    frame = @frames[0]
    frame.add(10)
    assert_equal true, frame.complete?
  end

  def test_spare_frame
    #skip
    frame = @frames[0]
    frame.add(1)
    frame.add(9)
    assert_equal true, frame.spare?
  end

  def test_more_than_10_in_2_rolls
    #skip
    frame = @frames[0]
    frame.add(3)
    assert_raises RuntimeError do
      frame.add(8)
    end
  end

  def test_spare_has_10_points_frame
    #skip
    frame = @frames[0]
    frame.add(1)
    frame.add(9)
    assert_equal 10, frame.points
  end

  def test_spare_plus_bonus_points_frame
    #skip
    frame = @frames[0]
    frame.add(1)
    frame.add(9)
    frame.bonus = 5
    assert_equal 15, frame.points
  end

  def test_last_frame_not_complete_when_spare
    frame = @frames[9]
    frame.add(1)
    frame.add(9)
    assert_equal false, frame.complete?
  end

  def test_last_frame_not_complete_when_2_strikes
    frame = @frames[9]
    frame.add(10)
    frame.add(10)
    assert_equal false, frame.complete?
  end

  def test_last_frame_complete_when_spare
    frame = @frames[9]
    frame.add(1)
    frame.add(9)
    frame.add(5)
    assert_equal true, frame.complete?
  end

  def test_last_frame_complete_when_strike
    frame = @frames[9]
    frame.add(10)
    frame.add(9)
    frame.add(5)
    assert_equal true, frame.complete?
  end

  def test_last_frame_cannot_roll_3_if_not_strike_or_spare
    frame = @frames[9]
    frame.add(1)
    frame.add(2)
    assert_raises RuntimeError do
      frame.add(8)
    end
  end

end
