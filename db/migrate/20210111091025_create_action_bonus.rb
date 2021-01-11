class CreateActionBonus < ActiveRecord::Migration[6.0]
  def change
    create_table :actions_bonus do |t|
      t.integer :fun
      t.integer :mana
      t.integer :health
      t.integer :weariness
      t.integer :money

      t.timestamps
    end
  end
end
