class CreateRsiWarnings < ActiveRecord::Migration
  def change
    create_table :rsi_warnings do |t|
      t.integer :stock_id
      t.decimal :low_warning
      t.decimal :high_warning

      t.timestamps null: false
    end
  end
end
