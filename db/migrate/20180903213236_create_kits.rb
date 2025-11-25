class CreateKits < ActiveRecord::Migration[5.1]
  def change
    create_table :kits do |t|
      t.string :code
      t.references :prepay_card_client, foreign_key: true
      t.references :device, foreign_key: true
      t.references :contract, foreign_key: true
      t.boolean :code_verified

      t.timestamps
    end
  end
end
