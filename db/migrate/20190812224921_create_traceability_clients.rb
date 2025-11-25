class CreateTraceabilityClients < ActiveRecord::Migration[5.1]
  def change
    create_table :traceability_clients do |t|
      t.references :client_user, foreign_key: true
      t.integer :create_patient_id
      t.boolean :shared_clinic_history, default: false
      t.boolean :print_clinic_history, default: false

      t.timestamps
    end
  end
end
