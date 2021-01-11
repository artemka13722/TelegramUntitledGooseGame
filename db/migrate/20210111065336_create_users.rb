class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :telegram_id
      t.string :current_goose_name

      t.timestamps
    end
  end
end
