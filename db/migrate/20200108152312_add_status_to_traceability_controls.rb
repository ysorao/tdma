class AddStatusToTraceabilityControls < ActiveRecord::Migration[5.1]
  def change
    add_column :traceability_controls, :status, :integer
  end
end
