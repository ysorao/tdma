class CreateClients < ActiveRecord::Migration[5.1]
  def change
    create_table :clients do |t|
      t.integer :status
      t.integer :available_credits
      t.string :identification_number
      t.integer :type_identification
      t.string :business_name
      t.string :bill_number
      t.datetime :bill_expedition_date
      t.string :administrator_entity_code
      t.string :administrator_entity_name
      t.string :benefits_plan
      t.string :policy_number
      t.float :total_value_shared_payment
      t.float :commision_value
      t.float :total_value_discounts
      t.float :net_to_pay_contract_entity

      t.timestamps
    end
  end
end
