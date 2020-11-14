require 'minitest/autorun'
require_relative '../player.rb'
require_relative '../frame.rb'
require_relative '../last_frame.rb'
require_relative '../score.rb'

class PlayerTest < Minitest::Test

  def player(name, rolls)
    @player = Player.new(name, rolls)
  end

  def test_should_be_able_to_score_a_game_with_all_zeros
    #skip
    player('name',[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])
    assert_equal 0, @player.score
  end

  def test_should_be_able_to_score_a_game_with_no_strikes_or_spares
    #skip
    player('name',[3, 6, 3, 6, 3, 6, 3, 6, 3, 6, 3, 6, 3, 6, 3, 6, 3, 6, 3, 6])
    assert_equal 90, @player.score
  end

  def test_a_spare_followed_by_zeros_is_worth_ten_points
    #skip
    player('name',[6, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])
    assert_equal 10, @player.score
  end

  def test_points_scored_in_the_roll_after_a_spare_are_counted_twice
    #skip
    player('name',[6, 4, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])
    assert_equal 16, @player.score
  end

  def test_consecutive_spares_each_get_a_one_roll_bonus
    #skip
    player('name',[5, 5, 3, 7, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])
    assert_equal 31, @player.score
  end

  def test_a_spare_in_the_last_frame_gets_a_one_roll_bonus_that_is_counted_once
    #skip
    player('name',[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, 3, 7])
    assert_equal 17, @player.score
  end

  def test_a_strike_earns_ten_points_in_a_frame_with_a_single_roll
    #skip
    player('name',[10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])
    assert_equal 10, @player.score
  end

  def test_points_scored_in_the_two_rolls_after_a_strike_are_counted_twice_as_a_bonus
    #skip
    player('name',[10, 5, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])
    assert_equal 26, @player.score
  end

  def test_consecutive_strikes_each_get_the_two_roll_bonus
    #skip
    player('name',[10, 10, 10, 5, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])
    assert_equal 81, @player.score
  end

  def test_a_strike_in_the_last_frame_gets_a_two_roll_bonus_that_is_counted_once
    #skip
    player('name',[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10, 7, 1])
    assert_equal 18, @player.score
  end

  def test_rolling_a_spare_with_the_two_roll_bonus_does_not_get_a_bonus_roll
    #skip
    player('name',[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10, 7, 3])
    assert_equal 20, @player.score
  end

  def test_strikes_with_the_two_roll_bonus_do_not_get_bonus_rolls
    #skip
    player('name',[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10, 10, 10])
    assert_equal 30, @player.score
  end

  def test_a_strike_with_the_one_roll_bonus_after_a_spare_in_the_last_frame_does_not_get_a_bonus
    #skip
    player('name',[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, 3, 10])
    assert_equal 20, @player.score
  end

  def test_all_strikes_is_a_perfect_game
    #skip
    player('name',[10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10])
    assert_equal 300, @player.score
  end

  def test_all_fauls
    #skip
    player('name', ['F', 'F', 'F', 'F', 'F', 'F', 'F', 'F', 'F', 'F', 'F', 'F', 'F', 'F', 'F', 'F', 'F', 'F', 'F', 'F'])
    assert_equal 0, @player.score
  end

  def test_rolls_cannot_score_negative_points
    #skip
    player('name', [])
    assert_raises RuntimeError do
      @player.roll(-1)
    end
  end

  def test_rolls_cannot_score_more_than_10_points
    #skip
    player('name', [])
    assert_raises RuntimeError do
      @player.roll(11)
    end
  end

  def test_bonus_roll_after_a_strike_in_the_last_frame_cannot_score_more_than_10_points
    #skip
    player('name', [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10])
    assert_raises RuntimeError do
      @player.roll(11)
    end
  end

  def test_bonus_roll_for_a_spare_in_the_last_frame_must_be_rolled_before_score_can_be_calculated
    #skip
    player('name', [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, 3])
    assert_raises RuntimeError do
      @player.score
    end
  end

  def test_both_bonus_rolls_for_a_strike_in_the_last_frame_must_be_rolled_before_score_can_be_calculated
    #skip
    player('name', [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10, 10])
    assert_raises RuntimeError do
      @player.score
    end
  end
end
