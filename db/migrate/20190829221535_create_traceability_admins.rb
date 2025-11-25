class CreateTraceabilityAdmins < ActiveRecord::Migration[5.1]
  def change
    create_table :traceability_admins do |t|
      t.references :admin_user, foreign_key: true
      t.boolean :create_admin, default: false
      t.boolean :update_admin, default: false
      t.boolean :delete_admin, default: false
      t.boolean :activate_admin, default: false
      t.boolean :desactivate_admin, default: false
      t.integer :user_admin_id
      t.boolean :create_user, default: false
      t.boolean :delete_user, default: false
      t.boolean :activate_user, default: false
      t.boolean :desactivate_user, default: false
      t.references :user, foreign_key: true
      t.boolean :delete_contact, default: false
      t.boolean :create_client, default: false
      t.boolean :update_client, default: false
      t.boolean :activate_client, default: false
      t.boolean :desactivate_client, default: false
      t.references :client, foreign_key: true
      t.boolean :create_user_client, default: false
      t.boolean :update_user_client, default: false
      t.references :client_user, foreign_key: true
      t.boolean :create_contract, default: false
      t.boolean :delete_contract, default: false
      t.references :contract, foreign_key: true
      t.boolean :create_bill, default: false
      t.boolean :update_bill, default: false
      t.boolean :delete_bill, default: false
      t.references :bill, foreign_key: true
      t.boolean :create_addition_contract, default: false
      t.references :additional_card, foreign_key: true
      t.boolean :create_kit, default: false
      t.boolean :delete_kit, default: false
      t.references :kit, foreign_key: true
      t.boolean :create_device, default: false
      t.boolean :update_device, default: false
      t.boolean :delete_device, default: false
      t.references :device, foreign_key: true
      t.boolean :create_manual_system, default: false
      t.boolean :update_manual_system, default: false
      t.boolean :delete_manual_system, default: false
      t.references :system_manual, foreign_key: true
      t.boolean :assign_help_desk, default: false
      t.boolean :reassign_help_desk, default: false
      t.boolean :response_help_desk, default: false
      t.references :help_desk, foreign_key: true
      t.boolean :create_prepay_card, default: false
      t.boolean :update_prepay_card, default: false
      t.boolean :delete_prepay_card, default: false
      t.references :prepay_card, foreign_key: true
      t.boolean :create_version, default: false
      t.boolean :update_version, default: false
      t.boolean :delete_version, default: false
      t.references :app_version, foreign_key: true

      t.timestamps
    end
  end
end
