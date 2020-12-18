require 'minitest/autorun'
require_relative '../score.rb'
require_relative '../frames/frame.rb'
require_relative '../frames/last_frame.rb'

class ScoreTest < Minitest::Test

  def setup
    @score = Score.new
    @frames = []
    (0..8).each { |i| @frames << Frame.new(i) }
    @frames << LastFrame.new(9)
  end

  def test_add_a_regular_frame
    @frames[0].add(3)
    @frames[0].add(3)
    @score.add(@frames[0])
    assert_equal 1, @score.frames.size
  end

  def test_add_a_regular_frame_and_check_points
    @frames[0].add(3)
    @frames[0].add(3)
    @score.add(@frames[0])
    assert_equal 6, @score.points
  end

  def test_add_2_strikes_and_check_points
    @frames[0].add(10)
    @frames[1].add(10)
    @score.add(@frames[0])
    @score.add(@frames[1])
    assert_equal 30, @score.points
  end

  def test_add_1_spare_and_check_points
    @frames[0].add(9)
    @frames[0].add(1)
    @frames[1].add(5)
    @score.add(@frames[0])
    @score.add(@frames[1])
    assert_equal 20, @score.points
  end

  def test_add_3_strikes_and_check_points
    (0..2).each { |i| @frames[i].add(10); @score.add(@frames[i]) }
    assert_equal 60, @score.points
  end

  def test_perfect_game
    (0..8).each { |i| @frames[i].add(10); @score.add(@frames[i]) }
    3.times { @frames[9].add(10) }
    @score.add(@frames[9])
    assert_equal 300, @score.points
  end

  def test_all_0_game
    (0..9).each { |i| @frames[i].add(0); @frames[i].add(0); @score.add(@frames[i]) }
    assert_equal 0, @score.points
  end
end
