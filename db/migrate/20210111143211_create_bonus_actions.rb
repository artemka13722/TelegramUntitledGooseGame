class CreateBonusActions < ActiveRecord::Migration[6.0]
  def change
    create_table :bonus_actions do |t|
      t.string :success_message
      t.integer :fun
      t.integer :mana
      t.integer :health
      t.integer :weariness
      t.integer :money
      t.references :action, null: false, foreign_key: true

      t.timestamps
    end
  end
end
