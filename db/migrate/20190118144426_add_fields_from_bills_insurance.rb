class AddFieldsFromBillsInsurance < ActiveRecord::Migration[5.1]
  def change
    add_column :bills_insurances, :value_consultation, :integer
    add_column :bills_insurances, :value_moderator_fee, :integer
  end
end
