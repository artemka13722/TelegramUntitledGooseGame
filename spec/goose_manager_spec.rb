require_relative 'rails_helper'
require_relative './../core/engine'
require_relative './../core/goose_manager'
require File.expand_path('../config/environment', __dir__)

RSpec.describe GooseManager do
  describe 'Checking database name' do
    it {
      expect(ActiveRecord::Base.connection_config[:database]).to match('telegram_test')
    }
  end

  describe 'Checking goose creation' do
    mng = described_class.new
    mng.create_goose(228, 'goose_easy', 'easy')
    goose_easy = mng.get_goose(228)
    mng.create_goose(229, 'goose_middle', 'middle')
    goose_middle = mng.get_goose(229)
    mng.create_goose(230, 'goose_hard', 'hard')
    goose_hard = mng.get_goose(230)
    it {
      expect(goose_easy.name).to eq('goose_easy')
    }

    it {
      expect(goose_easy.alive).to be true
    }

    it {
      expect(goose_easy.fun).to eq(100)
    }

    it {
      expect(goose_easy.mana).to eq(0)
    }

    it {
      expect(goose_easy.health).to eq(100)
    }

    it {
      expect(goose_easy.weariness).to eq(0)
    }

    it {
      expect(goose_easy.money).to eq(100)
    }

    it {
      expect(goose_middle.name).to eq('goose_middle')
    }

    it {
      expect(goose_middle.fun).to eq(50)
    }

    it {
      expect(goose_middle.mana).to eq(0)
    }

    it {
      expect(goose_middle.health).to eq(50)
    }

    it {
      expect(goose_middle.weariness).to eq(0)
    }

    it {
      expect(goose_middle.money).to eq(50)
    }

    it {
      expect(goose_hard.name).to eq('goose_hard')
    }

    it {
      expect(goose_hard.fun).to eq(10)
    }

    it {
      expect(goose_hard.mana).to eq(0)
    }

    it {
      expect(goose_hard.health).to eq(10)
    }

    it {
      expect(goose_hard.weariness).to eq(0)
    }

    it {
      expect(goose_hard.money).to eq(10)
    }
  end

  describe 'Checking goose checkers' do
    mng = described_class.new
    mng.create_goose(322, 'goose', 'easy')
    goose = mng.get_goose(322)
    status_health1, message_health1 = mng.check_health(goose)
    status_mana1, message_mana1 = mng.check_mana(goose)
    status_fun1, message_fun1 = mng.check_fun(goose)
    status_weariness1, message_weariness1 = mng.check_weariness(goose)
    status_money1, message_money1 = mng.check_money(goose)
    it {
      expect(status_health1).to eq(true)
    }

    it {
      expect(message_health1).to eq(nil)
    }

    it {
      expect(status_mana1).to eq(true)
    }

    it {
      expect(message_mana1).to eq(nil)
    }

    it {
      expect(status_fun1).to eq(true)
    }

    it {
      expect(message_fun1).to eq(nil)
    }

    it {
      expect(status_weariness1).to eq(true)
    }

    it {
      expect(message_weariness1).to eq(nil)
    }

    it {
      expect(status_money1).to eq(true)
    }

    it {
      expect(message_money1).to eq(nil)
    }

    goose.health = 0
    status_health2, message_health2 = mng.check_health(goose)
    goose.mana = 100
    status_mana2, message_mana2 = mng.check_mana(goose)
    goose.fun = 0
    status_fun2, message_fun2 = mng.check_fun(goose)
    goose.weariness = 100
    status_weariness2, message_weariness2 = mng.check_weariness(goose)
    goose.money = -50
    status_money2, message_money2 = mng.check_money(goose)
    it {
      expect(status_health2).to eq(false)
    }

    it {
      expect(message_health2).to eq('Ваш гусь goose, сдох')
    }

    it {
      expect(status_mana2).to eq(false)
    }

    it {
      expect(message_mana2).to eq('Ваш гусь goose, попал в хогвардс')
    }

    it {
      expect(status_fun2).to eq(false)
    }

    it {
      expect(message_fun2).to eq('У вашего гуся goose, появились суецидальные мысли...')
    }

    it {
      expect(status_weariness2).to eq(false)
    }

    it {
      expect(message_weariness2).to eq('Ваш гусь goose, добегался...')
    }

    it {
      expect(status_money2).to eq(false)
    }

    it {
      expect(message_money2).to eq('За вашим гусем goose, выехали коллекторы...')
    }
  end

  describe 'Checking goose stat changer' do
    mng = described_class.new
    mng.create_goose(1488, 'goose', 'easy')
    goose = mng.get_goose(1488)
    mng.create_goose(1489, 'mod', 'easy')
    mod = mng.get_goose(1489)
    mod.health = -1
    mod.mana = 2
    mod.fun = -3
    mod.weariness = 4
    mod.money = 5
    mng.add_changes(goose, mod)
    it {
      expect(goose.health).to eq(99)
    }

    it {
      expect(goose.mana).to eq(2)
    }

    it {
      expect(goose.fun).to eq(97)
    }

    it {
      expect(goose.weariness).to eq(4)
    }

    it {
      expect(goose.money).to eq(105)
    }
  end
end
