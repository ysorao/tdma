class AddFieldsFromRequest < ActiveRecord::Migration[5.1]
  def change
    add_column :requests, :reason, :integer
    add_column :requests, :other_reason, :string
  end
end
