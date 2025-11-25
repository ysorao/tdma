class TraceabilityAdmin < ApplicationRecord
  belongs_to :admin_user, optional: true
  belongs_to :user, optional: true
  belongs_to :client, optional: true
  belongs_to :client_user, optional: true
  belongs_to :contract, optional: true
  belongs_to :bill, optional: true
  belongs_to :additional_card, optional: true
  belongs_to :kit, optional: true
  belongs_to :device, optional: true
  belongs_to :system_manual, optional: true
  belongs_to :contact, optional: true
  belongs_to :help_desk, optional: true
  belongs_to :prepay_card, optional: true
  belongs_to :app_version, optional: true
  belongs_to :consultation, optional: true
  belongs_to :consultation_control, optional: true
  belongs_to :user_admin, class_name: 'AdminUser', foreign_key: 'user_admin_id', optional: true
  belongs_to :assign_consult, class_name: 'User', foreign_key: 'assign_consult_id', optional: true
  belongs_to :reassign_consult, class_name: 'User', foreign_key: 'reassign_consult_id', optional: true
  belongs_to :assign_control, class_name: 'User', foreign_key: 'assign_control_id', optional: true
  belongs_to :reassign_control, class_name: 'User', foreign_key: 'reassign_control_id', optional: true
end
