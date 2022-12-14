class Contestant

  attr_reader :full_name, :age, :state_of_residence, :game_interests
  attr_accessor :spending_money

  def initialize(contestant)
    @full_name = contestant[:first_name] + " " + contestant[:last_name]
    @age = contestant[:age]
    @state_of_residence = contestant[:state_of_residence]
    @spending_money = contestant[:spending_money]
    @game_interests = []
  end

  def out_of_state?
    return true if state_of_residence != 'CO'
    false
  end

  def add_game_interest(game)
    game_interests << game
  end

end
