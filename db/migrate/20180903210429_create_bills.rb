class CreateBills < ActiveRecord::Migration[5.1]
  def change
    create_table :bills do |t|
      t.string :payment_file
      t.boolean :enabled_payment
      t.string :bill_file
      t.string :code
      t.datetime :date_expedition
      t.references :contract, foreign_key: true

      t.timestamps
    end
  end
end
