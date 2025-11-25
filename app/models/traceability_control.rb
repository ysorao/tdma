class TraceabilityControl < ApplicationRecord
  belongs_to :consultation_control, optional: true 
  belongs_to :user, optional: true 
  belongs_to :client_user, optional: true 
  belongs_to :doctor_control, class_name: 'User', foreign_key: 'doctor_id', optional: true
  belongs_to :assign_control, class_name: 'User', foreign_key: 'assign_control_id', optional: true
  belongs_to :reassign_control, class_name: 'User', foreign_key: 'reassign_control_id', optional: true
  belongs_to :seach_patient_control, class_name: 'ClientUser', foreign_key: 'seach_patient_id', optional: true
  belongs_to :response_req_control, class_name: 'User', foreign_key: 'response_req_id', optional: true
  belongs_to :reject_req_control, class_name: 'User', foreign_key: 'reject_req_id', optional: true
  belongs_to :view_control, class_name: 'User', foreign_key: 'view_control_id', optional: true
  belongs_to :patient_specialist_control, class_name: 'User', foreign_key: 'patient_specialist_id', optional: true
end
