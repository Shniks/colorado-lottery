class Contestant

  attr_reader :full_name, :age, :state_of_residence,  :spending_money

  def initialize(contestant)
    @full_name = contestant[:first_name] + " " + contestant[:last_name]
    @age = contestant[:age]
    @state_of_residence = contestant[:state_of_residence]
    @spending_money = contestant[:spending_money]
  end



end
