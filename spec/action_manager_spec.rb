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

  describe 'Checking run_action' do
    it {
      expect(mng).to respond_to(:run_action).with(2).argument
    }
  end

  describe 'Checking add_bonus' do
    it {
      expect(mng).to respond_to(:add_bonus).with(2).argument
    }

    it {
      expect(mng).to respond_to(:add_bonuses).with(2).argument
    }
  end
end
