class AddFieldsToDiseases < ActiveRecord::Migration[5.1]
  def change
    add_column :diseases, :diagnostic_code, :string
    add_column :diseases, :oid_dgh, :string
    add_column :diseases, :type_initial_age, :string
    add_column :diseases, :initial_age_value, :string
    add_column :diseases, :type_final_age, :string
    add_column :diseases, :final_age_value, :string
    add_column :diseases, :apply_to_sex, :string
    add_column :diseases, :requires_notification, :string
    add_column :diseases, :external_cause, :string
    add_column :diseases, :registration_locked, :string
    add_column :diseases, :diagnosis_resolution_000247, :string
  end
end
