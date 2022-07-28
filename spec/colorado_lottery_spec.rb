require 'simplecov'
SimpleCov.start
require './spec/spec_helper'
require './lib/colorado_lottery'

RSpec.describe ColoradoLottery do

  before do
    @lottery = ColoradoLottery.new
    @pick_4 = Game.new('Pick 4', 2)
    @mega_millions = Game.new('Mega Millions', 5, true)
    @cash_5 = Game.new('Cash 5', 1)
    @alexander = Contestant.new({
                                 first_name: 'Alexander',
                                 last_name: 'Aigades',
                                 age: 28,
                                 state_of_residence: 'CO',
                                 spending_money: 10
                                 })
    @benjamin = Contestant.new({
                                first_name: 'Benjamin',
                                last_name: 'Franklin',
                                age: 17,
                                state_of_residence: 'PA',
                                spending_money: 100
                                })
    @frederick = Contestant.new({
                                 first_name:  'Frederick',
                                 last_name: 'Douglass',
                                 age: 55,
                                 state_of_residence: 'NY',
                                 spending_money: 20
                                 })
    @winston = Contestant.new({
                                 first_name: 'Winston',
                                 last_name: 'Churchill',
                                 age: 18,
                                 state_of_residence: 'CO',
                                 spending_money: 5
                                 })

    @alexander.add_game_interest('Pick 4')
    @alexander.add_game_interest('Mega Millions')
    @frederick.add_game_interest('Mega Millions')
    @frederick.add_game_interest('Pick 4')
    @winston.add_game_interest('Cash 5')
    @winston.add_game_interest('Mega Millions')
    @benjamin.add_game_interest('Mega Millions')
  end

  it 'should belong to a class' do
    expect(@lottery).to be_a ColoradoLottery
  end

  it 'should have attributes' do
    expect(@lottery.registered_contestants).to eq({})
    expect(@lottery.winners).to eq([])
    expect(@lottery.current_contestants).to eq({})
  end

  it 'should determine if interested and 18' do
    expect(@lottery.interested_and_18?(@alexander, @pick_4)).to eq true
    expect(@lottery.interested_and_18?(@benjamin, @mega_millions)).to eq false
    expect(@lottery.interested_and_18?(@alexander, @cash_5)).to eq false
  end

  it 'should determine if contestant can register' do
    expect(@lottery.can_register?(@alexander, @pick_4)).to eq true
    expect(@lottery.can_register?(@alexander, @cash_5)).to eq false
    expect(@lottery.can_register?(@frederick, @mega_millions)).to eq true
    expect(@lottery.can_register?(@benjamin, @mega_millions)).to eq false
    expect(@lottery.can_register?(@frederick, @cash_5)).to eq false
    expect(@lottery.can_register?(@frederick, @pick_4)).to eq false   #added additional assertion for full test coverage
  end

  it 'should be able to register a contestant' do
    @lottery.register_contestant(@alexander, @pick_4)

    expect(@lottery.registered_contestants).to eq({"Pick 4" => [@alexander]})
  end

  it 'should be able to register multiple games for a contestant' do
    @lottery.register_contestant(@alexander, @pick_4)
    @lottery.register_contestant(@alexander, @mega_millions)
    result = {"Pick 4" => [@alexander], "Mega Millions" => [@alexander]}

    expect(@lottery.registered_contestants).to eq(result)
  end

  it 'should be able to register multiple games for multiple contestants' do
    @lottery.register_contestant(@alexander, @pick_4)
    @lottery.register_contestant(@alexander, @mega_millions)
    @lottery.register_contestant(@frederick, @mega_millions)
    @lottery.register_contestant(@winston, @cash_5)
    @lottery.register_contestant(@winston, @mega_millions)
    result = {"Pick 4" => [@alexander], "Mega Millions" => [@alexander, @frederick, @winstron], "Cash 5" => [@winston]}

    expect(@lottery.registered_contestants).to eq(result)
  end

end
