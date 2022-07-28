require 'pry'

class ColoradoLottery

  attr_reader :registered_contestants,  :winners, :current_contestants

  def initialize
    @registered_contestants = Hash.new{ |k, v| k[v] = [] }
    @winners = []
    @current_contestants = Hash.new{ |k, v| k[v] = [] }
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
    registered_contestants[game.name] << contestant if can_register?(contestant, game)
  end

  def eligible_contestants(game)
    registered_contestants[game.name].select do |contestant|
      contestant.spending_money >= game.cost
    end
  end

  def charge_contestants(game)
    eligible_contestants(game).each do |contestant|
      contestant.spending_money -= game.cost
      current_contestants[game] << contestant.full_name
    end
  end

  def draw_winners
    Time.now.strftime("%Y-%m-%d")
  end

end
