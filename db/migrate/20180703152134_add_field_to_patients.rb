class AddFieldToPatients < ActiveRecord::Migration[5.1]
  def change
    add_column :patients, :number_inpec, :string
  end
end
