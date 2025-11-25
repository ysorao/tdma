class RequestExam < ApplicationRecord
  belongs_to :specialist_response, optional: true
  belongs_to :specialist_request_exam, class_name: 'User', foreign_key: 'specialist_id'

  validates :name_type_exam, :specialist_response_id, :specialist_id, presence: true
end
