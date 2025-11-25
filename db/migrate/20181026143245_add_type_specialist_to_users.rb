class AddTypeSpecialistToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :type_specialist, :integer
  end
end
