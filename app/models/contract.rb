class Contract < ApplicationRecord
  belongs_to :client, optional: true
  has_many :bills
  has_many :prepay_card_clients, :dependent => :destroy
  has_many :kits
  has_many :additional_cards
  has_many :traceability_admins, dependent: :destroy

  validates :status, :agreement_date, :date_init, :date_end, :contract_number, :client_id, presence: true
  validates :prepay_card_clients, :length => {minimum: 1, too_short: "al menos debe agregar"}

  #accepts_nested_attributes_for :bills, allow_destroy: true
  accepts_nested_attributes_for :prepay_card_clients, allow_destroy: true

  attr_accessor :action
  attr_accessor :admin

  before_create :extra_information
  after_save :management_admin
    
  def extra_information
    cliente = Client.find(self.client_id)
  end

  def management_admin
    if self.action == "new" || self.action == "create"
      TraceabilityAdmin.create(admin_user_id: self.admin, create_contract: true, contract_id: self.id)   
    end
  end

  #CONSTANTES
  INACTIVO = 0
  ACTIVO = 1

  #Metodo que permite verificar cada dia tipo 6am si algun contrato ha finalizado con o sin tarjetas 
  #adicionales
  def self.expire_contract
    contrato = Contract.where(status: Contract::ACTIVO)
    contrato.each do |con|
      if con.date_end_addition.nil?
        if con.date_end < Time.now
          con.update_attribute(:status, Contract::INACTIVO)
          contrato_cliente = Contract.where(client_id: con.client_id)
          #Asi sea que haya un contrato activo y otros inactivos los usuarios siguen haciendo consultas
          if contrato_cliente.count > 1
            verificar = contrato_cliente.detect{|w| w.status == Contract::ACTIVO}
            if verificar.nil?
              EmailDocumentation.contract_expire(con).deliver_now
              User.user_contract(con.client_id, 0)
            end
          else
            EmailDocumentation.contract_expire(con).deliver_now
            User.user_contract(con.client_id, 0)
          end
        end
      else
        if con.date_end_addition < Time.now
          con.update_attribute(:status, Contract::INACTIVO)
          contrato_cliente = Contract.where(client_id: con.client_id)
          if contrato_cliente.count > 1
            verificar = contrato_cliente.detect{|w| w.status == Contract::ACTIVO}
            if verificar.nil?
              EmailDocumentation.contract_expire(con).deliver_now
              User.user_contract(con.client_id, 0)
            end
          else
            EmailDocumentation.contract_expire(con).deliver_now
            User.user_contract(con.client_id, 0)
          end
        end 
      end
    end
  end

  #prettier code formatter
  #React developer tools

  #Metodo que permite verificar cada dia tipo 6am si algun contrato esta proximo a vencerse
  def self.near_expire_contract
    contrato = Contract.where(status: Contract::ACTIVO)
    contrato.each do |con|
      if con.date_end_addition.nil?
        total = (con.date_end.to_date - con.date_init.to_date).to_i 
        clock = (total * 0.10).to_i
        time = clock == 0 ? 1 : clock.round
        if (con.date_end.to_date - time).to_date == Date.today
          EmailDocumentation.contract_near_expire(con).deliver_now
        end
      else
        total = (con.date_end_addition.to_date - con.date_init.to_date).to_i
        clock = (total * 0.10).to_i
        time = clock == 0 ? 1 : clock.round
        if (con.date_end_addition.to_date - time).to_date == Date.today
          EmailDocumentation.contract_near_expire(con).deliver_now
        end
      end
    end
  end
end
