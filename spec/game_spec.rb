require 'simplecov'
SimpleCov.start
require './spec/spec_helper'
require './lib/game'

RSpec.describe Game do
  it 'should belong to a class' do
    pick_4 = Game.new('Pick 4', 2)
    mega_millions = Game.new('Mega Millions', 5, true)

    expect(pick_4).to be_a Game
    expect(mega_millions).to be_a Game
  end

end
