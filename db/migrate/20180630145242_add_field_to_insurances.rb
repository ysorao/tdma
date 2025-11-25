class AddFieldToInsurances < ActiveRecord::Migration[5.1]
  def change
    add_column :insurances, :code, :string
  end
end
