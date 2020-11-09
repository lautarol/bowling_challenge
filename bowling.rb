class Bowling
end

class Player
end

class Frame

end

class Score
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

end