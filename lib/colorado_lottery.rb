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
    find_winners
    date_of_drawing
  end

  def find_winners
    current_contestants.each do |game, players|
      winners << { players.sample => game.name }
    end
  end

  def date_of_drawing
    Time.now.strftime("%Y-%m-%d")
  end

  def announce_winner(game)
    "#{find_game_winner(game)[game]} won the #{game} on #{short_date}"
  end

  def find_game_winner(game)
    winners.select { | winner | winner.values.first == game }.first.invert
  end

  def short_date
    date_of_drawing[-5..-1].gsub("-", "/")
  end

end
