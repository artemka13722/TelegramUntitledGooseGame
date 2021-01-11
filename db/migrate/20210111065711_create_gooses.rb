class CreateGooses < ActiveRecord::Migration[6.0]
  def change
    create_table :gooses do |t|
      t.string :name
      t.string :level
      t.boolean :alive
      t.integer :fun
      t.integer :mana
      t.integer :health
      t.integer :weariness
      t.integer :money
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
