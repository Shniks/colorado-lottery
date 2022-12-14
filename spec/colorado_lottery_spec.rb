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
    result = {"Pick 4" => [@alexander], "Mega Millions" => [@alexander, @frederick, @winston], "Cash 5" => [@winston]}

    expect(@lottery.registered_contestants).to eq(result)
  end

  it 'should be able to find list of elegible contestants' do
    @lottery.register_contestant(@alexander, @pick_4)
    @lottery.register_contestant(@alexander, @mega_millions)
    @lottery.register_contestant(@frederick, @mega_millions)
    @lottery.register_contestant(@winston, @cash_5)
    @lottery.register_contestant(@winston, @mega_millions)

    grace = Contestant.new({
                            first_name: 'Grace',
                            last_name: 'Hopper',
                            age: 20,
                            state_of_residence: 'CO',
                            spending_money: 20
                            })

    grace.add_game_interest('Mega Millions')
    grace.add_game_interest('Cash 5')
    grace.add_game_interest('Pick 4')
    @lottery.register_contestant(grace, @mega_millions)
    @lottery.register_contestant(grace, @cash_5)
    @lottery.register_contestant(grace, @pick_4)
    result = {"Pick 4" => [@alexander, grace], "Mega Millions" => [@alexander, @frederick, @winston, grace], "Cash 5" => [@winston, grace]}

    expect(@lottery.registered_contestants).to eq(result)
    expect(@lottery.eligible_contestants(@pick_4)).to eq([@alexander, grace])
    expect(@lottery.eligible_contestants(@cash_5)).to eq([@winston, grace])
    expect(@lottery.eligible_contestants(@mega_millions)).to eq([@alexander, @frederick, @winston, grace])
  end

  it 'should be able to charge contestants for a game' do
    @lottery.register_contestant(@alexander, @pick_4)
    @lottery.register_contestant(@alexander, @mega_millions)
    @lottery.register_contestant(@frederick, @mega_millions)
    @lottery.register_contestant(@winston, @cash_5)
    @lottery.register_contestant(@winston, @mega_millions)

    grace = Contestant.new({
                            first_name: 'Grace',
                            last_name: 'Hopper',
                            age: 20,
                            state_of_residence: 'CO',
                            spending_money: 20
                            })

    grace.add_game_interest('Mega Millions')
    grace.add_game_interest('Cash 5')
    grace.add_game_interest('Pick 4')
    @lottery.register_contestant(grace, @mega_millions)
    @lottery.register_contestant(grace, @cash_5)
    @lottery.register_contestant(grace, @pick_4)
    @lottery.charge_contestants(@cash_5)
    result = {@cash_5 => ["Winston Churchill", "Grace Hopper"]}

    expect(@lottery.current_contestants).to eq(result)
    expect(grace.spending_money).to eq 19
    expect(@winston.spending_money).to eq 4

    @lottery.charge_contestants(@mega_millions)
    result = {@cash_5 => ["Winston Churchill", "Grace Hopper"],
              @mega_millions => ["Alexander Aigades", "Frederick Douglass", "Grace Hopper"]
              }

    expect(@lottery.current_contestants).to eq(result)
    expect(grace.spending_money).to eq 14
    expect(@winston.spending_money).to eq 4
    expect(@alexander.spending_money).to eq 5
    expect(@frederick.spending_money).to eq 15

    @lottery.charge_contestants(@pick_4)
    result = {@cash_5 => ["Winston Churchill", "Grace Hopper"],
              @mega_millions => ["Alexander Aigades", "Frederick Douglass", "Grace Hopper"],
              @pick_4 => ["Alexander Aigades", "Grace Hopper"]
              }

    expect(@lottery.current_contestants).to eq(result)
  end

  it 'should be able to pick and announce winners for drawings' do
    @lottery.register_contestant(@alexander, @pick_4)
    @lottery.register_contestant(@alexander, @mega_millions)
    @lottery.register_contestant(@frederick, @mega_millions)
    @lottery.register_contestant(@winston, @cash_5)
    @lottery.register_contestant(@winston, @mega_millions)

    grace = Contestant.new({
                            first_name: 'Grace',
                            last_name: 'Hopper',
                            age: 20,
                            state_of_residence: 'CO',
                            spending_money: 20
                            })

    grace.add_game_interest('Mega Millions')
    grace.add_game_interest('Cash 5')
    grace.add_game_interest('Pick 4')

    @lottery.register_contestant(grace, @mega_millions)
    @lottery.register_contestant(grace, @cash_5)
    @lottery.register_contestant(grace, @pick_4)

    @lottery.charge_contestants(@cash_5)
    @lottery.charge_contestants(@mega_millions)
    @lottery.charge_contestants(@pick_4)

    result = @lottery.draw_winners

    expect(result).to be_a String
    expect(@lottery.winners).to be_a Array
    expect(@lottery.winners.first).to be_a Hash
    expect(@lottery.winners.last).to be_a Hash
    expect(@lottery.winners.length).to eq 3

    winners_stub = [{"Grace Hopper" => "Pick 4"},
                    {"Winston Churchill" => "Cash 5"},
                    {"Frederick Douglass" => "Mega Millions"}]

    date_stub = "2022-04-07"

    allow(@lottery).to receive(:winners).and_return(winners_stub) #Created stub for winners
    allow(@lottery).to receive(:date_of_drawing).and_return(date_stub) #Created stub for date

    result = @lottery.announce_winner("Pick 4")
    expect(result).to eq("Grace Hopper won the Pick 4 on 04/07")

    result = @lottery.announce_winner("Cash 5")
    expect(result).to eq("Winston Churchill won the Cash 5 on 04/07")

    result = @lottery.announce_winner("Mega Millions")
    expect(result).to eq("Frederick Douglass won the Mega Millions on 04/07")
  end

end
