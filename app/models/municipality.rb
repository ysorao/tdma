class Municipality < ApplicationRecord
  belongs_to :department
  has_many :patient_informations
  has_many :subsidiaries
  has_many :clients
end
