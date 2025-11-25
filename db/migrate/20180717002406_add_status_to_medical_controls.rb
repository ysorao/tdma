class AddStatusToMedicalControls < ActiveRecord::Migration[5.1]
  def change
    add_column :medical_controls, :status, :integer
  end
end
