class FileReader
  attr_accessor :players
  
  def initialize(file)
    @players = read_file(file)
  end

  def read_file(file)
    players = []
    players_shots = []
    shots = File.read(file).split("\n")
    names = []
    shots.each do |shot|
      names << shot.split(' ').first
      players_shots << shot.split(' ')
    end
    names.uniq!
    names.each do |player|
      ps = players_shots.select{ |p| p.first == player}.flatten!.reject{|p| p == player }
      players << { name: player, shots: ps }
    end
    players
  end
end
