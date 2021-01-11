class CreateActions < ActiveRecord::Migration[6.0]
  def change
    create_table :actions do |t|
      t.string :name_show
      t.string :name_action
      t.integer :fun
      t.integer :mana
      t.integer :health
      t.integer :weariness
      t.integer :money

      t.timestamps
    end
  end
end
