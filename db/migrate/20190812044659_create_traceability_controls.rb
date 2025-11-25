class CreateTraceabilityControls < ActiveRecord::Migration[5.1]
  def change
    create_table :traceability_controls do |t|
      t.integer :doctor_id
      t.references :consultation_control, foreign_key: true
      t.references :user, foreign_key: true
      t.integer :assign_control_id
      t.integer :reassign_control_id
      t.integer :seach_patient_id
      t.references :client_user, foreign_key: true
      t.boolean :shared_clinic_history, default: false
      t.boolean :print_clinic_history, default: false

      t.timestamps
    end
  end
end
