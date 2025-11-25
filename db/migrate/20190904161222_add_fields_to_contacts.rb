class AddFieldsToContacts < ActiveRecord::Migration[5.1]
  def change
    add_column :contacts, :response_contact, :string
    add_column :contacts, :status, :integer
    add_reference :contacts, :admin_user, foreign_key: true
    add_reference :contacts, :designed_response, foreign_key: true
  end
end
