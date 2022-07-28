require 'simplecov'
SimpleCov.start
require './spec/spec_helper'
require './lib/contestant'

RSpec.describe Contestant do

  before do
    @alexander = Contestant.new({first_name: 'Alexander',
                                last_name: 'Aigiades',
                                age: 28,
                                state_of_residence: 'CO',
                                spending_money: 10
                                })

  end

  it 'should be an instance of a class' do
    expect(@alexander).to be_a Contestant
  end

  it 'should have attributes' do
    expect(@alexander.full_name).to eq('Alexander Aigiades')
    expect(@alexander.age).to eq 28
    expect(@alexander.state_of_residence).to eq ('CO')
    expect(@alexander.spending_money).to eq 10
    expect(@alexander.game_interests).to eq ([])
    expect(@alexander.out_of_state?).to eq false 
  end




end
