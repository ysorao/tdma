class AddDetailsToTraceabilityControls < ActiveRecord::Migration[5.1]
  def change
    add_column :traceability_controls, :response_req_id, :integer
    add_column :traceability_controls, :reject_req_id, :integer
    add_column :traceability_controls, :view_control_id, :integer
    add_column :traceability_controls, :patient_specialist_id, :integer
  end
end
