class AddFieldsToKits < ActiveRecord::Migration[5.1]
  def change
    add_column :kits, :is_comodato, :boolean, default: false
    add_column :kits, :init_date, :datetime
    add_column :kits, :end_date, :datetime
  end
end
