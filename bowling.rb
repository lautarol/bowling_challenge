require_relative 'player.rb'
require_relative 'frame.rb'
require_relative 'last_frame.rb'
require_relative 'score.rb'
require_relative 'file_reader.rb'
require_relative 'result_writter.rb'

class Bowling
  def initialize(file)
    players = FileReader.new(file).players
    ResultWritter.new(start_game(players))
  end

  def start_game(players)
    results = []
    players.each do |player|
      raise 'Max number of players is 6' if players.size > 6

      results << Player.new(player[:name], player[:shots])
    end
    results
  end
end

Bowling.new(ARGV[0])
