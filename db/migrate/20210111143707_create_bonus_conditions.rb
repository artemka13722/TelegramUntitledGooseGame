class CreateBonusConditions < ActiveRecord::Migration[6.0]
  def change
    create_table :bonus_conditions do |t|
      t.string :error_message
      t.boolean :fun
      t.boolean :mana
      t.boolean :health
      t.boolean :weariness
      t.boolean :money
      t.integer :min
      t.integer :max
      t.references :bonus_action, null: false, foreign_key: true

      t.timestamps
    end
  end
end
