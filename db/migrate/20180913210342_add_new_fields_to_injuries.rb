class AddNewFieldsToInjuries < ActiveRecord::Migration[5.1]
  def change
    add_column :injuries, :description, :text
    add_column :injuries, :case_analysis, :text
  end
end
