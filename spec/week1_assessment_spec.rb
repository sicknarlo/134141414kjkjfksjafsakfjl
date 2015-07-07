require_relative '../lib/week1_assessment'


describe Weapon do

  let(:weapon){ Weapon.new("FooWeapon", 10) }

  describe '#initialize' do

    it 'raises an exception if run without a name or value' do
      expect{ Weapon.new }.to raise_error
    end

    it "has a name attribute" do
      expect( weapon.name ).to eq( "FooWeapon" )
    end

    it "is given a damage value" do
      expect( weapon.damage ).to eq( 10 )
    end

    it 'has an unchangeable name' do
      expect( weapon).not_to respond_to(:name=)
    end

    it 'has an unchangeable damage value' do
      expect( weapon).not_to respond_to(:damage=)
    end

  end



end


describe BattleBot do

  let(:bot_name){ "FooBot" }
  let(:bot){ BattleBot.new( bot_name ) }
  let(:bot2){ BattleBot.new("BarBot") }


  describe '#initialize' do

    it "has a name" do
      expect( bot.name ).to eq( bot_name )
    end

    it "begins with 100 health" do
      expect( bot.health ).to eq( 100 )
    end

    it "cannot modify health directly" do
      expect{ bot.health = 500 }.to raise_error( NoMethodError )
    end

    it "does not have a weapon by default" do
      expect( bot.weapon ).to eq( nil )
    end

    it "is not dead" do
      expect( bot.dead? ).to eq( false )
    end
  end



  describe "interactions" do

    let(:weapon){ Weapon.new( "FooWeapon", 10 ) }
    let(:weapon2){ Weapon.new("Better Weapon", 20)}

    it "can pick up a weapon" do
      bot.pick_up weapon
      expect( bot.weapon ).to eq( weapon )
    end

    context "after picking up a weapon" do

      before do
        bot.pick_up weapon
      end

      it "can drop the weapon" do
        bot.drop_weapon
        expect( bot.weapon ).to eq( nil )
      end

      it "cannot pick up another weapon" do
        bot.pick_up weapon2
        expect( bot.weapon ).to eq( weapon )
      end

    end


    # describe '.count' do
    #   it 'returns 0 if no bots have been created' do
    #     expect(BattleBot.count).to eq(0)
    #   end

    #   it 'returns 1 if one bot has been created' do
    #     bot
    #     expect(BattleBot.count).to eq(1)
    #   end

    #   it 'returns 2 if one bot has been created' do
    #     bot
    #     bot2
    #     expect(BattleBot.count).to eq(2)
    #   end

    #   it 'returns only the number of LIVING bots' do
    #     bot
    #     bot2.take_damage(100)
    #     expect(BattleBot.count).to eq(1)
    #   end

    # end

    describe "doing battle" do

      context "without a weapon" do

        it "cannot attack" do
          expect{ bot.attack bot2 }.to raise_exception
        end

      end

      context "with a weapon" do

        before do
          bot.pick_up( weapon )
        end

        it "can attack another Battle Bot" do
          expect{ bot.attack bot2 }.to_not raise_exception
        end

        it 'cannot attack things that are not Battle Bots' do
          expect{ bot.attack [1,2,3]}.to raise_exception ArgumentError
        end

        context "after attacking another bot" do

          it "deals weapon damage with each attack" do
            expect( bot2 ).to receive(:take_damage).with(weapon.damage)
            bot.attack bot2
          end

        end

        context "after being attacked" do

          before { bot.attack bot2 }

          it "receives damage" do
            expect( bot2.health ).to eq( 100 - weapon.damage )
          end

        end

        context "after receiving damage" do

          it "checks if itself is dead" do
            expect( bot2 ).to receive(:dead?)
            bot.attack bot2
          end

        end
      end

      context "after receiving significant damage" do

        before do
          bot.take_damage(100)
        end

        it "is dead" do
          expect( bot.dead? ).to eq( true )
        end

      end

    end


    describe '#enemies' do
      let(:bot3){ BattleBot.new "BazBot"}

      it 'starts returning a blank array' do
        expect(bot.enemies).to eq([])
      end

      it 'returns an array of bots who attacked it' do
        [bot2, bot3].each do |b|
          b.pick_up weapon
          b.attack(bot)
        end
        expect(bot.enemies).to eq([bot2, bot3])
      end

      it 'does not count the same bot twice' do
        [bot2, bot2, bot3].each do |b|
          b.pick_up weapon
          b.attack(bot)
        end

        expect(bot.enemies).to eq([bot2, bot3])
      end

      it 'cannot be directly modified' do
        expect(bot).not_to respond_to(:enemies=)
      end


    end


  end

end
