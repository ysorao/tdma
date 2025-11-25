class AddFieldsToAdminUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :admin_users, :name, :string
    add_column :admin_users, :surnames, :string
    add_column :admin_users, :number_document, :string
    add_column :admin_users, :phone, :string
    add_column :admin_users, :status, :integer
  end
end
