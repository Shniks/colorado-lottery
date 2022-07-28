require 'pry'

class ColoradoLottery

  attr_reader :registered_contestants,  :winners, :current_contestants

  def initialize
    @registered_contestants = Hash.new{ |k, v| k[v] = [] }
    @winners = []
    @current_contestants = {}
  end

  def interested_and_18?(contestant, game)
    return true if contestant.age >= 18 && contestant.game_interests.include?(game.name)
    false
  end

  def can_register?(contestant, game)
    return true if interested_and_18?(contestant, game) && check_residency_and_game_status(contestant, game)
    false
  end

  def check_residency_and_game_status(contestant, game)
    return true if contestant.out_of_state? == false || game.national_drawing == true
    false
  end

  def register_contestant(contestant, game)
    registered_contestants[game.name] << contestant 
  end

end
