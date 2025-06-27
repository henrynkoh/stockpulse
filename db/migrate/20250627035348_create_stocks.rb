class CreateStocks < ActiveRecord::Migration[7.2]
  def change
    create_table :stocks do |t|
      t.string :ticker
      t.string :sector
      t.float :price
      t.integer :volume
      t.float :rsi
      t.float :short_volume
      t.float :short_percent
      t.string :sentiment
      t.string :signal
      t.string :news_url

      t.timestamps
    end
    add_index :stocks, :ticker
  end
end
