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

  describe 'Checking param_correct' do
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
end
