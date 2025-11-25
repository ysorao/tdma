class CreateContracts < ActiveRecord::Migration[5.1]
  def change
    create_table :contracts do |t|
      t.integer :status
      t.datetime :agreement_date
      t.string :contract_number
      t.references :client, foreign_key: true

      t.timestamps
    end
  end
end
