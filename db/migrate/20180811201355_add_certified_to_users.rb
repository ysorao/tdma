class AddCertifiedToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :certified, :boolean, default: false
  end
end
