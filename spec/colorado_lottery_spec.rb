require 'simplecov'
SimpleCov.start
require './spec/spec_helper'
require './lib/colorado_lottery'

RSpec.describe ColoradoLottery do

  before do
    @lottery = ColoradoLottery.new

  end

  it 'should belong to a class' do
    expect(@lottery).to be_a ColoradoLottery
  end

  it 'should have attributes' do
    expect(@lottery.registered_contestants).to eq({})
    expect(@lottery.winners).to eq([])
    expect(@lottery.current_contestants).to eq({})
  end

end
