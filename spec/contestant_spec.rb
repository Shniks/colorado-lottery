require 'simplecov'
SimpleCov.start
require './spec/spec_helper'
require './lib/contestant'

RSpec.describe Contestant do
  it 'should be an instance of a class' do
    alexander = Contestant.new({first_name: 'Alexander',
                                last_name: 'Aigiades',
                                age: 28,
                                state_of_residence: 'CO',
                                spending_money: 10
                                })

    expect(alexander).to be_a Contestant 
  end


end
