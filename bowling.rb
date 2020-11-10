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
    
    def initialize(name, shots)
        @name = name
        @shots = shots
        @score_card = Score.new
        @current_frame = Frame.new(0)
        player_game
    end
end

class Frame
    def initialize(index)
        @index = index
        @result = []
        @bonus = 0
    end
end

class LastFrame<Frame
end

class Score
    def initialize
        @frames = []
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