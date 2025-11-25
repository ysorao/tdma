class AddTypeFromTraceabilityControl < ActiveRecord::Migration[5.1]
  def change
    add_column :traceability_controls, :type_condition, :boolean, default: true
  end
end
