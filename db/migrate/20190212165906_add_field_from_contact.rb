class AddFieldFromContact < ActiveRecord::Migration[5.1]
  def change
    add_column :contacts, :type_contact, :integer
  end
end
