class AddStatusToTraceabilityConsults < ActiveRecord::Migration[5.1]
  def change
    add_column :traceability_consults, :status, :integer
  end
end
