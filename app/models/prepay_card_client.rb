class PrepayCardClient < ApplicationRecord
  belongs_to :prepay_card, optional: true
  belongs_to :contract, optional: true
  belongs_to :client, optional: true
  has_many :kits

  validates :purchase_date, :prepay_card_id, presence: true

  before_create :extra_information
  after_save :credits_client

  def extra_information
    self.client_id = self.contract.client_id
  end

  def credits_client
    self.client.update_attribute(:available_credits, PrepayCardClient.total_credits(self.client.id))
  end

  #CONSULTAS

  #Permite verificar si un usuario del cliente(IPS) tiene creditos disponibles
  #def self.enabled_credits(user)
    #includes(client: :user_clients).where("user_clients.user_id = ?", 1).references(client: :user_clients)
  #end

  #Total de los creditos asignados al cliente
  def self.total_credits(client)
    includes(:prepay_card).where("prepay_card_clients.client_id = ?", client).references(:prepay_card).sum("prepay_cards.credits")
  end
end
