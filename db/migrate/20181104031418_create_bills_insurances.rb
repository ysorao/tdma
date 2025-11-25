class CreateBillsInsurances < ActiveRecord::Migration[5.1]
  def change
    create_table :bills_insurances do |t|
      t.references :ips_insurance, foreign_key: true
      t.references :client, foreign_key: true
      t.string :bill_number
      t.date :bill_expedition_date
      t.date :init_date
      t.date :end_date
      t.string :administrator_entity_code
      t.string :administrator_entity_name
      t.string :contract_number
      t.string :benefits_plan
      t.string :policy_number
      t.integer :total_value_shared_payment
      t.integer :commision_value
      t.integer :total_value_discounts
      t.integer :net_to_pay_contract_entity

      t.timestamps
    end
  end
end
