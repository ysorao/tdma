class TraceabilityClient < ApplicationRecord
  belongs_to :client_user, optional: true
  belongs_to :create_patient, class_name: 'ClientUser', foreign_key: 'create_patient_id', optional: true
end
