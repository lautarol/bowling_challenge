class Bowling
    def initialize(file)
        players = FileReader.new(file).players
        @results =[]
        start_game(players)
    end

    def start_game(players)
        players.each do |player|
            @results << Player.new(player[:name], player[:shots])
        end
    end
end

class Player
    attr_accessor :shot
    def initialize(name, shots)
        @name = name
        @shots = shots
        @score_card = Score.new
        @current_frame = Frame.new(0)
        player_game
    end

    def player_game
        @shots.each do |shot|
            roll(shot == 'F' ? 0 : shot)
        end
    end

    def roll(number_of_pins)
        validate_game_not_finished
        @current_frame.add(number_of_pins)

        if @current_frame.complete?
            @score_card.add(@current_frame)
            @current_frame = new_frame
        end
    end

    def score
        validate_game_finished
        @score_card.points
    end

    private

    def new_frame
        frame_count == 9 ? LastFrame.new(9) : Frame.new(frame_count)
    end

    def frame_count
        @score_card.frames.count
    end

    def validate_game_not_finished
        raise 'Should not be able to roll after game is over (You may entered more than 10 throws)' if game_over?
    end

    def validate_game_finished
        raise 'Score cannot be taken until the end of the game (Check if you enter the correct number of throws)' unless game_over?
    end

    def game_over?
        frame_count == 10
    end
end

class Frame
    attr_accessor :result, :bonus
    attr_reader :index

    def initialize(index)
        @index = index
        @result = []
        @bonus = 0
    end

    def add(pins)
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

    def open?
        !strike? && !spare?
    end

    def complete?
        strike? || rolls == 2
    end

    def pin_count_error?
        pins > 10
    end

    private

    def validate_pin_amount(pins)
        raise 'Pins must have a value from 0 to 10' unless pins.to_s.match(/\d|10/)
    end

    def validate_frame_total
        raise 'Pin count exceeds pins on the frame' if complete? && pin_count_error?
    end
end

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

class FileReader
    def initialize(file)
        @players= read_file(file)
    end

    def read_file(file)
        players=[]
        players_shots = []
        shots= File.read(file).split("\n")
        names = []
        shots.each do |shot|
            names << shot.split(' ').first
            players_shots << shot.split(' ')
        end
        names.uniq!
        names.each do |player|
            ps = players_shots.select{|p| p.first == player}.flatten!.reject{|p| p == player}
            players << { name: player, shots: ps }
        end
        return players
    end
end

class ResultWritter
    def initialize(result)
    end
end

Bowling.new('input.txt')