class AddFieldFromContract < ActiveRecord::Migration[5.1]
  def change
    add_column :contracts, :observations, :text
    add_column :contracts, :date_end_addition, :datetime
  end
end
