class CreatePrepayCardClients < ActiveRecord::Migration[5.1]
  def change
    create_table :prepay_card_clients do |t|
      t.datetime :purchase_date
      t.references :prepay_card, foreign_key: true
      t.references :contract, foreign_key: true
      t.references :client, foreign_key: true

      t.timestamps
    end
  end
end
