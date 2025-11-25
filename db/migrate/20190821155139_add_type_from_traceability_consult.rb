class AddTypeFromTraceabilityConsult < ActiveRecord::Migration[5.1]
  def change
    add_column :traceability_consults, :type_condition, :boolean, default: true
  end
end
