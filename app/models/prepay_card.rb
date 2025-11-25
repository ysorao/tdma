class PrepayCard < ApplicationRecord

  has_many :prepay_card_clients
  has_many :additional_cards
  has_many :traceability_admins, dependent: :destroy

  validates :name, :credits, presence: true

  attr_accessor :action
  attr_accessor :admin

  after_save :management_admin
    
  def management_admin
    if self.action == "new" || self.action == "create"
      TraceabilityAdmin.create(admin_user_id: self.admin, create_prepay_card: true, prepay_card_id: self.id)   
    elsif self.action == "edit" || self.action == "update"
      TraceabilityAdmin.create(admin_user_id: self.admin, update_prepay_card: true, prepay_card_id: self.id)
    end
  end

  #Metodo que permite sumar las tarjetas que se adicionaron en un contrato
  def self.prepay_additional(cliente)
    includes(:additional_cards).where("additional_cards.client_id = ? AND additional_cards.status = ?", cliente, AdditionalCard::ACTIVO).references(:additional_cards).sum(:credits)
  end
end
