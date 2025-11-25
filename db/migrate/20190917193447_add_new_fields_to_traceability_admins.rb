class AddNewFieldsToTraceabilityAdmins < ActiveRecord::Migration[5.1]
  def change
    add_column :traceability_admins, :assign_consult_id, :integer
    add_column :traceability_admins, :reassign_consult_id, :integer
    add_column :traceability_admins, :assign_control_id, :integer
    add_column :traceability_admins, :reassign_control_id, :integer
    add_reference :traceability_admins, :consultation, foreign_key: true
    add_reference :traceability_admins, :consultation_control, foreign_key: true
  end
end
