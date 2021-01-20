require_relative 'rails_helper'
require_relative './../core/engine'
require_relative './../core/goose_manager'
require_relative './../core/action_manager'
require File.expand_path('../config/environment', __dir__)

RSpec.describe ActionManager do
  gm = GooseManager.new
  mng = described_class.new(gm)
  describe 'Checking database name' do
    it {
      expect(ActiveRecord::Base.connection_config[:database]).to match('telegram_test')
    }
  end

  describe 'Checking condition_correct' do
    cond = ActionCondition.create
    cond.health = true
    cond.min = 5
    gm.create_goose(322, 'goose', 'easy')
    goose = gm.get_goose(322)
    it {
      expect(mng.condition_correct?(goose, cond)).to be true
    }

    d = User.find_by(telegram_id: 322)
    gm.delete_all_goose(322)
    d.delete
    cond.delete
  end
  
  describe 'Checking add_bonus' do
    bonus = BonusAction.create
	gm.create_goose(322, 'goose', 'easy')
	goose = gm.get_goose(322)
	cond = BonusCondition.create
    cond.health = true
	cond.error_message = 'lolkek'
    cond.min = 5
	bonus.bonus_conditions.push(cond)
	bonus.health = 0
	bonus.mana = 5
	bonus.money = 0
	bonus.weariness = 0
	bonus.fun = 0
	bonus.success_message = 'keklol'
	mng.add_bonus(goose, bonus)
	
	it {
      expect(goose.mana).to eq 5
    }
	
	d = User.find_by(telegram_id: 322)
    gm.delete_all_goose(322)
    d.delete
    bonus.delete
  end
  
  describe 'Checking run_action' do
    
    gm.create_goose(228, 'bird', 'easy')
	act = Action.new
	act.health = 0
	act.mana = 0
	act.money = 5
	act.weariness = 0
	act.fun = 0

	
	cond = ActionCondition.create
	cond.health = true
    cond.min = 5
	act.action_conditions.push(cond)
	
	bonus = BonusAction.create
	bcond = BonusCondition.create
    bcond.health = true
	bcond.error_message = 'lolkek'
    bcond.min = 5
	bonus.bonus_conditions.push(bcond)
	bonus.health = 0
	bonus.mana = 5
	bonus.money = 0
	bonus.weariness = 0
	bonus.fun = 0
	bonus.success_message = 'keklol'
	
	act.bonus_actions.push(bonus)
	
	mng.run_action(228, act)
	user = User.find_or_create_by(telegram_id: 228)
	goose = Goose.find_by(name: user.current_goose_name)
	it {
      expect(goose.money).to eq 105
    }
	d = User.find_by(telegram_id: 228)
    gm.delete_all_goose(228)
    d.delete
    act.delete
	cond.delete
	bcond.delete
	bonus.delete
  end
end
