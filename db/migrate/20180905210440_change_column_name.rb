class ChangeColumnName < ActiveRecord::Migration[5.1]
  def change
    rename_column :consultation_controls, :type, :type_professional
  end
end
