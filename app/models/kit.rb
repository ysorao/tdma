class Kit < ApplicationRecord
  has_many :subsidiaries
  belongs_to :prepay_card_client, optional: true
  belongs_to :device, optional: true
  belongs_to :contract, optional: true
  has_many :devices, :dependent => :destroy
  has_many :help_desks, through: :devices
  has_many :traceability_admins, dependent: :destroy

  validates :code, :contract_id, presence: true
  validates :devices, :length => {minimum: 1, too_short: "al menos debe agregar"}
  

  accepts_nested_attributes_for :devices, allow_destroy: true
  attr_accessor :action
  attr_accessor :admin

  before_create :extra_information
  after_save :management_admin
    
  def extra_information
    contrato = Contract.find(self.contract_id)
    self.code_verified = true
    self.init_date = contract.date_init
    self.end_date = contract.date_end
  end

  def management_admin
    if self.action == "new" || self.action == "create"
      TraceabilityAdmin.create(admin_user_id: self.admin, create_kit: true, kit_id: self.id)   
    end
  end

  #kits asociados al cliente
  def self.kits_client(client_id)
  	sedes = Subsidiary.where(client_id: client_id).pluck(:kit_id)
    includes(:contract).where("kits.code_verified = ? AND contracts.client_id = ?", true, client_id).where.not(id: sedes).references(:contract)
  end
end
