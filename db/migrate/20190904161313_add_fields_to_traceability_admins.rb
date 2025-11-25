class AddFieldsToTraceabilityAdmins < ActiveRecord::Migration[5.1]
  def change
    add_column :traceability_admins, :name_complete_admin, :string
    add_column :traceability_admins, :document_admin, :string
    add_column :traceability_admins, :rol, :string
    add_column :traceability_admins, :name_complete_user, :string
    add_column :traceability_admins, :document_user, :string
    add_column :traceability_admins, :patients_attended, :integer
    add_column :traceability_admins, :contract_number, :string
    add_column :traceability_admins, :date_init, :datetime
    add_column :traceability_admins, :date_end, :datetime
    add_column :traceability_admins, :code_bill, :string
    add_column :traceability_admins, :date_expedition, :datetime
    add_column :traceability_admins, :code_kit, :string
    add_column :traceability_admins, :is_comodato, :boolean
    add_column :traceability_admins, :imei, :string
    add_column :traceability_admins, :name_card, :string
    add_column :traceability_admins, :credits, :string
    add_column :traceability_admins, :assign_contact, :boolean
    add_column :traceability_admins, :response_contact, :boolean
    add_reference :traceability_admins, :contact, foreign_key: true
    add_column :traceability_admins, :email, :string
    add_column :traceability_admins, :phone, :string
    add_column :traceability_admins, :name_manual, :string
    add_column :traceability_admins, :file_name, :string
  end
end
