class Insurance < ApplicationRecord

  has_many :patient_informations
  has_many :ips_insurances
end
