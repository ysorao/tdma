class AddDetailsToTraceabilityConsults < ActiveRecord::Migration[5.1]
  def change
    add_column :traceability_consults, :response_req_id, :integer
    add_column :traceability_consults, :reject_req_id, :integer
    add_column :traceability_consults, :view_consult_id, :integer
    add_column :traceability_consults, :patient_specialist_id, :integer
  end
end
