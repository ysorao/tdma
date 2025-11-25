class CreatePaymentHistories < ActiveRecord::Migration[5.1]
  def change
    create_table :payment_histories do |t|
      t.integer :credits
      t.references :consultation, foreign_key: true
      t.references :consultation_control, foreign_key: true
      t.references :device, foreign_key: true

      t.timestamps
    end
  end
end
