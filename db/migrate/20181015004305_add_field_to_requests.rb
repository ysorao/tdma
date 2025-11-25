class AddFieldToRequests < ActiveRecord::Migration[5.1]
  def change
    add_column :requests, :nurse_id, :integer
  end
end
