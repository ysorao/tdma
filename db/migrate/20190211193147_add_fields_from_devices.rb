class AddFieldsFromDevices < ActiveRecord::Migration[5.1]
  def change
    add_column :devices, :observations, :text
    add_column :devices, :cell_brand, :string
    add_column :devices, :system_version, :string
  end
end
