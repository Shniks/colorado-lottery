class Contestant

  attr_reader :full_name, :age, :state_of_residence,
              :spending_money,  :game_interests

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
  
end
