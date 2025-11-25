class TraceabilityConsult < ApplicationRecord
  belongs_to :consultation, optional: true 
  belongs_to :user, optional: true 
  belongs_to :client_user, optional: true 
  belongs_to :doctor_consult, class_name: 'User', foreign_key: 'doctor_id', optional: true
  belongs_to :assign_consult, class_name: 'User', foreign_key: 'assign_consult_id', optional: true
  belongs_to :reassign_consult, class_name: 'User', foreign_key: 'reassign_consult_id', optional: true
  belongs_to :search_patient_consult, class_name: 'ClientUser', foreign_key: 'seach_patient_id', optional: true
  belongs_to :response_req, class_name: 'User', foreign_key: 'response_req_id', optional: true
  belongs_to :reject_req, class_name: 'User', foreign_key: 'reject_req_id', optional: true
  belongs_to :view_consult, class_name: 'User', foreign_key: 'view_consult_id', optional: true
  belongs_to :patient_specialist, class_name: 'User', foreign_key: 'patient_specialist_id', optional: true
end
