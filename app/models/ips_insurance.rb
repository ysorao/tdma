class IpsInsurance < ApplicationRecord
  belongs_to :client, optional: true
  belongs_to :insurance, optional: true
  has_many :bills_insurances, :dependent => :restrict_with_error

  validates :insurance_id, presence: true
end
