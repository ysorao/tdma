class AdditionalCard < ApplicationRecord
  belongs_to :contract, optional: true
  belongs_to :client, optional: true
  belongs_to :prepay_card, optional: true
  has_many :traceability_admins, dependent: :destroy

  validates :contract_id, :prepay_card_id, :end_date, presence: true

  #Estados
  INACTIVO = 0
  ACTIVO = 1

  before_create :extra_information
	  
	def extra_information
    self.status = 0
	  contrato = Contract.find(self.contract_id)
    tarjeta = PrepayCard.find(self.prepay_card_id)
    self.client_id = contrato.client_id
	end
end
