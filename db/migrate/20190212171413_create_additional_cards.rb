class CreateAdditionalCards < ActiveRecord::Migration[5.1]
  def change
    create_table :additional_cards do |t|
      t.references :contract, foreign_key: true
      t.references :client, foreign_key: true
      t.references :prepay_card, foreign_key: true
      t.integer :status

      t.timestamps
    end
  end
end
