class PaymentHistory < ApplicationRecord
  belongs_to :consultation
  belongs_to :consultation_control
  belongs_to :device
end
