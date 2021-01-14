#require 'rails_helper'
require_relative './../core/engine'
require_relative './../core/goose_manager'
require File.expand_path('../config/environment', __dir__)

RSpec.describe "zaz" do
  describe 'Checking goose creation' do
	mng = GooseManager.new
	mng = GooseManager.new
	mng = GooseManager.new
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
  
  describe 'Checking goose creation' do
    
  end
end