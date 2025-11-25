class AddFieldsFromContract < ActiveRecord::Migration[5.1]
  def change
    add_column :contracts, :date_init, :date
    add_column :contracts, :date_end, :date
  end
end
