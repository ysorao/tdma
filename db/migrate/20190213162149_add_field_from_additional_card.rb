class AddFieldFromAdditionalCard < ActiveRecord::Migration[5.1]
  def change
    add_column :additional_cards, :end_date, :datetime
  end
end
