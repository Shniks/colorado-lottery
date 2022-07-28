require 'pry'

class ColoradoLottery

  attr_reader :registered_contestants,  :winners, :current_contestants

  def initialize
    @registered_contestants = Hash.new
    @winners = []
    @current_contestants = {}
  end

  def interested_and_18?(contestant, game)
    return true if contestant.age >= 18 && contestant.game_interests.include?(game.name)
    false
  end

end
