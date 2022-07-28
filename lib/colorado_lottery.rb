class ColoradoLottery

  attr_reader :registered_contestants,  :winners, :current_contestants

  def initialize
    @registered_contestants = Hash.new
    @winners = []
    @current_contestants = {}
  end

end
