class CreateStockValues < ActiveRecord::Migration
  def change
    create_table :stock_values do |t|
      t.integer :stock_id
      t.decimal :average_daily_volume
      t.decimal :change
      t.decimal :change_in_percent
      t.decimal :close_value
      t.decimal :high
      t.decimal :low
      t.decimal :open_value
      t.decimal :pe_ratio
      t.decimal :previous_close
      t.decimal :volume
      t.decimal :rsi
      t.string :date

      t.timestamps null: false
    end
  end
end
